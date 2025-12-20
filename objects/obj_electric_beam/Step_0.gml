if (!persist) {
	image_alpha = image_alpha * 0.9
}

if (image_alpha < 0.001) {
	instance_destroy()
}

if (instance_exists(target)) {
	target_x = target.x
	target_y = target.y
}

if (instance_exists(source)) {
	x = source.x
	y = source.y
}

direction = point_direction(x,y, target_x, target_y)
length = point_distance(x,y, target_x, target_y)