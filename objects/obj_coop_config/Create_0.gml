/// @description Insert description here
// You can write your code in this editor
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
	
}