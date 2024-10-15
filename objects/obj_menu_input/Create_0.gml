message = "";
x = global.xcenter
y = room_height - 60
min_box_width = 40

function select_button_by_label() {
	var _buttons = instance_number(obj_menu_button)
	var _toggles = instance_number(obj_menu_toggle)
	var _inputs = instance_number(obj_menu_number_input)
	for (var _i = 0; _i < _buttons + _toggles + _inputs; _i++) {
		var _inst = _i < _buttons 
			? instance_find(obj_menu_button, _i) 
			: (
				_i < _buttons + _toggles 
				? instance_find(obj_menu_toggle, _i - _buttons) 
				: instance_find(obj_menu_number_input, _i - _buttons - _toggles)
			)
		if (string_lower(_inst.label) == message) {
			message = ""
			_inst.on_click()
			return true
		}
	}
	
	return false
}

// start off as the default focused input
global.default_focused_input = self
global.focused_input = global.default_focused_input