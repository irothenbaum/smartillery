x = global.xcenter
y = global.ycenter
overlay_amount = undefined
showing_results = false

alarm[0] = 1
explosion_count = 10

function draw_buttons() {
	instance_create_layer(x, y * 0.5, LAYER_HUD, obj_text_title, {
		message: "Game Over",
		duration: 9999,
		align: ALIGN_CENTER,
	})
	
	alarm[2] = 2 * game_get_speed(gamespeed_fps)

	instance_create_layer(x - 160, y, LAYER_HUD, obj_menu_button, {
		label: "Menu",
		image_alpha: 0,
		on_click: function() {
			get_game_controller().reset_starting_values()
			room_goto(rm_menu)
		}
	})

	instance_create_layer(x + 100, y, LAYER_HUD, obj_menu_button, {
		label: "Play Again",
		image_alpha: 0,
		on_click: function() {
			get_game_controller().reset_starting_values()
			room_restart()
		}
	})
	
	overlay_amount = 0
}
