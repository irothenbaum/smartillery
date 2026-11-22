// optional creation params: min_box_width (match a group's width, see get_menu_box_group_width) and
// align (ALIGN_CENTER, or ALIGN_LEFT so x is the box's left edge)
if (!variable_instance_exists(self, "min_box_width")) {
	min_box_width = 40
}
if (!variable_instance_exists(self, "align")) {
	align = ALIGN_CENTER
}
bounds = undefined

// once this button starts a room transition, it strobes inverted (white box, black text) until the room changes
strobing = false
strobe_interval = 0.06 // in seconds per flip
strobe_timer = 0
strobe_inverted = false

/// Runs on_click, then starts strobing if that kicked off a room transition
function activate() {
	on_click(self)
	if (is_room_transitioning()) {
		strobing = true
		strobe_inverted = true
		strobe_timer = strobe_interval
	}
}
