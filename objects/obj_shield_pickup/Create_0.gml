/// @description Fly a shield item into place
// Spawned by obj_power_item_shield when it's hit. Starts as the item's miniature shield at the item's position, then
// quickly moves to the player while growing, landing exactly where (and as big as) the real shield is drawn.
// On arrival it becomes the shield: either spawning obj_shield or stacking onto the existing one.
// Expects: start_scale (the miniature's scale relative to the full shield)
start_x = x
start_y = y
elapsed = 0 // seconds
duration = 0.35 // seconds to reach the player
scale = start_scale

function land() {
	var _shield = instance_find(obj_shield, 0)
	if (_shield != noone) {
		_shield.add_health(1)
	} else {
		instance_create_layer(global.xcenter, global.ycenter, LAYER_BG_EFFECTS, obj_shield)
	}
	instance_destroy()
}
