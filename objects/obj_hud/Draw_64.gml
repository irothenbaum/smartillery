draw_set_color(c_white);

draw_text_obj(pos_wave, "Wave " + string(game_controller.current_wave));

drawn_score = lerp(drawn_score, game_controller.drawn_game_score, global.fade_speed)
draw_text_obj(pos_score, "Score: " + string(ceil(drawn_score)));