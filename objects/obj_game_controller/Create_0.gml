// might be fun to make this configurable
game_seed = 132435345;
random_set_seed(game_seed);

current_wave = 5;
health = 1;
score = 0;
unit_score = 0;
bonus_score = 0;
streak_score = 0;
streak = 0;
min_streak = 5;

function mark_wave_completed() {
	if (get_enemy_controller()) {	
		instance_destroy(get_enemy_controller())
	}
	current_wave++;
	var _controller = instance_create_layer(x, y, "Instances", obj_enemy_controller);
	with (_controller) {
		init_wave()
	}
	return _controller
}

function handle_game_over() {
	debug("GAME OVER")
	// destroy the enemy controller
	instance_destroy(get_enemy_controller())
	
	function explode_enemy(_e, _index) {
		with (_e) {
			explode_and_destroy();
		}
	}
	
	// destroy all enemies
	for_each_enemy(explode_enemy)
	
	// TODO: Make this it's own object that can render results and restart button
	// draw the game over text
	var _controller = instance_create_layer(x, y, "Instances", obj_center_text);
	with (_controller) {
		set_text("Game Over", 9999999);
		align = ALIGN_CENTER;
		y = room_height * 0.25;
	}
}

/// @func handle_enemy_killed(_enemy)
/// @param {Id.Instance} _enemy
/// @return {undefined}
function handle_enemy_killed(_enemy) {
	streak++;
	var _time_bonus = calculate_time_bonus((current_time - _enemy.spawn_time) / 1000)
	var _streak_score = streak >= min_streak ? floor(_enemy.point_value * 1.5) : 0;
	
	if (streak == min_streak) {
		health++
	}
	
	unit_score += _enemy.point_value
	streak_score += _streak_score
	bonus_score += _time_bonus
	score += _enemy.point_value + _time_bonus + _streak_score
}

function handle_player_damaged(_enemy) {
	health--
	streak = 0
	
	if (health <= 0) {
		handle_game_over()
	}
}


mark_wave_completed();