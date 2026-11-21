/// @description Shared power item setup
// Parent of every power item type (obj_power_item_shield, _turret, _health, _points, _level_up). It's never spawned
// directly -- pick_power_item_object() chooses which child to spawn. Children call event_inherited() first, then set
// their color/label and override register_hit() with their effect.
event_inherited()

radius = global.player_body_radius

// placeholder look until proper sprite assets are made: a colored circle with the type's initials.
// Children set these; a child with a real icon overrides Draw instead
color = c_white
label = ""
