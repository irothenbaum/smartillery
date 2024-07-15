message = "";
x = room_width / 2
y = room_height - 60
min_box_width = 40

function select_button_by_label() {
	var _buttons = instance_number(obj_menu_button)
	for (var _i = 0; _i < _buttons; _i++) {
		var _inst = instance_find(obj_menu_button, _i)
		if (string_lower(_inst.message) == message) {
			_inst.on_click()
			return true
		}
	}
	
	return false
}