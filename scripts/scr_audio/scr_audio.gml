// Central audio wrapper. Gameplay code should never call audio_play_sound directly --
// go through play_sfx / play_ui_sfx / play_music so volume, voice limits and pausing stay consistent.
//
// Categories are emitters routed through their own buses (rather than audio groups) so we get
// per-category gain + effects without having to async-load groups.

#macro AUDIO_MASTER "master"
#macro AUDIO_MUSIC "music"
#macro AUDIO_SFX "sfx"

#macro AUDIO_SETTINGS_FILE "settings.ini"
#macro AUDIO_SETTINGS_SECTION "audio"

function __audio() {
	if (variable_global_exists("audio")) {
		return global.audio
	}

	var _sfx_bus = audio_bus_create()
	var _music_bus = audio_bus_create()
	// muffles music while paused -- bypassed during normal play
	_music_bus.effects[0] = audio_effect_create(AudioEffectType.LPF2, {cutoff: 700, q: 1, bypass: true})

	var _sfx_emitter = audio_emitter_create()
	var _ui_emitter = audio_emitter_create()
	var _music_emitter = audio_emitter_create()
	audio_emitter_bus(_sfx_emitter, _sfx_bus)
	audio_emitter_bus(_ui_emitter, _sfx_bus)
	audio_emitter_bus(_music_emitter, _music_bus)

	global.audio = {
		// slider values 0..1 (not gain -- see __volume_to_gain)
		volume: {master: 0.8, music: 0.7, sfx: 0.8},
		mute_on_focus_loss: true,
		has_focus: true,

		sfx_emitter: _sfx_emitter,
		ui_emitter: _ui_emitter,
		music_emitter: _music_emitter,
		music_bus: _music_bus,

		// pausable sfx currently alive: [{inst, key}]
		active_sfx: [],
		// sound name -> last real-time ms it was played (for rate limiting)
		last_played_ms: {},
		// multiplied into every new gameplay sfx's pitch (e.g. slow-mo)
		sfx_pitch_scale: 1,

		current_music: undefined,
		current_music_asset: undefined,
	}

	load_audio_settings()
	return global.audio
}

// sliders feel linear when gain is squared; a linear map puts all the change at the bottom
function __volume_to_gain(_value) {
	return _value * _value
}

function __apply_volumes() {
	var _a = __audio()
	audio_master_gain(_a.has_focus || !_a.mute_on_focus_loss ? __volume_to_gain(_a.volume.master) : 0)
	audio_emitter_gain(_a.sfx_emitter, __volume_to_gain(_a.volume.sfx))
	audio_emitter_gain(_a.ui_emitter, __volume_to_gain(_a.volume.sfx))
	audio_emitter_gain(_a.music_emitter, __volume_to_gain(_a.volume.music))
}

function __prune_active_sfx() {
	var _a = __audio()
	_a.active_sfx = array_filter(_a.active_sfx, function(_entry) {
		return audio_is_playing(_entry.inst) || audio_is_paused(_entry.inst)
	})
}

function __count_active(_key) {
	var _count = 0
	var _active = __audio().active_sfx
	for (var _i = 0; _i < array_length(_active); _i++) {
		if (_active[_i].key == _key) {
			_count++
		}
	}
	return _count
}

/// @param {Asset.GMSound|Array<Asset.GMSound>} _snd  pass an array of variants to pick one at random
/// @param {Struct} [_opts]
///   gain (1), pitch (1), pitch_variance (0.05), loop (false), priority (0),
///   min_interval_ms (30): skip if this sound played more recently than this
///   max_instances (4): skip if this many are already playing
///   pausable (true): paused/resumed along with the game
/// @returns {Id.Sound|Undefined} undefined when the play was rate limited
function play_sfx(_snd, _opts = {}) {
	var _a = __audio()
	var _variants = is_array(_snd) ? _snd : [_snd]
	// variants share one key so they share rate limits
	var _key = audio_get_name(_variants[0])

	var _gain = _opts[$ "gain"] ?? 1
	var _pitch = _opts[$ "pitch"] ?? 1
	var _pitch_variance = _opts[$ "pitch_variance"] ?? 0.05
	var _loop = _opts[$ "loop"] ?? false
	var _priority = _opts[$ "priority"] ?? 0
	var _min_interval_ms = _opts[$ "min_interval_ms"] ?? 30
	var _max_instances = _opts[$ "max_instances"] ?? 4
	var _pausable = _opts[$ "pausable"] ?? true

	// real time, not play time -- play time stops while paused but UI sounds still need limiting
	var _now = current_time
	var _last = _a.last_played_ms[$ _key]
	if (!is_undefined(_last) && _now - _last < _min_interval_ms) {
		return undefined
	}

	__prune_active_sfx()
	if (_pausable && __count_active(_key) >= _max_instances) {
		return undefined
	}

	var _variant = _variants[irandom(array_length(_variants) - 1)]
	if (_pausable) {
		_pitch *= _a.sfx_pitch_scale
	}
	_pitch *= 1 + random_range(-_pitch_variance, _pitch_variance)

	var _emitter = _pausable ? _a.sfx_emitter : _a.ui_emitter
	var _inst = audio_play_sound_on(_emitter, _variant, _loop, _priority, _gain, 0, _pitch)

	_a.last_played_ms[$ _key] = _now
	if (_pausable) {
		array_push(_a.active_sfx, {inst: _inst, key: _key})
	}
	return _inst
}

/// Menu / HUD sounds: keep playing while the game is paused and aren't voice-limited
function play_ui_sfx(_snd, _opts = {}) {
	var _ui_opts = variable_clone(_opts)
	_ui_opts.pausable = false
	_ui_opts[$ "pitch_variance"] = _opts[$ "pitch_variance"] ?? 0
	return play_sfx(_snd, _ui_opts)
}

/// Fades out before stopping -- cutting a waveform mid-cycle clicks
function stop_sfx(_inst, _fade_ms = 50) {
	if (is_undefined(_inst) || !(audio_is_playing(_inst) || audio_is_paused(_inst))) {
		return
	}
	if (_fade_ms <= 0) {
		audio_stop_sound(_inst)
		return
	}
	audio_sound_gain(_inst, 0, _fade_ms)
	call_later(_fade_ms / 1000, time_source_units_seconds, method({inst: _inst}, function() {
		audio_stop_sound(inst)
	}))
}

function stop_all_sfx(_fade_ms = 50) {
	var _active = __audio().active_sfx
	for (var _i = 0; _i < array_length(_active); _i++) {
		stop_sfx(_active[_i].inst, _fade_ms)
	}
	__audio().active_sfx = []
}

/// Scales pitch of current and future gameplay sfx (1 = normal). Hook for ult slow-mo.
function set_sfx_pitch_scale(_scale) {
	var _a = __audio()
	var _ratio = _scale / _a.sfx_pitch_scale
	_a.sfx_pitch_scale = _scale

	__prune_active_sfx()
	for (var _i = 0; _i < array_length(_a.active_sfx); _i++) {
		var _inst = _a.active_sfx[_i].inst
		audio_sound_pitch(_inst, audio_sound_get_pitch(_inst) * _ratio)
	}
}

/// Crossfades from whatever is playing. No-op if this track is already the current one.
function play_music(_snd, _fade_ms = 1000) {
	var _a = __audio()
	if (_a.current_music_asset == _snd && !is_undefined(_a.current_music) && audio_is_playing(_a.current_music)) {
		return _a.current_music
	}

	stop_music(_fade_ms)

	var _inst = audio_play_sound_on(_a.music_emitter, _snd, true, 100, 0)
	audio_sound_gain(_inst, 1, _fade_ms)
	_a.current_music = _inst
	_a.current_music_asset = _snd
	return _inst
}

function stop_music(_fade_ms = 1000) {
	var _a = __audio()
	stop_sfx(_a.current_music, _fade_ms)
	_a.current_music = undefined
	_a.current_music_asset = undefined
}

/// Called from set_paused. Gameplay sfx freeze, music keeps going but muffled, UI sfx unaffected.
function set_audio_paused(_paused) {
	var _a = __audio()
	__prune_active_sfx()
	for (var _i = 0; _i < array_length(_a.active_sfx); _i++) {
		var _inst = _a.active_sfx[_i].inst
		if (_paused) {
			audio_pause_sound(_inst)
		} else {
			audio_resume_sound(_inst)
		}
	}
	_a.music_bus.effects[0].bypass = !_paused
}

/// Call once per step from a persistent object
function audio_update() {
	var _a = __audio()
	var _focus = window_has_focus()
	if (_focus != _a.has_focus) {
		_a.has_focus = _focus
		__apply_volumes()
	}
}

/// @param {String} _category  AUDIO_MASTER, AUDIO_MUSIC or AUDIO_SFX
/// @param {Real} _value  0..1 slider value
function set_volume(_category, _value) {
	__audio().volume[$ _category] = clamp(_value, 0, 1)
	__apply_volumes()
}

function get_volume(_category) {
	return __audio().volume[$ _category]
}

function save_audio_settings() {
	var _volume = __audio().volume
	ini_open(AUDIO_SETTINGS_FILE)
	ini_write_real(AUDIO_SETTINGS_SECTION, AUDIO_MASTER, _volume.master)
	ini_write_real(AUDIO_SETTINGS_SECTION, AUDIO_MUSIC, _volume.music)
	ini_write_real(AUDIO_SETTINGS_SECTION, AUDIO_SFX, _volume.sfx)
	ini_close()
}

function load_audio_settings() {
	var _a = global.audio
	ini_open(AUDIO_SETTINGS_FILE)
	_a.volume.master = ini_read_real(AUDIO_SETTINGS_SECTION, AUDIO_MASTER, _a.volume.master)
	_a.volume.music = ini_read_real(AUDIO_SETTINGS_SECTION, AUDIO_MUSIC, _a.volume.music)
	_a.volume.sfx = ini_read_real(AUDIO_SETTINGS_SECTION, AUDIO_SFX, _a.volume.sfx)
	ini_close()
	__apply_volumes()
}
