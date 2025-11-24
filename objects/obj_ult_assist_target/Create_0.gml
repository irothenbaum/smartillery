/// @description Draw target effect
animation_progress = 0 // goes from 0 -> n
largest_size = global.player_body_radius * 20;
smallest_size = global.player_body_radius * 2;
spawn_time = get_play_time()
rotation_duration_ms = 300
color = is_undefined(color) ? global.ultimate_colors[$ ULTIMATE_ASSIST] : color
target_was_hit = false

subscribe(EVENT_ENEMY_HIT, method(self, function(_e) {
	if (_e == target) {
		target_was_hit = true
	}
	
	debug("STILL LISTENING")
}))