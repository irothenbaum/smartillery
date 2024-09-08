global._events = {};

function subscribe(_event, _callback){
    if(!struct_exists(global._events, _event)){
        global._events[$ _event] = [];
    }
    array_push(global._events[$ _event], _callback);
}

function broadcast(_event, _payload){
    if(struct_exists(global._events, _event)){
        var _listeners = global._events[$ _event];
        for(var _i = 0; _i < array_length(_listeners); _i++){
            _listeners[_i](_payload)
        }
    }
}