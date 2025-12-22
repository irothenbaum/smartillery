if (is_undefined(owner_player_id) || owner_player_id == NON_STEAM_PLAYER) {
	owner_player_id = get_my_steam_id_safe()
}
drawn_ultimate = 0
drawn_ultimate_experience = 0
selected_ultimate = global.selected_ultimate[$ owner_player_id]
ult_sprite = global.ultimate_icons[$ selected_ultimate]
icon_scale = 0.03
sprite_size = sprite_get_width(ult_sprite) * icon_scale
half_sprite_size = sprite_size / 2
input = get_input(owner_player_id)
game_controller = get_game_controller()
color_shadow = new CompositeColor(c_black, 0.4)
color_shadow_dark = new CompositeColor(c_black, 0.8)
my_bounds = undefined

subscribe(self, EVENT_UTLTIMATE_LEVEL_UP, method({
	input: input, 
	half_sprite_size: half_sprite_size
}, function() {
	var _xcenter = input.my_bounds.x1 + global.margin_md * 2 + half_sprite_size
	var _ycenter = input.my_bounds.ycenter
	draw_particle_shockwave(_xcenter, _ycenter, 0.5)
}))