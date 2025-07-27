/// @description Insert description here
// You can write your code in this editor
var _keys = variable_struct_get_names(global.selected_ultimate);

if (array_length(_keys) == get_players_count()) {
	get_game_controller().mark_wave_completed()
	instance_destroy()
}

for (var _i = array_length(_keys) - 1; _i >= 0; --_i) {
    var _k = _keys[i];
    var _v = global.selected_ultimate[$ k];
}