/// @description Initialize settings

// Pick which ultimate this item grants. An ultimate is unavailable if it's:
//  - selected by a player in this game
//  - currently active (a player's own, or one triggered by another extra-ultimate item)
//  - already offered by another extra-ultimate item on the board
// This guarantees no player can ever have 2 instances of the same ultimate running.
// This happens before initialize_instance_has_equation so the fallback below doesn't reserve an answer it never releases
var _all_ultimates = [ULTIMATE_STRIKE, ULTIMATE_SLOW, ULTIMATE_HEAL, ULTIMATE_ASSIST, ULTIMATE_COLLATERAL, ULTIMATE_TURRET, ULTIMATE_RINGS]
var _game_controller = get_game_controller()
var _taken_ultimates = {}

var _player_ids = get_player_ids()
for (var _i = 0; _i < array_length(_player_ids); _i++) {
	var _selected = global.selected_ultimate[$ _player_ids[_i]]
	if (!is_undefined(_selected)) {
		_taken_ultimates[$ _selected] = true
	}
}

with (obj_extra_ultimate) {
	if (id != other.id) {
		_taken_ultimates[$ type] = true
	}
}

var _available = []
for (var _i = 0; _i < array_length(_all_ultimates); _i++) {
	var _ult = _all_ultimates[_i]
	if (!struct_exists(_taken_ultimates, _ult) && !_game_controller.is_ult_active(_ult)) {
		array_push(_available, _ult)
	}
}

// If no ultimates are available, spawn a regular power item instead
if (array_length(_available) == 0) {
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_power_item)
	instance_destroy()
	exit
}

type = _available[irandom(array_length(_available) - 1)]

initialize_instance_has_equation(self)
my_bounds = get_bounds_for_instance(self)

radius = global.player_body_radius * 0.8
icon_scale = 0.016 // this is a magic number, a property of the ultimate sprite sizes and the radius

// Pulse animation variables
pulse_scale = 1
max_pulse_scale = 1.2
// 3 = how many seconds it takes to fully grow
pulse_grow_speed = (max_pulse_scale - pulse_scale) / 3

function register_hit() {
	get_game_controller().release_answer(answer)
	debug(string_concat("EXTRA ULTIMATE \"", type, "\" activated by ", last_hit_by_player_id))
	get_game_controller().activate_extra_ultimate(last_hit_by_player_id, type)
	instance_destroy()
}
