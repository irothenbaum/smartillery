/// @description Initialize settings

radius = global.player_body_radius
icon_scale = 0.02 // this is a magic number, a property of the ultimate sprite sizes and the radius

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