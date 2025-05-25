enemy_initlaize(self, global.points_enemy_4)
speed = 1
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale

direction = point_direction(x, y, global.xcenter, global.ycenter)

function register_hit(_insta_kill=false) {
	if (_insta_kill) {
		point_value = 2 * point_value
	} else {
		// we spawn the 3 fragments
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction + 90});
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction - 90});
		instance_create_layer(x, y, LAYER_INSTANCES, obj_enemy_4_fragment, {direction: direction + 180});
	}
	
	instance_destroy()
}

broadcast(EVENT_ENEMY_SPAWNED, self)