set_viewport_dimensions()

var _count = get_players_count()
var _col_w = floor(room_width / _count)
var _cy    = floor(room_height / 2)

for (var _i = 0; _i < _count; _i++) {
	var _pid    = get_player_id_from_num(_i)
	var _device = global.player_device_map[$ _pid] ?? -1
	var _cx     = floor(_col_w * (_i + 0.5))
	instance_create_layer(_cx, _cy, "Instances", obj_select_ultimate, {
		owner_player_id: _pid,
		device_index:    _device,
	})
}
