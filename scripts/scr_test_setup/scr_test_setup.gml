function configure_test_room() {
	var _ult = get_player_ultimate(0)
	switch(_ult) {
		case ULTIMATE_STRIKE:
			test_setup_ultimate_strike()
			break
		case ULTIMATE_HEAL:
			test_setup_ultimate_heal()
			break
	}
}

function spawn_enemy_at_angle_and_distance_from_center(_angle, _distance, _enemy_type, _params = undefined) {
	var _x = global.xcenter + lengthdir_x(_distance, _angle)
	var _y = global.ycenter + lengthdir_y(_distance, _angle)
	
	if (is_undefined(_params)) {
		_params = {}
	}
	
	instance_create_layer(_x, _y, LAYER_INSTANCES, _enemy_type, _params)
}

// --------------

function test_setup_ultimate_strike() {
	spawn_enemy_at_angle_and_distance_from_center(90, global.bg_circle_ring_width * 6, obj_enemy_1)
	spawn_enemy_at_angle_and_distance_from_center(240, global.bg_circle_ring_width * 5, obj_enemy_1)
	spawn_enemy_at_angle_and_distance_from_center(0, global.bg_circle_ring_width * 3, obj_enemy_1)
}

function test_setup_ultimate_heal() {
	spawn_enemy_at_angle_and_distance_from_center(90, global.bg_circle_ring_width * 6, obj_enemy_1)
	get_player().my_health = 10
}