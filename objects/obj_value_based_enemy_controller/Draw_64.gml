/// @description DEBUG DRAWING
// You can write your code in this editor
if (true) {
	debug("HERE")
	var _f = new CompositeColor(c_white, 1)
	var _b = new CompositeColor(c_white, 0.2)
	draw_progress_bar(global.room_width - 40, 200, global.room_width - 20, global.room_height - 200, current_value / max_value, _f, _b)
}