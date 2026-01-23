/// @description particle effect
instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: draw_particle_enemy_5_missile_destroy});
if (variable_instance_exists(self, "trail_particle_system") && !is_undefined(trail_particle_system)) {
	destroy_particle(trail_particle_system)
}
enemy_handle_destroy(self)
