/// @description Particle effect
instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_1_destroy});
explode_nearby_enemies(self, 80)