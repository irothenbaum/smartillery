/// @description Update orbit position
// Update orbit angle
direction = (direction - orbit_speed) % 360
        
var _player = get_player()
// Calculate position around player
x = _player.x + lengthdir_x(orbit_radius - recoil_amount, direction)
y = _player.y + lengthdir_y(orbit_radius - recoil_amount, direction)

image_angle = direction

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.9
} else {
	recoil_amount = 0
}