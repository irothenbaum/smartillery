/// @description Main menu background scene
// The ring background, obj_menu_player, and a steady trickle of obj_menu_enemy_1 for the turret to shoot.
// There are no waves, equations, HUD, or damage. Created by obj_menu_controller; the zoomed camera is set in
// rm_main_menu's creation code (set_menu_viewport_dimensions).

// rm_main_menu only has Instances (depth 0) and Background (depth 100), but muzzle flashes and destroy
// particles go on the effects layers, so make them (same order as the play rooms)
if (!layer_exists(LAYER_BG_EFFECTS)) {
	layer_create(50, LAYER_BG_EFFECTS)
}
if (!layer_exists(LAYER_FG_EFFECTS)) {
	layer_create(-50, LAYER_FG_EFFECTS)
}

// above the room's background color, below the effects. obj_background draws full health when there's no obj_player
instance_create_depth(global.xcenter, global.ycenter, 90, obj_background)
instance_create_layer(global.xcenter, global.ycenter, LAYER_INSTANCES, obj_menu_player)

target_enemy_count = 5
min_spawn_delay = 0.6 // in seconds
max_spawn_delay = 1.5 // in seconds

// radial dim behind the menu buttons (Draw GUI Begin), darkest in the middle of the lower-left quadrant
dim_center_x_ratio = 0.25 // of GUI width
dim_center_y_ratio = 0.75 // of GUI height
dim_radius_ratio = 0.9 // of GUI width
dim_max_alpha = 0.75
dim_segments = 48

function spawn_enemy() {
	var _pos = get_menu_enemy_spawn_position()
	instance_create_layer(_pos.x, _pos.y, LAYER_INSTANCES, obj_menu_enemy_1)
}

// start with a couple already on their way so the scene isn't empty while the rings boot up
spawn_enemy()
spawn_enemy()
