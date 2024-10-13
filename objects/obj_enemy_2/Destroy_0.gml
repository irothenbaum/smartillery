/// @description particle effect
instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_2_destroy});
explode_nearby_enemies(self, 100)
enemy_handle_destroy(self)