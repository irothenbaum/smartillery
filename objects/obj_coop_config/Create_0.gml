/// @description Local co-op join screen

var _host_id = 0
global.active_player_ids = [_host_id]
global.player_device_map[$ _host_id] = -1  // host always uses keyboard

function try_join_with_device(_device_index) {
	if (array_length(global.active_player_ids) >= global.max_players) {
		return false
	}
	// Reject if this device is already assigned to a slot
	var _ids = global.active_player_ids
	for (var _i = 0; _i < array_length(_ids); _i++) {
		if (global.player_device_map[$ _ids[_i]] == _device_index) {
			return false
		}
	}
	var _slot = array_length(global.active_player_ids)
	array_push(global.active_player_ids, _slot)
	global.player_device_map[$ _slot] = _device_index
	return true
}

function handle_start() {
	room_goto(rm_select_ultimates)
}

function handle_cancel() {
	reset_game_state()
	room_goto(rm_main_menu)
}
