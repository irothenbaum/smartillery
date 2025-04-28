// --------------------------------------------------------------------------------------
// This top section is networking event definitions
// The next section is sending event logic
// The third section is receiving event logic

#macro NET_EVENT_GAME_START "NET_EVENT_GAME_START"
#macro NET_EVENT_SCORE_CHANGED "NET_EVENT_SCORE_CHANGED"
#macro NET_EVENT_CREATE_INSTANCE "NET_EVENT_CREATE_INSTANCE"
#macro NET_EVENT_DESTROY_INSTANCE "NET_EVENT_DESTROY_INSTANCE"
#macro NET_EVENT_TURRET_ANGLE_CHANGED "NET_EVENT_TURRET_ANGLE_CHANGED"

// the numeric ID is simply the index in the array
var _numeric_id_to_event_name = [
	NET_EVENT_GAME_START,
	NET_EVENT_SCORE_CHANGED,
	NET_EVENT_CREATE_INSTANCE,
	NET_EVENT_DESTROY_INSTANCE
]

// we then create a reverse map of the array so we can get index from event name string
var _event_name_to_numeric_id = {}
array_foreach(_numeric_id_to_event_name, method({lookup: _event_name_to_numeric_id}, function(_item, _index) {
	lookup[_item] = _index
}))

// define the keys associated with each event
var _event_payload_keys = {
	// "event_name" is also an implied item on all these payloads
	NET_EVENT_GAME_START: ["host_id", "guest_id"],
	NET_EVENT_SCORE_CHANGED: ["player_steam_id", "unit_score", "streak_score", "combo_score", "game_score"],
	NET_EVENT_CREATE_INSTANCE: ["instance_id", "instance_type", "x", "y", "direction", "speed"],
	NET_EVENT_DESTROY_INSTANCE: ["instance_id"],
	NET_EVENT_TURRET_ANGLE_CHANGED: ["rotate_to", "rotate_speed"],
}

// define the type each key (prop on an event) is
var _payload_key_types = {
	"events_count": buffer_u8,
	"event_name": buffer_u8,
	
	// common
	"player_steam_id": buffer_u8,
	"instance_id": buffer_u8,
	
	// game start
	"guest_id": buffer_u8,
	"host_id": buffer_u8,
	
	// score changes
	"unit_score": buffer_u8,
	"streak_score": buffer_u8,
	"combo_score": buffer_u8,
	"game_score": buffer_u8,
	
	// turrent angle
	"rotate_to": buffer_u8,
	"rotate_speed": buffer_u8,
}

// --------------------------------------------------------------------------------------
// Sending events

function events_to_buffer(_events) {
	var _events_count = array_length(_events)
	
	var _buffer = buffer_create(256, buffer_grow, 1);
	buffer_write(_buffer, _payload_key_types["events_count"], _events_count); 
	
	for (var _i=0; _i < _events_count; _i++) {
		var _event = _events[_i]
		var _event_name = _event["event_name"]
		
		// first we buffer the event type (numeric id)
		buffer_write(buffer, _payload_key_types["event_name"], _event_name_to_numeric_id[_event_name])
		
		// load all the keys we intend to send according to this event name
		var _keys = _event_payload_keys[_event_name]
		
		// for each prop
		array_foreach(_keys, method({obj: _event, buffer: _buffer, types_map: _payload_key_types}, function(_key) {
			// write the value of each prop to the buffer using the type as defined in _payload_key_types
			buffer_write(buffer, types_map[_key], obj[_key])
		}))
		
		// repeat for all events in the events array
	}
	
	// return our final buffer
	return _buffer
}

function send_events_to(_events, _peer_steam_id) {
	var _buffer = events_to_buffer(_events)
	steam_net_send(_peer_steam_id, _buffer, buffer_tell(_buffer));
	buffer_delete(_buffer);
}

function send_event_to(_event, _peer_steam_id) {
	return send_events_to([_event], _peer_steam_id)
}

function send_event(_event) {
	return send_event_to(_event, global.partner_steam_id)
}

function send_events(_events) {
	return send_events_to(_events, global.partner_steam_id)
}

// --------------------------------------------------------------------------------------
// Receiving events

function handle_guest_received_event(_ev) {
	
}

function handle_host_received_event(_ev) {
	
}

function handle_received_event(_ev) {
	if (global.is_host) {
		handle_host_received_event(_ev)
	} else {
		handle_guest_received_event(_ev)
	}
}

function buffer_to_events(_buffer) {
	var _ret_val = []
	buffer_seek(_buffer, buffer_seek_start, 0);
	
	var _buffered_events_count = buffer_read(_buffer, _payload_key_types["events_count"])
	
	for (var _i = 0; _i < _buffered_events_count; _i++) {
		// event_name (numeric type) is always the first item pushed on the buffer
		var _event_numeric_id = buffer_read(_buffer, _payload_key_types["event_name"])
		
		// convert it back into its readable name
		var _event_name = _numeric_id_to_event_name[_event_numeric_id]
		
		// initialize our event object with this known key
		var _event_object = {
			"event_name": _event_name
		}
		
		// load the list of props that event expects to have
		var _keys = _event_payload_keys[_event_name]
		
		// for each event prop
		array_foreach(_keys, method({obj: _event_object, buffer: _buffer, types_map: _payload_key_types}, function(_key) {
			// save its prop name to our event object using that props known type from the _payload_key_types map
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

// This function is the main entry point, it is called in the step event
function check_for_messages() {
	while (steam_net_packet_receive()) {
		var _buffer = buffer_create(256, buffer_grow, 1);
		steam_net_packet_get_data(_buffer);
		
		var _events = buffer_to_events(_buffer)
		array_foreach(_events, handle_received_event)
		
		buffer_delete(_buffer);
	}
}