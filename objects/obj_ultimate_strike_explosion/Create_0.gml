instance_create_layer(x, y, LAYER_INSTANCES, obj_particle_effect, {effect: function(_x, _y) {
	draw_particle_ultimate_strike(_x, _y, radius)
}})
	
// blow up any that are close enough
for_each_enemy(function(_e, _index) {
	with(_e) {
		if (point_distance(x,y, other.x, other.y) < other.radius) {
			register_hit(true)
		}
	}
})