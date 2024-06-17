_u_color = shader_get_uniform(sh_hue_shift, "u_vColor");
image_scale = 0.5
x = room_width / 2

body_picker = instance_create_layer(x, y + 90, LAYER_INSTANCES, obj_color_picker)
turret_picker = instance_create_layer(x, y - 120, LAYER_INSTANCES, obj_color_picker)

body_picker.on_select = function(_color) {
	global.body_color = _color
}

turret_picker.on_select = function(_color) {
	global.turret_color = _color
}