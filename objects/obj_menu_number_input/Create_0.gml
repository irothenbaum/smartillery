bounds = undefined
// optional creation params: min_box_width (match a group's width, see get_menu_box_group_width) and
// align (ALIGN_CENTER, or ALIGN_LEFT so x is the box's left edge)
if (!variable_instance_exists(self, "min_box_width")) {
	min_box_width = 40
}
if (!variable_instance_exists(self, "align")) {
	align = ALIGN_CENTER
}

// editing: once chosen (typed into the menu input and shot, or clicked) it takes the keyboard. Enter, Escape, or
// clicking elsewhere commits what was typed via on_change (an empty entry is passed as "", see the caller)
editing = false
draft = ""
max_chars = 10 // matches the menu's group width, sized for "Seed: 0000000000"
caret_blink_interval = 0.5 // in seconds per blink
caret_timer = 0

function begin_edit() {
	editing = true
	draft = ""
	caret_timer = 0
	keyboard_string = ""
	global.focused_input = self
}

function commit_edit() {
	editing = false
	on_change(draft)
	draft = ""
	keyboard_string = ""
	if (global.focused_input == self) {
		global.focused_input = global.default_focused_input
	}
	// so the Enter that committed isn't also seen as a submit by the menu input this frame
	io_clear()
}

on_click = function() {
	begin_edit()
}
