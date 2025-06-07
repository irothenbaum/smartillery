/// @description Insert description here
// You can write your code in this editor
var _ev = async_load[? "event_type"];
debug("Received Steam event: " + string(_ev));


switch (_ev) {
    case "steam_lobby_created":
        if (async_load[? "result"] == 1) {
            global.lobby_id = async_load[? "lobby"];
			global.is_host = true
            steam_lobby_set_joinable(true);
			// may optionally not do this
				steam_activate_overlay("LobbyInvite");
			// --------------------------------
            debug("Lobby created: " + string(global.lobby_id));
        } else {
            debug("Failed to create lobby");
        }
        break;

    case "steam_lobby_entered":
        global.lobby_id = async_load[? "lobby"];
        debug("Joined lobby: " + string(global.lobby_id));
		
		// Get peer's Steam ID (to send a message via Steam Networking)
	    var _count = steam_lobby_get_member_count(global.lobby_id);
	    for (var _i = 0; _i < _count; ++_i) {
	        var _peer_id = steam_lobby_get_member_id(global.lobby_id, _i);
	        if (_peer_id != steam_get_user_steam_id()) {
	            global.partner_steam_id = _peer_id;
				global.my_steam_id = steam_get_user_steam_id()
	        }
	    }

	    global.is_host = steam_lobby_get_owner(global.lobby_id) == global.my_steam_id
		global.host_id = global.is_host ? global.my_steam_id : global.partner_steam_id
		global.guest_id = !global.is_host ? global.my_steam_id : global.partner_steam_id
		global.my_color = global.is_host ? global.p1_color : global.p2_color
		global.partner_color = global.is_host ? global.p2_color : global.p1_color
		
		debug("Joined lobby as " + global.is_host ? "Host" : "Guest")
        break;

    case "steam_lobby_join_requested":
        var _join_id = async_load[? "lobby"];
        steam_lobby_join(_join_id);
        break;

    case "steam_lobby_chat_update": 
		// TODO: someone joined/disconnected
		break;
}