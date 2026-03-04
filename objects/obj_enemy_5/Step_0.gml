enemy_step(self)
if (global.paused) {
	return
}

// Handle spawn animation
if (spawn_phase < total_spawn_phases) {
	var _fps = game_get_speed(gamespeed_fps)
	var _phase_duration = spawn_phase_durations[spawn_phase]
	var _phase_progress = spawn_timer / (_phase_duration * _fps)

	if (spawn_phase == 0) {
		// Phase 0: Black hole growing from 1px to max radius
		blackhole_radius = lerp(1, blackhole_max_radius, _phase_progress)
	} else if (spawn_phase == 2) {
		// Phase 1: Enemy fading in and scaling from 0.9x to 1.0x
		image_alpha = _phase_progress
		var _scale_factor = lerp(0.9, 1.0, _phase_progress)
		image_xscale = image_scale * _scale_factor
		image_yscale = image_scale * _scale_factor
	} else if (spawn_phase == 3) {
		// Phase 2: Black hole shrinking back to 1px
		blackhole_radius = lerp(blackhole_max_radius, 1, _phase_progress)
	}

	spawn_timer++

	// Check if current phase is complete
	if (spawn_timer >= _phase_duration * _fps) {
		spawn_phase++
		spawn_timer = 0

		// Finalize values at end of each phase
		if (spawn_phase == 1) {
			blackhole_radius = blackhole_max_radius
		} else if (spawn_phase == 3) {
			image_alpha = 1
			image_xscale = image_scale
			image_yscale = image_scale
		} else if (spawn_phase == 4) {
			// Spawn animation complete - start missile delay
			blackhole_radius = 0
			alarm[0] = missile_delay
		}
	}
}
