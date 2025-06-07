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

#macro NON_STEAM_PLAYER 999.0001

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
 * @returns {Real}
 */
function get_player_color(_player_id) {
	if (is_host(_player_id)) {
		return global.p1_color
	}
	return global.p2_color
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
	return _player_id == NON_STEAM_PLAYER || _player_id == global.host_id
}