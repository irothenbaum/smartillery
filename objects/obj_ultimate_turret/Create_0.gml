turret_count = ult_turret_get_turret_count(level)
ultimate_initialize(self, ULTIMATE_TURRET)

// Spawn turrets in concentric circles around the player
// the orbitals need to be shifted slightly to ensure no overlap between firing angles
var _player = get_player()
var _max_count_per_orbital = 7 // prime number
var _min_angle_step = 360 / _max_count_per_orbital
// how many orbitals we need to house all turrets
var _total_orbitals = ceil(turret_count / _max_count_per_orbital)
// how much each orbital will need to shift by to ensure even coverage
var _orbital_angle_shift = _min_angle_step / _total_orbitals

// as we iterate through, we track which orbital the next turret is going in
var _current_orbital = 0

for (var _i = 0; _i < turret_count; _i++) {
	var _my_orbital_position = _i - (_current_orbital * _max_count_per_orbital)
	if (_my_orbital_position == _max_count_per_orbital) {
		_current_orbital++;
		_my_orbital_position = 0
	}
	
	var _total_in_my_orbital = (_current_orbital < _total_orbitals - 1) ? _max_count_per_orbital : (((turret_count - 1) % _max_count_per_orbital) + 1)
	var _angle_step = 360 / _total_in_my_orbital 
	
	var _start_angle = _my_orbital_position * _angle_step + (_current_orbital * _orbital_angle_shift)
	var _turret = instance_create_layer(_player.x, _player.y, LAYER_INSTANCES, obj_ult_turret_turret, {
		direction: _start_angle,
		// we had half a ring width so that the turrets align with the ring center
		orbit_radius: global.bg_cicle_min_radius + (global.bg_circle_ring_width * (_current_orbital + 0.5))
	})
}