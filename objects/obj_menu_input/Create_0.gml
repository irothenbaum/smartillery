message = "";
// drawn on the GUI layer. On the main menu it follows just below the player (see update_position), so it isn't
// scaled by the zoomed menu camera; anywhere else (e.g. the pause screen) it stays where it was created

function update_position() {
	var _player = instance_find(obj_menu_player, 0)
	if (!instance_exists(_player)) {
		return
	}
	var _player_gui = world_to_gui(_player.x, _player.y)
	// world -> GUI scale, so the gap clears the turret even when it points straight down
	var _scale = display_get_gui_height() / camera_get_view_height(view_camera[0])
	x = _player_gui.x
	y = _player_gui.y + (global.turret_length * _scale) + global.margin_xl
}
min_box_width = 40

placeholder = "type selection"
placeholder_alpha = 0.6
// the placeholder starts empty, then "types" itself out one character at a time
// optional creation param: placeholder_start_delay
if (!variable_instance_exists(self, "placeholder_start_delay")) {
	placeholder_start_delay = 5 // in seconds before the first character
}
placeholder_type_duration = 1 // in seconds to type the whole thing, roughly
placeholder_type_jitter = 0.4 // each character's delay varies by up to +/- this fraction of the average
placeholder_chars = 0 // how many characters are typed so far
placeholder_timer = placeholder_start_delay // in seconds until the next character
had_text = false // once the box empties again after having text, the placeholder starts over

function restart_placeholder() {
	placeholder_chars = 0
	placeholder_timer = placeholder_start_delay
}

/**
 * @returns {Real} in seconds until the next placeholder character: the average gap with a little jitter
 */
function get_next_placeholder_delay() {
	var _average = placeholder_type_duration / string_length(placeholder)
	return _average * (1 + random_range(-placeholder_type_jitter, placeholder_type_jitter))
}

// an invalid entry turns the box red and shakes it, like obj_input does in-game. Timed in its own clock since
// the menu has no game play time
total_shake_time = 500 // in milliseconds
total_shakes = 3
shake_magnitude = 10
shake_elapsed = undefined // in milliseconds since the shake started (undefined = not shaking)
last_guess = "" // shown in red while shaking, since message is cleared on submit

// the "Enter a menu item to select it" hint shown on an invalid entry
hint = noone
hint_fade_duration = 2 // in seconds, starting once the shake is done
// optional creation param: hint_offset_y -- where the hint goes relative to the input (negative = above it)
if (!variable_instance_exists(self, "hint_offset_y")) {
	hint_offset_y = 80
}

function start_shake(_guess) {
	last_guess = _guess
	shake_elapsed = 0
}

function stop_shake() {
	shake_elapsed = undefined
	last_guess = ""
}

/**
 * @returns {Real} the horizontal shake offset right now
 */
function get_shake_offset() {
	if (is_undefined(shake_elapsed)) {
		return 0
	}
	return sin(total_shakes * TAU * shake_elapsed / total_shake_time) * shake_magnitude
}

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
			// the turret shoots the item, and the item triggers when the shot lands (see obj_menu_player)
			var _player = instance_find(obj_menu_player, 0)
			if (instance_exists(_player)) {
				_player.shoot_menu_item(_inst)
			} else {
				activate_menu_item(_inst)
			}
			return true
		}
	}
	
	return false
}

// start off as the default focused input
global.default_focused_input = self
global.focused_input = global.default_focused_input