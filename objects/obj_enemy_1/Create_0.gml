event_inherited()
collision_damage = global.damage_enemy_1_collision
destroy_effect = draw_particle_enemy_1_destroy

// #7f7f7f is the body sprite's own gray, so drawing it through the shader looks the same as drawing it plain
enemy_attack_color_init(self, #7f7f7f)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

// if waypoints wasn't set for us, we initialize
if (is_undefined(waypoints) or array_length(waypoints) == 0) {	
	waypoints = [get_tangent_point(x,y, global.xcenter, global.ycenter, global.room_height * 0.3)]
}

direction = point_direction(x, y, global.xcenter, global.ycenter)
speed = approach_speed

play_sfx(snd_enemy_1_spawn)
