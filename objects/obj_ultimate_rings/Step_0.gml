/// @description Ult step
ultimate_step(self)

// Decay recently struck rings over 1 second
var _delta = delta_time_seconds()
for (var _i = 0; _i < global.bg_number_of_circles; _i++) {
	if (recently_struck_rings[_i] > 0) {
		recently_struck_rings[_i] = max(0, recently_struck_rings[_i] - _delta)
	}
}