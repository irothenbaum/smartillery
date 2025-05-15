/// @description Define state change handlers
bounds = {}
states = {
	menu: 0,
	host: 1,
	join: 2,
	lobby: 3
}

gui_state = states.menu;

function handle_host_game() {
	// Called when host clicks "Start Game"
	steam_lobby_create(steam_lobby_type_friendsonly, 2);
	gui_state = states.host	
}

function handle_join_game() {
	steam_activate_overlay("Friends"); // open overlay to accept invite
    gui_state = states.join;
}

function handle_cancel() {
	steam_lobby_leave(global.lobby_id);
	gui_state = states.menu
}

function handle_start() {
	send_event({
		"event_name": NET_EVENT_GAME_START,
		"host_id": global.is_host ? global.my_steam_id : global.partner_steam_id,
		"guest_id": global.is_host ? global.partner_steam_id : global.my_steam_id
	})
	
	room_goto(rm_play_coop)
}