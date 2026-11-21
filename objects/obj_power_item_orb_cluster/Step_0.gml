/// @description Hover the orb cluster
event_inherited() // tip + orbit
if (global.paused) {
	return
}

sync_cluster()
for (var _i = 0; _i < array_length(cluster); _i++) {
	var _orb = cluster[_i]
	_orb.phase_x = (_orb.phase_x + _orb.speed_x * step_seconds()) mod 360
	_orb.phase_y = (_orb.phase_y + _orb.speed_y * step_seconds()) mod 360
}
update_cluster_positions()
