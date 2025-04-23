/// @description Insert description here
// You can write your code in this editor
var _ev = async_load[? "event_type"];
show_debug_message("Received Steam event: " + string(_ev));


switch (_ev) {
    case "steam_lobby_created":
        if (async_load[? "result"] == 1) {
            global.lobby_id = async_load[? "lobby"];
            steam_lobby_set_joinable(true);
			// may optionally not do this
				steam_activate_overlay("LobbyInvite");
			// --------------------------------
            show_debug_message("Lobby created: " + string(global.lobby_id));
        } else {
            show_debug_message("Failed to create lobby");
        }
        break;

    case "steam_lobby_entered":
        global.lobby_id = async_load[? "lobby"];
        show_debug_message("Joined lobby: " + string(global.lobby_id));
        break;

    case "steam_lobby_join_requested":
        var _join_id = async_load[? "lobby"];
        steam_lobby_join(_join_id);
        break;

    case "steam_lobby_chat_update": 
		// TODO: someone joined/disconnected
		break;
}