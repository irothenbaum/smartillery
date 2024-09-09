if (global.paused) {
	return
}

vspeed = vspeed * 0.8
// vspeed is negative so we check > -
if (vspeed > -0.02) {
	vspeed = 0
}

if (decrease_opacity) {
	image_alpha = image_alpha * 0.8;
	
	if (image_alpha < 0.02) {
		instance_destroy()
	}
}