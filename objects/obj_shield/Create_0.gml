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
drawn_thickness = thickness
color = global.shield_color

// when health runs out the shield doesn't vanish immediately: it collapses down to a thin line, then disappears.
// A collapsing shield no longer blocks anything
collapsing = false
collapse_elapsed = 0 // seconds
collapse_duration = 0.15 // seconds to shrink to a thin line
collapse_hold_duration = 0.1 // seconds the thin line stays before disappearing
collapse_min_thickness = 2

/**
 * @param {Real} _amount
 */
function add_health(_amount) {
	// a new shield item caught mid-collapse brings it back at full thickness
	if (collapsing) {
		collapsing = false
		drawn_thickness = thickness
	}
	shield_health += _amount
	flash()
}

function absorb_hit() {
	shield_health--
	flash()
	if (shield_health <= 0) {
		collapsing = true
		collapse_elapsed = 0
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
