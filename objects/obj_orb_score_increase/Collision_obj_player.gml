/// @description destroy self
instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: method({amount: amount, color: color, dir: direction}, function(_x, _y) {
	return draw_particle_sparks(_x, _y, ceil(amount * 1.5), color, dir, 90)
})})
get_game_controller().drawn_game_score += amount
instance_destroy()
