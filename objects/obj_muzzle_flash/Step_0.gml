image_alpha = image_alpha * 0.9

if (image_alpha < 0.001) {
	instance_destroy()
}