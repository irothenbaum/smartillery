/// @description Particle effect
if (!is_undefined(destroy_effect)) {
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: destroy_effect});
}
enemy_handle_destroy(self)
