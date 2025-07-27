/// @description Insert description here
// You can write your code in this editor
var _ev = async_load[? "event_type"];
debug("Received Steam event: " + string(_ev));


switch (_ev) {
    case "steam_lobby_created":
        if (async_load[? "result"] == 1) {
            global.lobby_id = async_load[? "lobby"];
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
		var _is_host = steam_lobby_get_owner(global.lobby_id) == get_my_steam_id_safe()
		debug("Joined lobby as " + _is_host ? "Host" : "Guest")
        break;

    case "steam_lobby_join_requested":
        var _join_id = async_load[? "lobby"];
        steam_lobby_join(_join_id);
        break;

    case "steam_lobby_chat_update": 
		// TODO: someone joined/disconnected
		break;
}