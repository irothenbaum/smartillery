enemy_step(self)
tip_step(self)

if (global.paused) {
	return
}

// Regenerate health over time (only when not exploded)
if (!is_exploded && my_health < max_health) {
	my_health = min(max_health, my_health + (regen_per_second * delta_time_seconds()))
}
