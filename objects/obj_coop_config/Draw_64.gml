/// @description Draw the local co-op join screen

draw_set_font(fnt_title)
draw_text_with_alignment(global.xcenter, 80, "Co-Op Setup")
draw_set_font(fnt_base)

var _slot_y_start = 220
var _slot_spacing = 110
var _count = array_length(global.active_player_ids)

for (var _i = 0; _i < global.max_players; _i++) {
	var _slot_y = _slot_y_start + _i * _slot_spacing
	if (_i < _count) {
		var _pid = global.active_player_ids[_i]
		var _device = global.player_device_map[$ _pid]
		var _name = _i == 0 ? "Player 1 (You)" : ("Player " + string(_i + 1))
		var _input = _device == -1 ? "[Keyboard]" : ("[Gamepad " + string(_device + 1) + "]")
		draw_text_with_alignment(global.xcenter, _slot_y, _name + "  " + _input)
	} else {
		draw_set_alpha(0.45)
		draw_text_with_alignment(global.xcenter, _slot_y, "Player " + string(_i + 1) + "  — press any button to join")
		draw_set_alpha(1)
	}
}

var _can_start = _count >= 2
draw_set_font(fnt_base)
draw_text_with_alignment(global.xcenter, global.room_height - 120, _can_start ? "Enter  —  Start" : "Need at least 2 players")
draw_text_with_alignment(global.xcenter, global.room_height - 80, "Escape  —  Cancel")
