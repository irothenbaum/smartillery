drawn_ultimate = 0
drawn_ultimate_experience = 0
selected_ultimate = get_player_ultimate(owner_player_id)
ult_sprite = global.ultimate_icons[$ selected_ultimate]
icon_scale = 0.03
sprite_size = sprite_get_width(ult_sprite) * icon_scale
half_sprite_size = sprite_size / 2
input = get_input(owner_player_id)
game_controller = get_game_controller()
color_shadow = new CompositeColor(c_black, 0.4)
color_shadow_dark = new CompositeColor(c_black, 0.8)
my_bounds = undefined

// while the ultimate is active the icon's circle throbs in the ultimate's color (see Draw GUI)
#macro ULT_ICON_PULSE_PERIOD_MS 700 // one throb
#macro ULT_ICON_PULSE_GROWTH 0.15 // how much bigger the circle gets at the peak of a throb