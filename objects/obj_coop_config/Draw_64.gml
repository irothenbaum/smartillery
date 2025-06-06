/// @description Draw the lobby menu

if (!steam_initialised()) {
	draw_set_font(fnt_title)
	draw_text_with_alignment(global.xcenter, global.ycenter, "Steam required to play Duos")
	draw_set_font(fnt_base)
	return
}

function draw_menu() {
	// Trying to get this dynamic menu drawer working. The idea was to pass a generaotor function esing fibers
	// And that way you could determine the max bounds, and then using another function I wrote ("center_in_frame")
	// to ensure the next render drew the menu and its contents in frame. "_offset" was how you would import the 
	// determined shift amount. _offset.x + {original x}, etc
	bounds = get_bounds_of_draw_functions(fiber_create(function(_offset) {
		fiber_yield(draw_text_with_alignment(_offset.x + global.xcenter, 100, "Join or Host?"))
		fiber_yield(draw_text_with_alignment(_offset.x + global.xcenter, 200, "Join or Host?"))
	}), {x: 0, y: 0})
}

switch (gui_state) {
	case states.menu:
		draw_menu();
		break;
		
	case states.host:
		draw_host_game()
		break
		
	case states.join:
		draw_join_game()
		break
		
	case states.lobby:
		draw_lobby();
}
