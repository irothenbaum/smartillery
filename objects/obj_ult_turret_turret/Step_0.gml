/// @description Update orbit position
// Update orbit angle
direction = (direction - orbit_speed) % 360
bobble_phase = (bobble_phase + bobble_speed) % 360

// spawn animation: grow from 0 and move out from the center (ease out, so it decelerates into place)
if (spawn_progress < 1 && !global.paused) {
	spawn_progress = min(1, spawn_progress + step_seconds() / spawn_duration)
}
var _spawn_ease = 1 - power(1 - spawn_progress, 3)
image_xscale = image_scale * _spawn_ease
image_yscale = image_scale * _spawn_ease

var _player = get_player()
// Calculate position around player
// wave: crests are fixed points along the orbit (direction * waves) that also drift over time (bobble_phase)
var _wave = dsin(direction * bobble_waves_per_orbit + bobble_phase)
var _radius = (orbit_radius + _wave * bobble_amplitude) * _spawn_ease - recoil_amount
x = _player.x + lengthdir_x(_radius, direction)
y = _player.y + lengthdir_y(_radius, direction)

image_angle = direction

if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.9
} else {
	recoil_amount = 0
}
