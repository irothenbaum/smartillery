/// @description Particle effect
var _ult_color = global.ultimate_colors[$ type]
instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: method({ult_color: _ult_color}, function(_x, _y) {
	return draw_particle_extra_ultimate_destroy(_x, _y, ult_color)
})})
