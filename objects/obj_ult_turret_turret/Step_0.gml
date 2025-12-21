/// @description Update orbit position
// Update orbit angle
direction = (direction - orbit_speed) % 360
        
var _player = get_player()
// Calculate position around player
x = _player.x + lengthdir_x(orbit_radius, direction)
y = _player.y + lengthdir_y(orbit_radius, direction)

image_angle = direction