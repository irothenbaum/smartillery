enemy_initialize(self)

// Shader for octagon fill as missile charges
_u_color = shader_get_uniform(sh_octagon_fill, "u_vColor")
_u_sections = shader_get_uniform(sh_octagon_fill, "u_sections")
_u_rotation = shader_get_uniform(sh_octagon_fill, "u_rotation")
_u_uvs = shader_get_uniform(sh_octagon_fill, "u_uvs")
attack_color = c_fuchsia
attack_color_arr = color_to_array(attack_color)

// Position at random angle, distance from center
var _spawn_distance = global.room_height / 4
var _spawn_angle = irandom(360)
x = global.xcenter + lengthdir_x(_spawn_distance, _spawn_angle)
y = global.ycenter + lengthdir_y(_spawn_distance, _spawn_angle)

my_health = 4
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale

// Delay between missile shots (in seconds)
missile_delay = 6 * game_get_speed(gamespeed_fps)

image_angle = point_direction(x,y,global.xcenter, global.ycenter)

// Wait before first shot
alarm[0] = missile_delay

function register_hit(_insta_kill = false) {
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: draw_particle_enemy_5_damage});

	// Reset missile spawn timer when hit
	alarm[0] = missile_delay * slow_multiplier

	if (my_health > 1 && !_insta_kill) {
		get_game_controller().release_answer(answer);
		my_health--;

		// Generate new equation
		enemy_generate_question(self)
		return
	}

	// my_health <= 1 || insta_kill
	instance_destroy();
}

function fire_shot() {
	instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_5_missile)

	// Wait before next shot
	alarm[0] = missile_delay * slow_multiplier
}

broadcast(EVENT_ENEMY_SPAWNED, self)
