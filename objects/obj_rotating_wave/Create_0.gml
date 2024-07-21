spawn_time = get_play_time()

circumference = waves * wave_length
circle_radius = circumference / (2 * pi)
wave_step_length = ceil(wave_length / resolution)
total_steps = resolution * waves
step_rotation = 360 / total_steps

// ms
draw_duration_ms = 1000

function burst() {
	// TODO: Create a burst animation
}