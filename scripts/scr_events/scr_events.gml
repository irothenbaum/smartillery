#macro EVENT_SCORE_CHANGED "score-changed"
#macro EVENT_INPUT_CHANGED "input-changed"
#macro EVENT_ENEMY_DAMAGED "enemy-damaged"
#macro EVENT_ENEMY_KILLED "enemy-killed"
#macro EVENT_TOGGLE_PAUSE "toggle-pause"
#macro EVENT_WRONG_GUESS "wrong-guess"
#macro EVENT_UTLTIMATE_LEVEL_UP "ultimate-level-up"
#macro EVENT_ON_OFF_STREAK "on-streak"
#macro EVENT_GAME_OVER "game-gover"
#macro EVENT_NEW_TURRET_ANGLE "new-turret-angle"
#macro EVENT_ENEMY_SPAWNED "new-enemy-spawned"

#macro EVENT_ALL "*all*"

global._events = {};

function subscribe(_event, _callback) {
    if(!struct_exists(global._events, _event)){
        global._events[$ _event] = [];
    }
    array_push(global._events[$ _event], _callback);
}

function broadcast(_event, _payload) {
	if (_event == EVENT_ALL) {
		throw "Cannot broadcast All"
	}
	
	// always send the event to our ALL listeners
    if(struct_exists(global._events, EVENT_ALL)){
        var _all_listeners = global._events[$ EVENT_ALL];
        for(var _i = 0; _i < array_length(_all_listeners); _i++){
            _all_listeners[_i](_payload, _event)
        }
    }
	
	// then send to event-specific listeners
    if(struct_exists(global._events, _event)){
        var _listeners = global._events[$ _event];
        for(var _i = 0; _i < array_length(_listeners); _i++){
            _listeners[_i](_payload, _event)
        }
    }
}