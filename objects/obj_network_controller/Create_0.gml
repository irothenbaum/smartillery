/// @description Set up event relays

// ---------------------------------------------------------------------------------------------
// Event Sending
event_buffer = []

subscribe(EVENT_SCORE_CHANGED, function(_payload) {
	array_push(event_buffer, {
		event_name: NET_EVENT_SCORE_CHANGED,
		unit_score: _payload.unit_score,
		streak_score: _payload.streak_score,
		combo_score: _payload.combo_score,
		game_score: _payload.game_score,
		player_steam_id: global.my_steam_id
	})
})

subscribe(EVENT_ENEMY_KILLED, function(_enemy) {
	array_push(event_buffer, {
		event_name: NET_EVENT_DESTROY_INSTANCE,
		instance_id: _enemy.id
	})
})

subscribe(EVENT_NEW_TURRET_ANGLE, function(_payload) {
	array_push(event_bufer, {
		event_name: NET_EVENT_TURRET_ANGLE_CHANGED,
		rotate_to: _payload.rotate_to,
		rotate_speed: _payload.rotate_speed,
	})
})

// TODO: more event types to relay

// ---------------------------------------------------------------------------------------------
// Event Receiving