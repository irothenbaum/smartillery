/// @description destroy self

instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: method({amount: amount, color: color, dir: direction}, function(_x, _y) {
	return draw_particle_sparks(_x, _y, ceil(amount), color, dir, 90)
})})

get_game_controller().handle_point_orb_collision(self)
get_player().flash_hull(color)
instance_destroy()
