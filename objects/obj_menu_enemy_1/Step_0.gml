enemy_1_movement_step(self)

// the menu player should always get it first, but if one slips through it just bursts -- no damage on the menu
if (point_distance(x, y, global.xcenter, global.ycenter) < global.player_body_radius) {
	instance_destroy()
}
