/// @description Draw difficulty
draw_set_font(fnt_large)
draw_text_with_alignment(global.xcenter, global.room_height * 0.1, "Difficulty: " + string(ceil(get_game_controller().current_wave / difficulty_step)), ALIGN_CENTER)
draw_set_font(fnt_base)
