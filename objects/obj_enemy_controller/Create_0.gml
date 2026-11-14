can_spawn = false;
enemy_count = 0;
spawned_count = 0;
spawn_delay_seconds = 0;
current_wave = get_current_wave_number();
game_controller = get_game_controller();

min_spawn_delay_seconds = 0.5;
max_spawn_delay_seconds = 6;


/// @func init()
/// @returns {undefined}
function init_wave() {
	can_spawn = false;
	enemy_count = 6 + ceil(current_wave * 1.5);
	spawned_count = 0;
	spawn_delay_seconds = max(min_spawn_delay_seconds, min(max_spawn_delay_seconds, 30 / enemy_count))
	
	instance_create_layer(x, y, LAYER_HUD, obj_next_wave_text)
	
	alarm[0] = global.scene_transition_duration * 2 * game_get_speed(gamespeed_fps);
}

/// @func spawn_enemy()
/// @return {Id.Instance}
function spawn_enemy() {
	// we want each wave to progress the same way regardless of play so we reset the random seed deterministically each time
	random_set_seed(global.game_seed + current_wave * 10000 + spawned_count);
	can_spawn = false
	
	var _spawn_position = get_enemy_spawn_position()
	var _next_enemy = get_enemy_to_spawn(current_wave)
		
	var _new_enemy =  instance_create_layer(
		_spawn_position.x,
		_spawn_position.y, 
		LAYER_INSTANCES, 
		_next_enemy.type, 
		_next_enemy.params
	);
	alarm[0] = game_get_speed(gamespeed_fps) * spawn_delay_seconds
	
	spawned_count++;
	
	return _new_enemy
}