/// @description Release answer
// however the item goes away (hit, cleared at game end, failed setup), its answer is freed for other targets.
// answer won't exist if a child destroyed itself before calling event_inherited() in Create (see obj_extra_ultimate)
if (variable_instance_exists(id, "answer")) {
	get_game_controller().release_answer(answer)
}
