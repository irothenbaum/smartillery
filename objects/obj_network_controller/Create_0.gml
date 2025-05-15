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

subscribe(EVENT_INPUT_CHANGED, function(_input) {
	array_push(event_bufer, {
		event_name: NET_EVENT_INPUT_CHANGED,
		player_steam_id: global.my_steam_id,
		input: _input
	})
})

// TODO: more event types to relay

// ---------------------------------------------------------------------------------------------
// Event Handling

function handle_create_instance(_e) {
	// TODO: How do we determine the instance type and instance meta data (equation, speed, direction, waypoints, etc)
	instance_create_layer(_e.x, _e.y, LAYER_INSTANCES, )
}

function handle_destroy_instance(_e) {
	// TODO: is this ID reliable across clients? Can we set it directly or do we need a proxy and lookup
	instance_destroy(_e.instance_id)
}

function handle_game_start(_e) {
	// TODO: whatever this even means
}

function handle_input_changed(_e) {
	// TODO: get peer's user_input instance and update its message
}

function handle_score_changed(_e) {
	var _gc = get_game_controller()

	_gc.unit_score = _e.unit_score
	_gc.streak_score = _e.streak_score
	_gc.combo_score = _e.combo_score
	_gc.game_score = _e.game_score	
}


// ---------------------------------------------------------------------------------------------
// Event Receiving & Routing

var _event_name_to_handler_map = {
	NET_EVENT_CREATE_INSTANCE: handle_create_instance,
	NET_EVENT_DESTROY_INSTANCE: handle_destroy_instance,
	NET_EVENT_GAME_START: handle_game_start,
	NET_EVENT_INPUT_CHANGED: handle_input_changed,
	NET_EVENT_SCORE_CHANGED: handle_score_changed,
	// TODO: more events
}

function handle_network_event(_event) {
	debug("Handling event", _event)
	var _handler = _event_name_to_handler_map[_event.event_name]
	
	if (is_undefined(_handler)) {
		throw string_concat("Missing event handler for event ", _event.event_name)
	}
	
	_handler(_event)
}