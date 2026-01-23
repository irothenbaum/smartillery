enemy_initialize(self)

// Initialize trail variables early in case of early destruction
trail_particle_system = undefined
trail_particle_type = undefined

image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale

// Point directly away from the center
direction = point_direction(global.xcenter, global.ycenter, x, y)
image_angle = direction

// Track spawn position - missile travels straight until it's far enough away
spawn_x = x
spawn_y = y
straight_travel_distance = 4 * global.player_body_radius

// Turn speed as interpolation factor (0-1 range, lower = more gradual)
turn_speed = 0.03

// Starting speed and acceleration
speed = 0.5
acceleration = 0.02
max_speed = 4

// Create trail particle system
var _trail = draw_missile_trail()
trail_particle_system = _trail.system
trail_particle_type = _trail.type

// Start emitting trail particles (about 7-10 per second)
trail_emit_interval = game_get_speed(gamespeed_fps) / 8
alarm[0] = trail_emit_interval

function register_hit(_insta_kill = false) {
	instance_destroy()
}

broadcast(EVENT_ENEMY_SPAWNED, self)
