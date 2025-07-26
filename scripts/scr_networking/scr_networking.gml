// --------------------------------------------------------------------------------------
// This top section is networking event definitions
// The next section is sending event logic
// The third section is receiving event logic

#macro NET_EVENT_GAME_START "NET_EVENT_GAME_START"
#macro NET_EVENT_SCORE_CHANGED "NET_EVENT_SCORE_CHANGED"
#macro NET_EVENT_CREATE_INSTANCE "NET_EVENT_CREATE_INSTANCE"
#macro NET_EVENT_DESTROY_INSTANCE "NET_EVENT_DESTROY_INSTANCE"
#macro NET_EVENT_TURRET_ANGLE_CHANGED "NET_EVENT_TURRET_ANGLE_CHANGED"
#macro NET_EVENT_INPUT_CHANGED "NET_EVENT_INPUT_CHANGED"
#macro NET_EVENT_ENEMY_HIT "NET_EVENT_ENEMY_HIT"
#macro NET_EVENT_SUBMIT_CODE "NET_EVENT_SUBMIT_CODE"

// the numeric ID is simply the index in the array
global._G.numeric_id_to_event_name = [
	NET_EVENT_GAME_START,
	NET_EVENT_SCORE_CHANGED,
	NET_EVENT_CREATE_INSTANCE,
	NET_EVENT_DESTROY_INSTANCE,
	NET_EVENT_TURRET_ANGLE_CHANGED,
	NET_EVENT_INPUT_CHANGED,
	NET_EVENT_ENEMY_HIT,
	NET_EVENT_SUBMIT_CODE
]

// we then create a reverse map of the array so we can get index from event name string
global._G.event_name_to_numeric_id = {}
array_foreach(global._G.numeric_id_to_event_name, method({lookup: global._G.event_name_to_numeric_id}, function(_item, _index) {
	lookup[$ _item] = _index
}))

// define the keys associated with each event
global._G.event_payload_keys = {
	// "event_name" is also an implied item on all these payloads
	NET_EVENT_GAME_START: ["host_id", "guest_id"],
	NET_EVENT_SCORE_CHANGED: ["player_id", "unit_score", "streak_score", "combo_score", "game_score"],
	NET_EVENT_CREATE_INSTANCE: ["instance_id", "instance_type", "x", "y", "equation", "meta0", "meta1", "meta2", "meta3", "meta4", "meta5"],
	NET_EVENT_DESTROY_INSTANCE: ["instance_id"],
	NET_EVENT_TURRET_ANGLE_CHANGED: ["rotate_to", "rotate_speed"],
	NET_EVENT_INPUT_CHANGED: ["player_id", "input"],
	NET_EVENT_ENEMY_HIT: ["instance_id", "player_id"],
	NET_EVENT_SUBMIT_CODE: ["player_id", "code"],
}

// define the type each key (prop on an event) is
global._G.payload_key_types = {
	// common
	"events_count": buffer_u8,
	"event_name": buffer_u8,
	"player_id": buffer_u8,
	"instance_id": buffer_u8,
	
	// NET_EVENT_GAME_START
	"guest_id": buffer_u8,
	"host_id": buffer_u8,
	
	// NET_EVENT_SCORE_CHANGED
	"unit_score": buffer_u8,
	"streak_score": buffer_u8,
	"combo_score": buffer_u8,
	"game_score": buffer_u8,
	
	// NET_EVENT_TURRET_ANGLE_CHANGED
	"rotate_to": buffer_u8,
	"rotate_speed": buffer_u8,
	
	// NET_EVENT_INPUT_CHANGED
	"input": buffer_u8,
	"streak_count": buffer_u8,
	"is_wrong_guess": buffer_u8,
	
	// NET_EVENT_CREATE_INSTANCE
	"instance_type": buffer_u8,
	"x": buffer_u8, 
	"y": buffer_u8, 
	"equation": buffer_u8, 
	"meta0": buffer_u8,
	"meta1": buffer_u8,
	"meta2": buffer_u8,
	"meta3": buffer_u8,
	"meta4": buffer_u8,
	"meta5": buffer_u8,
	
	// NET_EVENT_SUBMIT_CODE
	"code": buffer_u8
}

// this is a shorthand to represent the meta0 - meta5 prop count
#macro NET_TOTAL_META_PROPS 6

// --------------------------------------------------------------------------------------
// Instance Type Maps

global.networking_instance_type_to_obj = [
	obj_compound_enemy_1,
	obj_compound_enemy_2,
	obj_enemy_1,
	obj_enemy_2,
	obj_enemy_3,
	obj_enemy_4,
	obj_enemy_5,
	
]

global.networking_obj_to_instance_type = {}
array_foreach(global.networking_instance_type_to_obj, function(_type, _index) {
	global.networking_obj_to_instance_type[$ _type] = _index
})

// --------------------------------------------------------------------------------------
// Sending events

/**
 * @param {Array<Struct.NetworkingEvents>} _events
 */
function events_to_buffer(_events) {
	var _events_count = array_length(_events)
	
	var _buffer = buffer_create(256, buffer_grow, 1);
	buffer_write(_buffer, global._G.payload_key_types.events_count, _events_count); 
	
	for (var _i=0; _i < _events_count; _i++) {
		var _event = _events[_i]
		var _event_name = _event.event_name
		
		// first we buffer the event type (numeric id)
		buffer_write(buffer, global._G.payload_key_types.event_name, global._G.event_name_to_numeric_id[_event_name])
		
		// load all the keys we intend to send according to this event name
		var _keys = global._G.event_payload_keys[_event_name]
		
		// for each prop
		array_foreach(_keys, method({obj: _event, buffer: _buffer, types_map: global._G.payload_key_types}, function(_key) {
			if (!struct_exists(types_map, _key)) {
				debug(string_concat("Type map missing key ", _key))
				return
			}
			
			if (struct_exists(obj, _key)) {
				// write the value of each prop to the buffer using the type as defined in global._G.payload_key_types
				buffer_write(buffer, types_map[_key], obj[_key])
			} else {
				// this may happen for the meta state variables, we just send 0 it doesn't/shouldn't matter
				buffer_write(buffer, types_map[_key], 0)
			}
		}))
		
		// repeat for all events in the events array
	}
	
	// return our final buffer
	return _buffer
}

/**
 * @param {Array<Struct.NetworkingEvent>} _events
 * @param {string} _peer_steam_id
 */
function send_events_to(_events, _peer_steam_id) {
	var _buffer = events_to_buffer(_events)
	steam_net_send(_peer_steam_id, _buffer, buffer_tell(_buffer))
	buffer_delete(_buffer)
}

/**
 * @param {Struct.NetworkingEvent} _event
 * @param {string} _peer_steam_id
 */
function send_event_to(_event, _peer_steam_id) {
	return send_events_to([_event], _peer_steam_id)
}

/**
 * @param {Struct.NetworkingEvent} _event
 */
function send_event(_event) {
	return send_event_to(_event, get_partner_steam_id_safe())
}

/**
 * @param {Array<Struct.NetworkingEvent>} _events
 */
function send_events(_events) {
	return send_events_to(_events, get_partner_steam_id_safe())
}

// --------------------------------------------------------------------------------------
// Receiving events

/**
 * @returns {Array<Struct.NetworkingEvent>}
 */
function buffer_to_events(_buffer) {
	var _ret_val = []
	buffer_seek(_buffer, buffer_seek_start, 0);
	
	var _buffered_events_count = buffer_read(_buffer, global._G.payload_key_types.events_count)
	
	for (var _i = 0; _i < _buffered_events_count; _i++) {
		// event_name (numeric type) is always the first item pushed on the buffer
		var _event_numeric_id = buffer_read(_buffer, global._G.payload_key_types.event_name)
		
		// convert it back into its readable name
		var _event_name = global._G.numeric_id_to_event_name[_event_numeric_id]
		
		// initialize our event object with this known key
		var _event_object = {
			"event_name": _event_name
		}
		
		// load the list of props that event expects to have
		var _keys = global._G.event_payload_keys[_event_name]
		
		// for each event prop
		array_foreach(_keys, method({obj: _event_object, buffer: _buffer, types_map: global._G.payload_key_types}, function(_key) {
			// save its prop name to our event object using that props known type from the global._G.payload_key_types map
			obj[_key] = buffer_read(buffer, types_map[_key])
		}))
		
		// include this object in our events array
		array_push(_ret_val, _event_object)
	}
	
	// at this point, the buffer should be empty
	
	// return all events parsed from the buffer
	return _ret_val
}

// --------------------------------------------------------------------------------------

// This function is the main entry point, it should be called in the step event
function check_for_network_events() {
	var _ret_val = []
	while (steam_net_packet_receive()) {
		var _buffer = buffer_create(256, buffer_grow, 1);
		steam_net_packet_get_data(_buffer);
		
		var _events = buffer_to_events(_buffer)
		array_copy(_ret_val, array_length(_ret_val), _events, 0, array_length(_events))
		
		buffer_delete(_buffer);
	}
	
	return _ret_val
}

// -------------------------------------------------------------------------------------
// Meta state and networking tools
global.instance_type_to_meta_variables_array = {
	obj_enemy_1: ["waypoints", "direction"],
	obj_enemy_2: ["firing_position"],
	obj_enemy_3: [],
	obj_enemy_4: [],
	obj_enemy_4_fragment: ["target_delay", "direction"],
	obj_enemy_5: ["sequence_key", "sequence_length", "target_index", "answer"],
	obj_muzzle_flash: ["width", "color", "target_x", "target_y"]
}

// this converts the enemy instance variables inta meta0, meta1, meta2, etc
// the meta order matches the relevant_meta_vars array order
/// @returns {Struct}
function instance_get_meta_state(_inst) {
	var _ret_val = {}
	var _meta_vars = global.instance_type_to_meta_variables_array[_inst.object_index]
	var _relevant_meta_vars_length = array_length(_meta_vars)
	for (var _i = 0; _i < NET_TOTAL_META_PROPS; _i++) {
		var _meta_val = 0
		if (_i < _relevant_meta_vars_length) {
			var _var_name = _meta_vars[_i]
			_meta_val = _inst[$ _var_name]
		} else {
			// this instance doesn't have that many meta variables,
			// set it to the default value (it will be ignored)
			_meta_val = 0
		}
		
		_ret_val[$ string_concat("meta", _i)] = _meta_val
	}
	
	return _ret_val
}


// this is the inverse of instance_get_meta_state
/// @param {Instance} _instance_type
/// @param {Struct} _payload
/// @return {Struct}
function instance_convert_network_payload_to_state_object(_instance_type, _payload) {
	var _relevant_meta_vars = global.instance_type_to_meta_variables_array[_instance_type]
	var _ret_val = {}
	var _relevant_meta_vars_length = array_length(_relevant_meta_vars)
	for (var _i = 0; _i < _relevant_meta_vars_length; _i++) {
		var _var_name = _relevant_meta_vars[_i]
		_ret_val[$ _var_name] = _payload[$ string_concat("meta", _i)]
	}
	
	return _ret_val
}


/**
 * @param {string} _event_name
 * @param {Struct} _props
 */
function NetworkingEvent(_event_name, _props) constructor {
	event_name = _event_name
	
	var _keys = variable_struct_get_names(_props);
	for (var _i = array_length(_keys)-1; _i >= 0; --_i) {
	    var _k = _keys[_i];
	    var _v = _props[$ _k];
	    self[$ _k] = _v
	}
}