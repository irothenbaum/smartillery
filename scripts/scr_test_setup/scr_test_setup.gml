function configure_test_room() {
	get_game_controller().current_wave = 10
	instance_create_layer(100, 100, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(100, 200, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(100, 300, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(100, 400, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(200, 100, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(200, 200, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(200, 300, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(200, 400, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(300, 100, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(300, 200, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(300, 300, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(300, 400, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(400, 100, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(400, 200, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(400, 300, LAYER_INSTANCES, pick_power_item_object())
	instance_create_layer(400, 400, LAYER_INSTANCES, pick_power_item_object())
	show_debug_message("BOOT 8: test room configured"); var _boot_f = file_text_open_append("boot_log.txt"); file_text_write_string(_boot_f, "BOOT 8: test room configured"); file_text_writeln(_boot_f); file_text_close(_boot_f) // BOOT-DEBUG
	return
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
	// test setup enemies stay put so ultimates can be tested against them
	if (!struct_exists(_params, "frozen")) {
		_params.frozen = true
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