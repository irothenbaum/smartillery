/// @description Create game controller

// Create the game controller based on our is_host value
if (is_host(get_my_steam_id_safe())) {
	instance_create_layer(x, y, LAYER_CONTROLLERS, obj_game_controller)
} else {
	instance_create_layer(x, y, LAYER_CONTROLLERS, obj_guest_game_controller)
}

for_each_player(function(_player_id) {
	instance_create_layer(x, y, LAYER_HUD, obj_input, {owner_player_id: _player_id})
})