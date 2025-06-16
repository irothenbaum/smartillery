/// @description handle net events
// You can write your code in this editor

function handle_submit_code(_code) {
	broadcast(EVENT_SUBMIT_CODE, _code)
}

function handle_enemy_killed(_e) {
	// do nothing (this is handled by our Host controller and handled by the client via INSTANCE_CREATE and INSTANCE_DESTROY events)
}