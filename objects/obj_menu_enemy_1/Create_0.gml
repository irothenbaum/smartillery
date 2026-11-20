/// @description Main menu version of obj_enemy_1
// Same look and movement as obj_enemy_1 (see enemy_1_movement_step), but no equation, no game controller,
// no damage, and no spawn sound. Spawned by obj_menu_scene, shot by obj_menu_player.

// #7f7f7f is the body sprite's own gray, so drawing it through the shader looks the same as drawing it plain
enemy_attack_color_init(self, #7f7f7f)
image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
approach_speed = 1.6
rotate_speed = (irandom(1) == 0 ? -1 : 1) * (irandom(20) + 5) / 10
// enemy_1_movement_step reads this; menu enemies are never slowed
slow_multiplier = 1

waypoints = [get_tangent_point(x, y, global.xcenter, global.ycenter, global.room_height * 0.3)]

direction = point_direction(x, y, global.xcenter, global.ycenter)
speed = approach_speed
