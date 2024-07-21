message = "";
x = room_width / 2
y = room_height - 60
min_box_width = 40

function select_button_by_label() {
	var _buttons = instance_number(obj_menu_button)
	var _toggles = instance_number(obj_menu_toggle)
	for (var _i = 0; _i < _buttons + _toggles; _i++) {
		var _inst = _i < _buttons 
			? instance_find(obj_menu_button, _i) 
			: instance_find(obj_menu_toggle, _i - _buttons)
		if (string_lower(_inst.message) == message) {
			_inst.on_click()
			return true
		}
	}
	
	return false
}