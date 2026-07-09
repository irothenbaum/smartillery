/// @description Per-player ultimate selection card

if (is_undefined(owner_player_id)) {
	owner_player_id = 0
}
if (is_undefined(device_index)) {
	device_index = global.player_device_map[$ owner_player_id] ?? -1
}

ultimate_names = variable_struct_get_names(global.ultimate_icons)
current_index  = 0
is_locked      = false

var _count    = get_players_count()
card_width     = floor(min(280, floor(room_width / _count) - 30) * 1.2)
card_half_w    = floor(card_width / 2)
// sized to comfortably fit the fixed 240x340 video preview area (see Draw) plus the
// label/header above it and the description/hint below it, without any of it crowding
card_height    = 660
card_half_h    = floor(card_height / 2)

// formalized preview-clip render target -- changing this means every exported clip
// (tools/crop_video.sh + tools/export_sprite_strip.sh output) needs to be re-cropped to match
video_width  = 240
video_height = 340

// filled in each Draw so Step can detect clicks on the on-screen cycle arrows
left_arrow_bounds  = undefined
right_arrow_bounds = undefined

// drives the video preview area's reveal/play/fade-back loop (see Draw and
// global.ultimate_preview_sprites), generic across every ultimate's preview clip:
// hold on a black + ult-icon title card for preview_hold_seconds -> fade it out over
// preview_fade_seconds (video paused on its first frame underneath) -> play through
// once -> fade back to black on the last frame over preview_fade_seconds -> repeat.
// Resets whenever the selected ultimate changes -- see cycle() below.
preview_elapsed      = 0
preview_hold_seconds = 3
preview_fade_seconds = 0.5
// 12fps is the formalized standard for these clips (see notes/GeneratingUltCardVideos
// for why) -- must match the "-f" value used when the clip was exported via
// tools/export_sprite_strip.sh, or playback speed will be wrong for that clip
video_playback_fps = 12

function get_current_ultimate() {
	return ultimate_names[current_index]
}

function is_taken_by_other(_ult_name) {
	var _ids = global.active_player_ids
	for (var _i = 0; _i < array_length(_ids); _i++) {
		var _pid = _ids[_i]
		if (_pid != owner_player_id && global.selected_ultimate[$ _pid] == _ult_name) {
			return true
		}
	}
	return false
}

function cycle(_dir) {
	if (is_locked) return
	var _n = array_length(ultimate_names)
	var _tries = 0
	do {
		current_index = (current_index + _dir + _n) mod _n
		_tries++
	} until (!is_taken_by_other(get_current_ultimate()) || _tries >= _n)
	// restart the reveal sequence for whichever ultimate we landed on
	preview_elapsed = 0
}

function confirm_selection() {
	if (is_locked) return
	if (is_taken_by_other(get_current_ultimate())) return

	// NOTE: calling set_player_ultimate directly with get_current_ultimate() nested
	// inline as the argument (e.g. set_player_ultimate(owner_player_id,
	// get_current_ultimate())) reproducibly fails to enter the function -- confirmed
	// across clean rebuilds and even a rename, so it isn't a caching/build artifact.
	// Pre-evaluating the arguments into locals and calling through an explicit
	// function-reference variable avoids it. Root cause not fully understood; treat
	// this shape as load-bearing if touching this call.
	var _pid = owner_player_id
	var _ult = get_current_ultimate()
	var _set_ultimate = set_player_ultimate
	_set_ultimate(_pid, _ult)

	is_locked = true
	_check_all_locked()
}

function _check_all_locked() {
	var _cards = get_array_of_instances(obj_select_ultimate)
	for (var _i = 0; _i < array_length(_cards); _i++) {
		if (!_cards[_i].is_locked) return
	}
	if (global.is_coop) {
		room_goto(rm_play_coop)
	} else {
		room_goto(rm_play_solo)
	}
}
