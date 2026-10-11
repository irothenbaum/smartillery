/// @description Clean up trail
if (variable_instance_exists(self, "trail_particle_system") && !is_undefined(trail_particle_system)) {
	destroy_particle(trail_particle_system)
}
event_inherited()
