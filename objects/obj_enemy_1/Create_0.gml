enemy_initlaize(self, global.points_enemy_1)
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10

attack_color = c_fuchsia
attack_color_arr = color_to_array(attack_color)

// if waypoints wasn't set for us, we initialize
if (is_undefined(waypoints) or array_length(waypoints) == 0) {	
	waypoints = [get_tangent_point(x,y, global.xcenter, global.ycenter, global.room_height * 0.3)]
}

debug("Spawned at ", x, y, "heading towards waypoints: ", array_length(waypoints))

direction = point_direction(x, y, global.xcenter, global.ycenter)
speed = approach_speed

function register_hit(_player_who_shot_id) {
	instance_destroy()
}
broadcast(EVENT_ENEMY_SPAWNED, self)