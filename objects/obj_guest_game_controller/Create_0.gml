/// @description handle net events
// You can write your code in this editor

function handle_submit_code(_code) {
	broadcast(EVENT_SUBMIT_CODE, _code)
}

function handle_enemy_killed(_e) {
	// do nothing (this is handled by our Host controller and handled by the client via INSTANCE_CREATE and INSTANCE_DESTROY events)
}

function mark_wave_completed() {
	// this is called by obj_select_ultimate , but for the guest it doesn't need to do anything
}