/// @description Create game controller

// Create the game controller based on our is_host value
if (global.is_host) {
	instance_create_layer(x, y, LAYER_CONTROLLERS, obj_game_controller)
} else {
	instance_create_layer(x, y, LAYER_CONTROLLERS, obj_guest_game_controller)
}
