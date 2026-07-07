global.my_steam_id = NON_STEAM_PLAYER

#macro NON_STEAM_PLAYER 999.1


function steam_get_user_sprite(_user_id, _size) {
	if (!steam_initialised()) {
		return -1
	}
	
	var _avatar_info = steam_get_user_avatar(_user_id, _size)
	return steam_image_create_sprite(_avatar_info)
}

function steam_image_create_sprite(_img) {
	var _dims = steam_image_get_size(_img)
	if (_dims == undefined) {
		return  -1
	}
	
	var _buff_size = _dims[0] * _dims[1] * 4
	var _cols = buffer_create(_buff_size, buffer_fixed, 1)
	var _sprite = -1
	if (steam_image_get_rgba(_img, _cols, _buff_size)) {
		var _surf = surface_create(_dims[0], _dims[1])
		buffer_set_surface(_cols, _surf, 0)
		_sprite = sprite_create_from_surface(_surf, 0, 0, _dims[0], _dims[1], false, false, 0, 0)
		surface_free(_surf)
	} else {
		// do nothing, sprite = -1
	}
	
	buffer_delete(_cols)
	return _sprite
}

/**
 * @returns {Real}
 */
function get_my_steam_id_safe() {
	if (steam_initialised()) {
		global.my_steam_id = steam_get_user_steam_id()
	} else {
		global.my_steam_id = NON_STEAM_PLAYER
	}
	return global.my_steam_id
}

/**
 * @param {Real} _player_id
 * @returns {Colour}
 */
function get_player_color(_player_id) {
	if (struct_exists(global.selected_ultimate, _player_id)) {
		return global.ultimate_colors[$ global.selected_ultimate[$ _player_id]]
	}
	return c_white
}

/**
 * @param {Real} _player_id
 * @returns {Colour}
 */
function get_player_color_tint(_player_id) {
	if (struct_exists(global.selected_ultimate, _player_id)) {
		return global.ultimate_color_tints[$ global.selected_ultimate[$ _player_id]]
	}
	return c_ltgrey
}

/**
 * @returns {Array<Real>}
 */
function get_streaking_player_ids() {
	var _gc = get_game_controller()
	return array_filter(get_player_ids(), method({_gc: _gc}, function(_pid) {
		return _gc.has_point_streak(_pid)
	}))
}

/**
 * blends the colors of every player currently on a point streak.
 * one player on streak returns their color as-is; multiple players blend evenly.
 * @param {Array<Real>} _default_arr -- used when no player is currently on streak
 * @returns {Array<Real>}
 */
function get_streak_color_array(_default_arr) {
	var _streaking = get_streaking_player_ids()
	var _count = array_length(_streaking)
	if (_count == 0) {
		return _default_arr
	}

	var _sum = [0, 0, 0]
	for (var _i = 0; _i < _count; _i++) {
		var _c = color_to_array(get_player_color(_streaking[_i]))
		_sum[0] += _c[0]
		_sum[1] += _c[1]
		_sum[2] += _c[2]
	}

	return [_sum[0] / _count, _sum[1] / _count, _sum[2] / _count]
}

/**
 * @param {Colour} _default_color -- used when no player is currently on streak
 * @returns {Colour}
 */
function get_streak_color(_default_color) {
	var _arr = get_streak_color_array(color_to_array(_default_color))
	return make_color_rgb(round(_arr[0] * 255), round(_arr[1] * 255), round(_arr[2] * 255))
}

/**
 * @param {Real} _player_id
 * @returns {Bool}
 */
function is_host(_player_id) {
	var _ids = global.active_player_ids
	return array_length(_ids) == 0 || _ids[0] == _player_id
}

/**
 * @param {method} _callback
 * @param {number?} _skip_player_id
 * @returns {Array<Any>}
 */
function for_each_player(_callback, _skip_player_id) {
	var _ret_val = []
	var _ids = array_length(global.active_player_ids) > 0
		? global.active_player_ids
		: [0] // by default assume just host
	for (var _i = 0; _i < array_length(_ids); _i++) {
		var _pid = _ids[_i]
		if (is_undefined(_skip_player_id) || _pid != _skip_player_id) {
			array_push(_ret_val, _callback(_pid))
		}
	}
	return _ret_val
}

/**
 * @returns {Real}
 */
function get_players_count() {
	var _count = array_length(global.active_player_ids)
	return _count > 0 ? _count : 1
}

/**
 * @returns {Array<number>}
 */
function get_player_ids() {
	return for_each_player(function(_p){return _p})
}

/**
 * @param {Real} _player_id
 * @returns {Real}
 */
function get_player_number(_player_id) {
	return array_get_index(global.active_player_ids, _player_id)
}

/**
 * @param {Real} _num
 * @returns {Real}
 */
function get_player_id_from_num(_num) {
	if (_num < array_length(global.active_player_ids)) {
		return global.active_player_ids[_num]
	}
	return 0
}