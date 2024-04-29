x = room_width / 2
y = room_height / 2

function start_game() {
	debug("HERE!")
	room_goto(rm_waves)
}

instance_create_layer(x, y, LAYER_INSTANCES, obj_menu_button, {message: "Play", on_click: start_game})