/// @description Draw the enemy object(s)

var _is_dying = alarm[0] > 0
var _is_flickering = alarm[0] > (death_duration / 2)
// we take n seconds to die. The first half of that time is spent flickering, then fading out
var _alpha = _is_flickering 
	? (
		(get_play_time() % 200) < 100 
			? 1 
			: 0
	)
	: (
		_is_dying 
			? (alarm[0] / (death_duration / 2))
			: 1
	)

var _comp_color =new CompositeColor(c_white, _alpha)

draw_set_composite_color(_comp_color)

for (var _i = 0; _i < sequence_length; _i++) {	
	var _entry_position = get_entry_position(_i)
	
	
	// don't draw the last one
	if (_i < sequence_length - 1) {
		draw_arc(
			global.xcenter, 
			global.ycenter, 
			distance_to_player, 
			angle_between_entries * 0.5, 
			_i * angle_between_entries + angle_between_entries * 0.25, 
			3
		)
		
		draw_label_on_curve(_entry_position.rotation + 180)
	}

	
	// if we're dying, we don't draw the target entry sprite (because it exploded)
	if (!_is_dying || _i != target_index) {
		draw_sprite_ext(spr_enemy1_body, 0, _entry_position.x, _entry_position.y, image_scale, image_scale, _entry_position.rotation, _comp_color.c, _comp_color.o)
		var _string = global.paused ? " " : sequence[_i]
		var _draw_position = get_draw_equation_position(_string, _entry_position.x, _entry_position.y)
		draw_text_with_alignment(_draw_position[0].x, _draw_position[0].y, _string, ALIGN_CENTER);
	}
}

reset_composite_color()