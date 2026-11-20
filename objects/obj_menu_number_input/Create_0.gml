bounds = undefined
// optional creation params: min_box_width (match a group's width, see get_menu_box_group_width) and
// align (ALIGN_CENTER, or ALIGN_LEFT so x is the box's left edge)
if (!variable_instance_exists(self, "min_box_width")) {
	min_box_width = 40
}
if (!variable_instance_exists(self, "align")) {
	align = ALIGN_CENTER
}

cached_value = get_value()

on_click = function() {
	global.focused_input = self
}