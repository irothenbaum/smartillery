// Emit trail particle at current position
if (!is_undefined(trail_particle_system) && !is_undefined(trail_particle_type)) {
	part_particles_create(trail_particle_system, x, y, trail_particle_type, 1)
}

// Re-trigger alarm (slower when time is slowed)
alarm[0] = trail_emit_interval / slow_multiplier
