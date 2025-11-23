/// @description Draw basic
// You can write your code in this editor
ultimate_draw(self)

for_each_enemy(function(_e, _index, _range) {
	with(_e) {
		draw_set_composite_color(new CompositeColor(c_green, 0.8))
		draw_circle(x, y, _range, true)
		reset_composite_color()
	}
}, range)