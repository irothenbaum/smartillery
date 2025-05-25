/// @description Set up event relays

// this map relates a network instance id to this game's instance id
instance_id_map = {}

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

subscribe(EVENT_INPUT_CHANGED, function(_payload) {
	
	
	array_push(event_bufer, {
		event_name: NET_EVENT_INPUT_CHANGED,
		player_steam_id: global.my_steam_id,
		input: _payload.input,
		is_on_streak: _payload.is_on_streak,
		is_wrong_guess: _payload.is_wrong_guess,
	})
})

subsribe(EVENT_ENEMY_SPAWNED, function(_enemy) {
	array_push(event_buffer, object_keys_copy({
		event_name: NET_EVENT_CREATE_INSTANCE,
		instance_id: _enemy.id,
		instance_type: global.networking_obj_to_instance_type[$ _enemy.object_index],
		x: _enemy.x,
		y: _enemy.y,
		equation: _enemy.equation,
	}, enemy_get_meta_state(_enemy)))
})

subsribe(EVENT_ENEMY_HIT, function(_enemy) {
	array_push(event_buffer, {
		event_name: NET_EVENT_ENEMY_HIT,
		instance_id: _enemy.id,
	})
})

// TODO: more event types to relay

// ---------------------------------------------------------------------------------------------
// Event Handling

function handle_create_instance(_event) {
	var _obj_type = global.networking_instance_type_to_obj[$ _event.instance_type]
	
	var _new_enemy = instance_create_layer(_event.x, _event.y, LAYER_INSTANCES, _obj_type, object_keys_copy({
		equation: _event.equation,
	}, enemy_convert_network_payload_to_state_object(_obj_type, _event)))
	
	instance_id_map[$ _event.instance_id] = _new_enemy.id
}

function handle_destroy_instance(_event) {
	instance_destroy(instance_id_map[$ _event.instance_id])
}

function handle_game_start(_event) {
	room_goto(rm_play_coop)
}

function handle_input_changed(_event) {
	// TODO: get peer's user_input instance and update its message
}

function handle_score_changed(_event) {
	var _gc = get_game_controller()

	_gc.unit_score = _event.unit_score
	_gc.streak_score = _event.streak_score
	_gc.combo_score = _event.combo_score
	_gc.game_score = _event.game_score
}

function handle_turret_angle_changed(_event) {
	var _player = get_player()

	_player.rotate_to = _event.rotate_to
	_player.rotate_speed = _event.rotate_speed
}

function handle_enemy_hit(_event) {
	var _enemy = layer_instance_get_instance(instance_id_map[$ _event.instance_id])
	
	if (is_undefined(_enemy)) {
		debug(string_concat("Could not find enemy with id ", _event.instance_id))
		return
	}
	
	_enemy.register_hit()
}


// ---------------------------------------------------------------------------------------------
// Event Receiving & Routing

var _event_name_to_handler_map = {
	NET_EVENT_GAME_START: handle_game_start,
	NET_EVENT_SCORE_CHANGED: handle_score_changed,
	NET_EVENT_CREATE_INSTANCE: handle_create_instance,
	NET_EVENT_DESTROY_INSTANCE: handle_destroy_instance,
	NET_EVENT_TURRET_ANGLE_CHANGED: handle_turret_angle_changed,
	NET_EVENT_INPUT_CHANGED: handle_input_changed,
	NET_EVENT_ENEMY_HIT: handle_enemy_hit,
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