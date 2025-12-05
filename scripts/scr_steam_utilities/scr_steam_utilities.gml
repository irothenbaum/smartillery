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
 * @returns {Real}
 */
function get_my_color() {
	return get_player_color(get_my_steam_id_safe())
}

/**
 * @param {Real} _player_id
 * @returns {Bool}
 */
function is_host(_player_id) {
	return _player_id == NON_STEAM_PLAYER || _player_id == steam_lobby_get_owner_id(global.lobby_id)
}

/**
 * @param {method} _callback
 * @param {number?} _skip_player_id
 * @returns {Array<Any>}
 */
function for_each_player(_callback, _skip_player_id) {
	var _ret_val = []
	
	if (is_undefined(global.lobby_id)) {
		if (is_undefined(_skip_player_id) || _skip_player_id != get_my_steam_id_safe()) {
			array_push(_ret_val, _callback(get_my_steam_id_safe()))
		}
	} else {
		var _count = get_players_count()
		for (var _i = 0; _i < _count; ++_i) {
			var _player_id = steam_lobby_get_member_id(global.lobby_id, _i);
		
			if (is_undefined(_skip_player_id) || _player_id != _skip_player_id) {
				array_push(_ret_val, _callback(_player_id))
			}
		}
	}
	
	return _ret_val
}

/**
 * @returns {Real}
 */
function get_players_count() {
	if (is_undefined(global.lobby_id)) {
		return 1
	}
	
	var _ret_val = steam_lobby_get_member_count(global.lobby_id)
	if (_ret_val > global.max_players) {
		throw "Too many players"
	}
		
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
	if (is_undefined(global.lobby_id)) {
		return 0
	}
	
	var _count = get_players_count()
	for (var _i = 0; _i < _count; ++_i) {
		var _p = steam_lobby_get_member_id(_i);
		if (_p == _player_id) {
			return _i
		}
	}
}

/**
 * @param {Real} _num
 * @returns {Real}
 */
function get_player_id_from_num(_num) {
	if (is_undefined(global.lobby_id)) {
		return get_my_steam_id_safe()
	}
	
	return steam_lobby_get_member_id(_num);
}