#macro EVENT_SCORE_CHANGED "score-changed"
#macro EVENT_INPUT_CHANGED "input-changed"
#macro EVENT_ENEMY_HIT "enemy-hit"
#macro EVENT_ENEMY_KILLED "enemy-killed"
#macro EVENT_TOGGLE_PAUSE "toggle-pause"
#macro EVENT_WRONG_GUESS "wrong-guess"
#macro EVENT_UTLTIMATE_LEVEL_UP "ultimate-level-up"
#macro EVENT_ON_OFF_STREAK "on-streak"
#macro EVENT_GAME_OVER "game-gover"
#macro EVENT_NEW_TURRET_ANGLE "new-turret-angle"
#macro EVENT_ENEMY_SPAWNED "new-enemy-spawned"
#macro EVENT_SUBMIT_CODE "submit-code"

global._events = {};

/**
 * @param {String} _event
 * @param {Function} _callback
 * @param {String|Array<String>} _steam_id
 */
function subscribe(_event, _callback, _steam_id = undefined) {
	if (is_undefined(_steam_id)) {
		_steam_id = get_my_steam_id_safe()
	} else if (is_array(_steam_id)) {
		// if you pass an array, you'll subscribe to each of those channels
		array_foreach(_steam_id, method({_e: _event, _c: _callback}, function(_s_id) {
			subscribe(_e, _c, _s_id)
		}))
		return
	}
	
	var _composite_event_name = string_concat(_steam_id, _event)
    if(!struct_exists(global._events, _composite_event_name)){
        global._events[$ _composite_event_name] = [];
    }
    array_push(global._events[$ _composite_event_name], _callback);
}

/**
 * @param {String} _event
 * @param {Any} _payload
 * @param {String} _steam_id
 */
function broadcast(_event, _payload, _steam_id = undefined) {
	if (is_undefined(_steam_id)) {
		_steam_id = get_my_steam_id_safe()
	}
	
	var _composite_event_name = string_concat(_steam_id, _event)
	
	// then send to event-specific listeners
    if(struct_exists(global._events, _composite_event_name)){
        var _listeners = global._events[$ _composite_event_name];
        for(var _i = 0; _i < array_length(_listeners); _i++){
			// passes payload, the event name, the steam id, and the composite event name as params
            _listeners[_i](_payload, _event, _steam_id, _composite_event_name)
        }
    }
}