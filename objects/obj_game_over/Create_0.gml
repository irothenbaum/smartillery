x = room_width / 2
y = room_height / 2
overlay_amount = undefined

alarm[0] = 1
explosion_count = 10

function draw_buttons() {
	instance_create_layer(x, y * 0.5, LAYER_HUD, obj_text_title, {
		message: "Game Over",
		duration: 9999,
		align: ALIGN_CENTER,
	})

	instance_create_layer(x - 100, y, LAYER_HUD, obj_menu_button, {
		message: "Menu",
		on_click: function() {
			room_goto(rm_menu)
		}
	})

	instance_create_layer(x + 100, y, LAYER_HUD, obj_menu_button, {
		message: "Play Again",
		on_click: function() {
			room_restart()
		}
	})
	
	overlay_amount = 0
}