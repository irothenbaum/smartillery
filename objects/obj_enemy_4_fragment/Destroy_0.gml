/// @description Particle effect
instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_4_fragment_destroy});
explode_nearby_enemies(self, 40)
enemy_handle_destroy(self)