draw_set_color(c_white);

draw_text_obj(pos_wave, "Wave " + string(get_current_wave_number()));

drawn_score = lerp(drawn_score, game_controller.game_score, global.fade_speed)
draw_text_obj(pos_score, "Score: " + string(ceil(drawn_score)));