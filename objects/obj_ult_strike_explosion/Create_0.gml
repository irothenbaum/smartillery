instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: method({radius: radius}, function(_x, _y) {
	return draw_particle_ultimate_strike(_x, _y, radius)
})})