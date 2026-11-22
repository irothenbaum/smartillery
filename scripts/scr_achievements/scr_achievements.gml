// Steam achievement API names. These strings must exactly match the "API Name" of each
// achievement configured in Steamworks (App Admin -> Stats & Achievements -> Achievements).
#macro ACH_TRAINING_DOUBLE_DOWN "ACH_TRAINING_DOUBLE_DOWN"

/**
 * Unlocks a Steam achievement. Safe to call any number of times and when Steam isn't running:
 * it no-ops if Steam is unavailable or the achievement is already unlocked.
 * The extension queues a StoreStats() call that is sent during the next steam_update()
 * (see obj_steam_controller Begin Step), which is what triggers the Steam overlay popup.
 * @param {String} _ach_name -- one of the ACH_* macros
 * @returns {Bool} true if this call newly unlocked the achievement
 */
function unlock_achievement(_ach_name) {
	if (!steam_initialised() || !steam_stats_ready()) {
		return false
	}
	if (steam_get_achievement(_ach_name)) {
		return false
	}
	var _ok = steam_set_achievement(_ach_name)
	if (!_ok) {
		show_debug_message($"unlock_achievement: Steam rejected \"{_ach_name}\" -- is it defined and published in Steamworks?")
	}
	return _ok
}

/**
 * Debug only: re-locks an achievement so it can be earned again while testing.
 * @param {String} _ach_name
 */
function debug_clear_achievement(_ach_name) {
	if (steam_initialised()) {
		steam_clear_achievement(_ach_name)
	}
}
