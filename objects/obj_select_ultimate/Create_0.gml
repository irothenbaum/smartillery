toggle_pause(true)

staged_selection = undefined
x = global.x_center
y = global.y_center

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