can_spawn = false;
enemy_count = 0;
spawned_count = 0;
current_wave = get_current_wave_number();

max_value = 0
current_value = 0
value_per_second = 0

min_spawn_delay_seconds = 0.2;
max_spawn_delay_seconds = 5;

/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	enemy_count = 6 + ceil(current_wave * 1.5);
	spawned_count = 0;
	max_value = 20 + current_wave * 10
	current_value = max_value // start off not able to spawn
	// should get to full availability within 10 seconds
	value_per_second = max_value / 10
	spawn_delay_seconds = max(min_spawn_delay_seconds, min(max_spawn_delay_seconds, 30 / enemy_count))
	
	
	instance_create_layer(x, y, LAYER_HUD, obj_next_wave_text)
	
	alarm[0] = global.scene_transition_duration * 2 * game_get_speed(gamespeed_fps);
}

// The minimum level the enemy is allowed to spawn on
_enemy_levels_map = ds_map_create()
ds_map_add(_enemy_levels_map, 0, obj_enemy_1)
ds_map_add(_enemy_levels_map, 5, obj_enemy_2)
ds_map_add(_enemy_levels_map, 10, obj_enemy_3)
ds_map_add(_enemy_levels_map, 15, obj_enemy_4)

// The minimum value needed to spawn an enemy of this type
_enemy_weights_map = ds_map_create()
ds_map_add(_enemy_weights_map, obj_enemy_1, 10)
ds_map_add(_enemy_weights_map, obj_enemy_2, 20)
ds_map_add(_enemy_weights_map, obj_enemy_3, 30)
ds_map_add(_enemy_weights_map, obj_enemy_4, 40)

// The mapping between single enemy and the compound spawner
// If an enemy of `key` type is selected, and there exists enough additional value in the 
// difference between current_value and max_value equal to at least 3x the (key) enemy's min spawn amount
// (refer to _enemy_weights_map), then there's a 50% chance the spawning logic will favor (/switch) to spawn
// the compound enemy.
// For example, if a spawn value of 15 is selected, this would identify the obj_enemy_1. But if there was an available
// spawn value of at least 45 (15 x 3), then there's a 50% chance the enemy that spawns is actually an obj_compound_enemy_1 instead
_enemy_compound_maps = ds_map_create()
ds_map_add(_enemy_compound_maps, obj_enemy_1, obj_compound_enemy_1)
ds_map_add(_enemy_compound_maps, obj_enemy_2, obj_compound_enemy_2)
// TODO:
// ds_map_add(_enemy_compound_maps, obj_enemy_3, obj_compound_enemy_3)
// ds_map_add(_enemy_compound_maps, obj_enemy_4, obj_compound_enemy_4)


function attempt_spawn() {	
	debug("ATTEMPT SPAWN")
	var _min_value = ds_map_find_value(_enemy_weights_map, obj_enemy_1)
	var _value_dif = max_value - current_value
	
	if (_value_dif < _min_value) {
		debug("NOT ENOUGH VALUE, CANNOT SPAWN")
		// if we don't have enough credits even to spawn the smallest enemy
		return
	}
	
	random_set_seed(global.game_seed + current_wave * 10000 + spawned_count);
	var _select = random(max_value)
	if (_select < current_value) {
		// this is the statistical case where we don't spawn
		debug("RANDOM DRAW, NO SPAWN")
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

function get_compound_spawn_details(_single_enemy_type, _value_diff = 0) { 
	var _type = ds_map_find_value(_enemy_compound_maps, _single_enemy_type)
	var _single_value = ds_map_find_value(_enemy_weights_map, _single_enemy_type)
	var _params = {
		enemy_count: floor(_value_diff / _single_value)
	}
	var _cost = _params.enemy_count * _single_value

	switch(_single_enemy_type) {
		case obj_compound_enemy_1:
			
			// this a magic number, just feels like a good scaling factor
			_params.waypoint_count = floor(_params.enemy_count / 3)
			break
		
		case obj_compound_enemy_2:
			break
	}
	
	return [_type, _params, _cost]
}

/// @return {Id.Instance}
function spawn_enemy(_enemy_value) {
	debug("SPAWNING ENEMY VALUE", _enemy_value)
	var _spawn_position = get_random_spawn_point()

	var _new_enemy_type = undefined
	var _new_enemy_params = {}

	// Find the best enemy type that can be spawned based on available value and current wave
	var _selected_enemy_type = undefined
	var _selected_enemy_weight = 0

	// Iterate through the levels map to find available enemies
	var _key = ds_map_find_first(_enemy_levels_map)
	while (!is_undefined(_key)) {
		var _enemy_type = ds_map_find_value(_enemy_levels_map, _key)
		var _min_level = _key
		var _enemy_weight = ds_map_find_value(_enemy_weights_map, _enemy_type)

		// Check if this enemy is unlocked at current wave and affordable
		if (_min_level <= current_wave && _enemy_weight <= _enemy_value) {
			// Select the enemy with the highest weight that fits
			if (_enemy_weight > _selected_enemy_weight) {
				_selected_enemy_type = _enemy_type
				_selected_enemy_weight = _enemy_weight
			}
		}

		_key = ds_map_find_next(_enemy_levels_map, _key)
	}

	// If no enemy could be selected, default to the cheapest one
	if (is_undefined(_selected_enemy_type)) {
		_selected_enemy_type = obj_enemy_1
		_selected_enemy_weight = ds_map_find_value(_enemy_weights_map, obj_enemy_1)
	}

	_new_enemy_type = _selected_enemy_type

	// Check if we should spawn a compound enemy instead
	var _value_dif = max_value - current_value
	var _compound_threshold = _selected_enemy_weight * 3

	if (_value_dif >= _compound_threshold) {
		// Check if a compound mapping exists for this enemy type
		if (ds_map_exists(_enemy_compound_maps, _selected_enemy_type)) {
			// 50% chance to spawn compound
			if (flip_coin()) {
				var _compound_spawn_details = get_compound_spawn_details(_selected_enemy_type, _value_dif)
				debug("Spawning compound", _compound_spawn_details)
				_new_enemy_type = _compound_spawn_details[0]
				_new_enemy_params = _compound_spawn_details[1]
				_selected_enemy_weight = _compound_spawn_details[2]
			}
		}
	}

	// Update current_value
	current_value += _selected_enemy_weight

	var _new_enemy =  instance_create_layer(
		_spawn_position.x,
		_spawn_position.y,
		LAYER_INSTANCES,
		_new_enemy_type,
		_new_enemy_params
	);

	spawned_count++;

	return _new_enemy
}