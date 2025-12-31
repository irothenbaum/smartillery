can_spawn = false;
enemy_count = 0;
spawned_count = 0;
current_wave = get_current_wave_number();
game_controller = get_game_controller();

max_value = 0
current_value = 0


/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	enemy_count = 6 + ceil(current_wave * 1.5);
	spawned_count = 0;
	max_value = current_wave * 10
	current_value = floor(max_value / 2)
	
	instance_create_layer(x, y, LAYER_HUD, obj_next_wave_text)
	
	alarm[0] = global.scene_transition_duration * 2 * game_get_speed(gamespeed_fps);
}

_enemy_levels_map = ds_map_create()
ds_map_add(_enemy_levels_map, 0, obj_enemy_1)
ds_map_add(_enemy_levels_map, 5, obj_enemy_2)
ds_map_add(_enemy_levels_map, 10, obj_enemy_3)
ds_map_add(_enemy_levels_map, 15, obj_enemy_4)

_enemy_weights_map = ds_map_create()
ds_map_add(_enemy_weights_map, obj_enemy_1, 10)
ds_map_add(_enemy_weights_map, obj_enemy_2, 20)
ds_map_add(_enemy_weights_map, obj_enemy_3, 30)
ds_map_add(_enemy_weights_map, obj_enemy_4, 40)

_enemy_compound_maps = ds_map_create()
ds_map_add(_enemy_compound_maps, obj_enemy_1, obj_compound_enemy_1)
ds_map_add(_enemy_compound_maps, obj_enemy_2, obj_compound_enemy_2)
// TODO:
// ds_map_add(_enemy_compound_maps, obj_enemy_3, obj_compound_enemy_3)
// ds_map_add(_enemy_compound_maps, obj_enemy_4, obj_compound_enemy_4)


function attempt_spawn() {
	var _min_value = ds_map_get(_enemy_weights_map, obj_enemy_1)
	var _value_dif = max_value - current_value
	
	if (_value_dif < _min_value) {
		// if we don't have enough credits even to spawn the smallest enemy
		return
	}
	
	random_set_seed(global.game_seed + current_wave * 10000 + spawned_count);
	var _select = random(max_value)
	if (_select < current_value) {
		// this is the statistical case where we don't spawn
		return
	}
	
	var _enemy_value = _select - current_value
	
	spawn_enemy(_enemy_value)
}

function get_random_spawn_point() {
	// out of bounds margin
	var _oob_margin = 30
	
	var _rotation = irandom(360)
	var _pos_x = global.xcenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	var _pos_y = global.ycenter + lengthdir_x(global.bg_circle_max_radius, _rotation)
	
	// the no spawn zone is the middle 33%, so if pos_x is in that range, we shift it
	var _no_spawn_marker = global.room_width * 0.33
	if (_pos_x > _no_spawn_marker && _pos_x < _no_spawn_marker * 2) {
		var _distance_to_center = _pos_x - global.xcenter
		// if _distance_to_center is negative, then pos_x is to the right of center, in the middle 33%.
		// this basically shifts our x position back into either the first or 3rd swction respctive to its position in the second
		_pos_x = _distance_to_center < 0 ? 2 * (_no_spawn_marker + abs(_distance_to_center)) : _no_spawn_marker - (_distance_to_center * 2)
	}
	
	// quad 1 is TOP, 2 is RIGHT, 3 is BOTTOM, 0 is LEFT
	var _quad = irandom(3)
	
	_pos_y = _quad == 1 ? -_oob_margin : (_quad == 3 ? global.room_height + _oob_margin : _pos_y);
	_pos_x = _quad == 0 ? -_oob_margin : (_quad == 2 ? global.room_width + _oob_margin : _pos_x);
	
	return {
		x: _pos_x,
		y: _pos_y
	}
}

/// @return {Id.Instance}
function spawn_enemy(_enemy_value) {
	var _spawn_position = get_random_spawn_point()
	
	var _new_enemy_type = undefined
	var _new_enemy_params = undefined

	
	
	// JUST FOR TESTING:
	// _new_enemy_type = obj_enemy_5
	// -----
	_new_enemy_params = _get_enemy_variables(_new_enemy_type)
		
	var _new_enemy =  instance_create_layer(
		_spawn_position.x,
		_spawn_position.y, 
		LAYER_INSTANCES, 
		_new_enemy_type, 
		_new_enemy_params
	);
	alarm[0] = game_get_speed(gamespeed_fps) * spawn_delay_seconds
	
	spawned_count++;
	
	return _new_enemy
}