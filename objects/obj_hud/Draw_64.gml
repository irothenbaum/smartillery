// keep the animated score current even while hidden, so it doesn't count up from a stale value when shown
drawn_score = lerp(drawn_score, game_controller.game_score, global.fade_speed)

// wave count and score are only shown on the pause screen
if (!global.paused) {
	exit
}

draw_set_color(c_white);

draw_text_obj(pos_wave, "Wave " + string(get_current_wave_number()));
draw_text_obj(pos_score, "Score: " + string(ceil(drawn_score)));
