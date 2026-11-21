/// @description Shared power item setup
// Parent of every power item type (obj_power_item_shield, _turret, _health, _points, _level_up). It's never spawned
// directly -- pick_power_item_object() chooses which child to spawn. Children call event_inherited() first, then set
// their color/label and override register_hit() with their effect.
event_inherited()

radius = global.player_body_radius

// placeholder look until proper sprite assets are made: a colored circle with the type's initials.
// Children set these; a child with a real icon overrides Draw instead (and can still call draw_label())
color = c_white
label = ""
label_color = undefined // undefined = contrast with color

function draw_label() {
	draw_set_font(fnt_small)
	draw_set_color(is_undefined(label_color) ? get_contrast_color(color) : label_color)
	draw_text_with_alignment(x, y, label, ALIGN_CENTER)
	reset_composite_color()
}

/**
 * Leaves the label behind as a quick fade-out (call when the item is hit, before destroying it)
 * @param {Id.Instance} _follow -- optional instance the fading label tracks (e.g. something flying away)
 */
function fade_out_label(_follow = noone) {
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_fading_label, {
		text: label,
		color: is_undefined(label_color) ? get_contrast_color(color) : label_color,
		follow: _follow,
	})
}
