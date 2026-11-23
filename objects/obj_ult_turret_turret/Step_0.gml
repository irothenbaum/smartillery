/// @description Update orbit position
// Update orbit angle
direction = (direction - orbit_speed) % 360
bobble_phase = (bobble_phase + bobble_speed) % 360

var _player = get_player()
// Calculate position around player
var _radius = orbit_radius + dsin(bobble_phase) * bobble_amplitude - recoil_amount
x = _player.x + lengthdir_x(_radius, direction)
y = _player.y + lengthdir_y(_radius, direction)

image_angle = direction

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.9
} else {
	recoil_amount = 0
}
