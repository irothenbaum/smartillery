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
card_height    = floor(380 * 1.5)
card_half_h    = floor(card_height / 2)

// filled in each Draw so Step can detect clicks on the on-screen cycle arrows
left_arrow_bounds  = undefined
right_arrow_bounds = undefined

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
}

function confirm_selection() {
	if (is_locked) return
	if (is_taken_by_other(get_current_ultimate())) return

	set_player_ultimate(owner_player_id, get_current_ultimate())
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
