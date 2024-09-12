toggle_pause(true)

staged_selection = undefined
x = global.x_center
y = global.y_center

icons = {
	ULTIMATE_STRIKE: spr_icon_ult_strike_medium,
	ULTIMATE_SLOW: spr_icon_ult_slow_medium,
	ULTIMATE_HEAL: spr_icon_ult_heal_medium,
}

hovered_scale = 1
default_scale = 0.8

icon_space = 260

drawn_icon_scales = {
	ULTIMATE_STRIKE: default_scale,
	ULTIMATE_SLOW: default_scale,
	ULTIMATE_HEAL: default_scale,
}

drawn_icon_opacity = {
	ULTIMATE_STRIKE: 0,
	ULTIMATE_SLOW: 0,
	ULTIMATE_HEAL: 0,
}

ultimate_descriptions = {
	ULTIMATE_STRIKE: {title: "Air strike", description: "Launch a barrage from the air that targets and eliminates your most dangerous enemies"},
	ULTIMATE_SLOW: {title: "Time slow", description: "Reduce the approach and attack speed of enemies nearing your position"},
	ULTIMATE_HEAL: {title: "Regenerate", description: "Repair damage to your ship so you can stay in the fight longer"}
}

function handle_select(_ult) {
	global.selected_ultimate = _ult
	instance_destroy()
}