draw_set_color(c_white);
draw_set_font(fnt_title)
draw_set_alpha(image_alpha)
var _message
if (editing) {
	// blinking caret, only while there's room for more (so the box doesn't grow past the group width)
	var _caret_on = (floor(caret_timer / caret_blink_interval) mod 2) == 0
	var _caret = (string_length(draft) < max_chars && _caret_on) ? "_" : ""
	_message = label + ": " + draft + _caret
} else {
	_message = label + ": " + string(get_value())
}
// filled while editing, to show it has the keyboard
bounds = draw_menu_box(x, y, _message, align, min_box_width, editing)
draw_set_alpha(1)
