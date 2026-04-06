/// @description Initialize settings
initialize_instance_has_equation(self)
my_bounds = get_bounds_for_instance(self)

radius = global.player_body_radius * 0.8
icon_scale = 0.016 // this is a magic number, a property of the ultimate sprite sizes and the radius

// Pulse animation variables
pulse_scale = 1
max_pulse_scale = 1.2
// 3 = how many seconds it takes to fully grow
pulse_grow_speed = (max_pulse_scale - pulse_scale) / 3

// All selectable ultimates (excluding ULTIMATE_NONE)
var _all_ultimates = [ULTIMATE_STRIKE, ULTIMATE_SLOW, ULTIMATE_HEAL, ULTIMATE_ASSIST, ULTIMATE_COLLATERAL, ULTIMATE_TURRET, ULTIMATE_RINGS]

// Get ultimates already selected by players
var _selected_by_players = struct_get_names(global.selected_ultimate)
var _taken_ultimates = {}
for (var _i = 0; _i < array_length(_selected_by_players); _i++) {
	_taken_ultimates[$ global.selected_ultimate[$ _selected_by_players[_i]]] = true
}

// Get ultimates already used by existing obj_extra_ultimate instances
var _existing_extras = []
with (obj_extra_ultimate) {
	if (id != other.id && variable_instance_exists(id, "type")) {
		array_push(_existing_extras, type)
	}
}
for (var _i = 0; _i < array_length(_existing_extras); _i++) {
	_taken_ultimates[$ _existing_extras[_i]] = true
}

// Find available ultimates
var _available = []
for (var _i = 0; _i < array_length(_all_ultimates); _i++) {
	if (!struct_exists(_taken_ultimates, _all_ultimates[_i])) {
		array_push(_available, _all_ultimates[_i])
	}
}

// If no ultimates available, spawn a power item instead and destroy self
if (array_length(_available) == 0) {
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_power_item)
	instance_destroy()
} else {
	type = _available[irandom(array_length(_available) - 1)]
}

function register_hit() {
	get_game_controller().release_answer(answer)
	get_game_controller().activate_extra_ultimate(last_hit_by_player_id, type)
	instance_destroy()
}

subscribe(self, EVENT_GAME_OVER, function() {
	instance_destroy()
})