// might be fun to make this configurable
game_seed = 132435345;
random_set_seed(game_seed);

current_wave = 0;
health = 1;
score = 0;
unit_score = 0;
bonus_score = 0;
streak_score = 0;
streak = 0;
point_streak = 5;
health_streak = 10;
ultimate_streak = 20;
used_streak = 0;

function get_effective_streak() {
	return streak - used_streak
}

function has_point_streak() {
	return get_effective_streak() >= point_streak
}


/// @returns {Bool}
function has_ultimate() {
	return get_effective_streak() >= ultimate_streak
}

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
	var _controller = instance_create_layer(x, y, "Instances", obj_text_title);
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
	// up to 50% time bonus
	var _time_bonus = floor(_enemy.point_value * calculate_time_bonus((current_time - _enemy.spawn_time) / 1000) * 0.5)
	// streak is + 30% of base
	var _streak_score = has_point_streak() ? floor(_enemy.point_value * 0.3) : 0;
	
	draw_point_indicators(_enemy.x, _enemy.y, _enemy.point_value, _time_bonus, _streak_score)
	
	// using streak not _effective_streak beacuse we don't want to give them extra health
	if (streak == health_streak) {
		// TODO: animate this somehow
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
	used_streak = 0
	
	if (health <= 0) {
		handle_game_over()
	}
}


function draw_point_indicators(_x, _y, _base, _time, _streak) {
	var _base_inst = instance_create_layer(_x, _y, "Instances", obj_text_score_increase)
	_base_inst.set_amount(_base, c_white, fnt_large)
	_y -= 20
	
	if (_time) {
		var _time_inst = instance_create_layer(_x, _y, "Instances", obj_text_score_increase)
		_time_inst.set_amount(_time, c_aqua)
		_y -= 20
	}
	
	if (_streak) {	
		var _streak_inst = instance_create_layer(_x, _y, "Instances", obj_text_score_increase)
		_streak_inst.set_amount(_streak, c_orange)
	}
}

// start off marking wave completed so game can start
mark_wave_completed();