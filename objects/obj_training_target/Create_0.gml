enemy_initialize(self)

max_radius = 24 // 48px diameter at full health
min_radius_percent = 0.5
outline_thickness = 5
target_color = c_white
damaged_color = c_orange
lerp_target_color = target_color
lerp_radius = max_radius
lerp_alpha = 0

max_health = 100
my_health = max_health
damage_per_hit = 24
regen_per_second = 18
is_exploded = false
respawn_time = 3 * game_get_speed(gamespeed_fps)

function get_health_percent() {
	return clamp(my_health / max_health, 0, 1)
}

function get_target_color() {
	var _health_percent = get_health_percent()
	if (_health_percent == 0) {
		return c_grey
	}
	return lerp_color(target_color, damaged_color, 1 - _health_percent)
}

function get_current_radius() {
	// At 100 health = full size, at 0 health = 20% size
	var _health_percent = get_health_percent()
	var _size_percent = min_radius_percent + (1 - min_radius_percent) * _health_percent
	return max_radius * _size_percent
}

function register_hit(_insta_kill = false) {
	if (is_exploded) {
		return
	}

	// Spawn sparks effect
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: function(_x, _y) { return draw_particle_sparks(_x, _y, 8) }})

	my_health = my_health - damage_per_hit

	get_game_controller().release_answer(answer)

	if (my_health <= 0) {
		// Explode - release answer, don't generate new one
		is_exploded = true
		equation = ""
		answer = ""
		my_health = 0;
		draw_particle_shockwave(x,y,1, undefined, damaged_color)
		alarm[0] = respawn_time
	} else {
		enemy_generate_question(self)
	}
}

function respawn() {
	my_health = max_health
	is_exploded = false
	enemy_generate_question(self)
}

broadcast(EVENT_ENEMY_SPAWNED, self)
