global.my_steam_id = NON_STEAM_PLAYER

#macro NON_STEAM_PLAYER 999.0001
#macro NON_STEAM_PLAYER_PARTNER 999.0002


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

function get_partner_steam_id_safe() {
	if (is_undefined(global.partner_steam_id)) {
		return NON_STEAM_PLAYER_PARTNER
	}
	return global.partner_steam_id
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
	return _player_id == NON_STEAM_PLAYER || _player_id == steam_lobby_get_owner_id(global.lobby_id)
}

/**
 * @param {Real} _player_id
 * @returns {Bool}
 */
function is_guest(_player_id) {
	return !is_host(_player_id)
}

/**
 * @param {method} _callback
 * @returns {Array<Any>}
 */
function for_each_player(_callback, _skip_player_id) {
	var _ret_val = []
	
	if (is_undefined(global.lobby_id)) {
		if (is_undefined(_skip_player_id) || _skip_player_id == get_my_steam_id_safe()) {
			array_push(_ret_val, _callback(get_my_steam_id_safe()))
		}
	} else {
		var _count = get_players_count()
		for (var _i = 0; _i < _count; ++_i) {
			var _player_id = steam_lobby_get_member_id(global.lobby_id, _i);
		
			if (!is_undefined(_skip_player_id) && _player_id == _skip_player_id) {
				continue
			}
		
			array_push(_ret_val, _callback(_player_id))
		}
	}
	
	return _ret_val
}

/**
 * @returns {number}
 */
function get_players_count() {
	if (is_undefined(global.lobby_id)) {
		return 1
	}
	
	return steam_lobby_get_member_count(global.lobby_id)
}

/**
 * @returns {Array<number>}
 */
function get_player_ids() {
	return for_each_player(function(_p){return _p})
}