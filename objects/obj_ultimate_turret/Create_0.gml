turret_count = ult_turret_get_turret_count(level)
ultimate_initialize(self, ULTIMATE_TURRET)

// tracks the turret instances this ultimate spawned, so Destroy only removes our own
my_turrets = []

// Spawn every turret on the innermost ring around the player, evenly spaced
var _player = get_player()
var _angle_step = 360 / max(1, turret_count)

// stagger each player's turrets so that concurrent ultimates (e.g. both players active
// at once) don't spawn their turrets on top of each other
var _player_angle_offset = get_player_number(owner_player_id) * (_angle_step / max(1, get_players_count()))

// half a ring width out so the turrets sit on the ring's center
var _orbit_radius = global.bg_cicle_min_radius + (global.bg_circle_ring_width * 0.5)

for (var _i = 0; _i < turret_count; _i++) {
	var _turret = instance_create_layer(_player.x, _player.y, LAYER_INSTANCES, obj_ult_turret_turret, {
		direction: _i * _angle_step + _player_angle_offset,
		// neighbors orbit in opposite directions, each at a slightly different speed (0.9x - 1.1x) and with their wave
		// out of sync. Derived from _i rather than random() so visuals don't consume the seeded RNG
		orbit_direction: (_i % 2 == 0) ? 1 : -1,
		orbit_speed_multiplier: 1 + (((_i * 3) % 5) - 2) * 0.05,
		bobble_phase: (_i * 137.5) % 360,
		orbit_radius: _orbit_radius,
	})
	array_push(my_turrets, _turret)
}
