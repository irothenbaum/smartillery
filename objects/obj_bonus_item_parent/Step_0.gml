/// @description Shared bonus item step: tip + orbit
tip_step(self)
if (global.paused) {
	return
}

orbiter_step(self)
my_bounds = get_bounds_for_instance(self)
