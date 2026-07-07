set_viewport_dimensions()

// NOTE: this room's placed instances (obj_game_controller, obj_hud, ...) run their
// Create events *before* this code -- see rm_main_menu's Room Creation Code for where
// the is_solo/active_player_ids/etc. bootstrap actually needs to happen for this room
// to work when reached via its dev shortcut.
