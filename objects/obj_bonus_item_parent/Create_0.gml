/// @description Shared bonus item setup
// Every bonus item (power items, extra ultimates) inherits from this object, the same way enemies inherit from
// obj_enemy_parent. Children call event_inherited() in their own Create -- after anything that has to happen before
// an answer is reserved (see obj_extra_ultimate) -- then override register_hit() with their effect.
// bonus items use launch codes (001, 002, ...) rather than equations: the code is both what's drawn and what's typed
draw_equation_position = undefined
equation_angle = undefined
last_hit_by_player_id = undefined
answer = get_game_controller().reserve_lowest_launch_code(self)
equation = answer
orbiter_initialize(self)
my_bounds = get_bounds_for_instance(self)

/// Children override this with their effect. The answer is released in Destroy, so overrides don't need to
function register_hit() {
	instance_destroy()
}
