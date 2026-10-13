/// @description Initialize shield
// A ring around the player that destroys (without reward) any enemy or enemy shot that reaches it.
// Each hit costs 1 health. There's only ever one shield -- more shield items stack onto it via add_health()
x = global.xcenter
y = global.ycenter
shield_health = 1

// the shield fills one background ring exactly (rings are indexed from the outside in)
var _ring_index = global.bg_number_of_circles - global.shield_ring_from_center
outer_radius = get_radius_for_ring(_ring_index)
inner_radius = get_radius_for_ring(_ring_index + 1)
radius = (outer_radius + inner_radius) / 2
thickness = outer_radius - inner_radius
color = global.shield_color

/**
 * @param {Real} _amount
 */
function add_health(_amount) {
	shield_health += _amount
	flash()
}

function absorb_hit() {
	shield_health--
	flash()
	if (shield_health <= 0) {
		instance_destroy()
	}
}

function flash() {
	instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_expanding_ring, {
		start_radius: radius,
		end_radius: radius + thickness,
		color: color,
		duration: 0.3,
		stroke: thickness,
		fade: true,
	})
}

/**
 * Where a shot fired from (_from_x, _from_y) toward the player meets the outside of the shield
 * @param {Real} _from_x
 * @param {Real} _from_y
 * @returns {Struct}
 */
function get_impact_point(_from_x, _from_y) {
	var _dir = point_direction(x, y, _from_x, _from_y)
	return {
		x: x + lengthdir_x(outer_radius, _dir),
		y: y + lengthdir_y(outer_radius, _dir),
	}
}
