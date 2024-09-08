toggle_pause(true)

staged_selection = undefined
x = room_width / 2
y = room_height / 2

icons = {
	ULTIMATE_STRIKE: spr_particle_divide,
	ULTIMATE_SLOW: spr_particle_exponent,
	ULTIMATE_HEAL: spr_particle_add,
}

icon_space = 60

function handle_select(_ult) {
	global.selected_ultimate = _ult
	instance_destroy()
}