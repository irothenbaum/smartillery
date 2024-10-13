/// @description Particle effect
instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_enemy_4_destroy});
// does not explode nearby enemeis
// explode_nearby_enemies(self, 50)
enemy_handle_destroy(self)