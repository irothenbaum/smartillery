/**
 * @param {Id.Instance} _i
 */
function tip_step(_i) {
	// tip only applies when paused
	if (!global.paused || instance_number(obj_ultimate_strike) > 0) {
		return
	}
	
	with (_i) {
		if (is_undefined(my_bounds)) {
			debug("TIP ENABLED ELEMENT MISSING BOUNDS", self)
			return
		}
		
		if (is_spot_in_bounds(mouse_x, mouse_y, my_bounds)) {
			if (instance_number(obj_pause_overlay) > 0) {
				var _overlay = instance_find(obj_pause_overlay, 0)
				_overlay.set_hovered_instance(self)
			}
		}
	}
}