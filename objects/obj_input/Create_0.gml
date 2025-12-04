message = "";

if (is_undefined(owner_player_id) || owner_player_id == NON_STEAM_PLAYER) {
	owner_player_id = get_my_steam_id_safe()
}

is_controlled = owner_player_id == get_my_steam_id_safe()
my_color = get_player_color(owner_player_id)

// --------------------------------------------------------
// DETERMINE POSITION FOR THIS INPUT
// this may not be immediately inuitive, but this logic ensures the correct input locations for each player
var _top_y = 40
var _bottom_y = global.room_height - 40

// TODO: DeviceSizeCheck
var _multiplayer_input_shift_off_center = global.room_width * 0.15

var _left_x = global.xcenter - _multiplayer_input_shift_off_center
var _right_x = global.xcenter + _multiplayer_input_shift_off_center

// if it's solo or there are 3 and we're the third, we align center
var _align_center = global.is_solo || get_players_count() == 3 && get_player_number(owner_player_id) == 2
var _align_bottom = global.is_coop && get_player_number(owner_player_id) > 1


y = _align_bottom ? _bottom_y : _top_y
initial_x = _align_center ? global.xcenter : ((get_player_number(owner_player_id) % 2) == 0 ? _left_x : _right_x)

// --------------------------------------------------------

x = initial_x
render_x = x

min_box_width = 80
streak_ratio = 0
draw_streak_ratio = 0
shake_start = undefined

// how long we shake for (milliseconds)
total_shake_time = 500
// how many shakes we do
total_shakes = 3
shake_magnitude = 10
last_guess = ""

if (is_undefined(owner_player_id) || owner_player_id == 0) {
	owner_player_id = get_my_steam_id_safe()
}

my_bounds = undefined
streak_fire = undefined

function size_streak_fire() {
	part_emitter_region(streak_fire.system, streak_fire.emitter, 0, my_bounds.width, 0, 0, ps_shape_rectangle, ps_distr_linear);
	part_system_position(streak_fire.system, my_bounds.x0, my_bounds.y1)		
}

// whenver we pause or unpause we clear the input
subscribe(self, EVENT_TOGGLE_PAUSE, function(_status) {
	message = ""
	
	if (!is_undefined(streak_fire)) {
		pause_particle(streak_fire.system, _status)
	}
})

subscribe(self, EVENT_GAME_OVER, function() {
	// effectively destroy the particle system
	broadcast(EVENT_ON_OFF_STREAK, false, owner_player_id)
})

subscribe(self, EVENT_ON_OFF_STREAK, function(_streak_count) {
	if (_streak_count >= global.point_streak_requirement) {
		if (is_undefined(streak_fire)) {
			streak_fire = draw_muzzle_smoke(x, y, my_color)
			size_streak_fire()
		}
	} else if (_streak_count == 0) {
		// whenever our streak drops back to 0, we shake
		shake_start = get_play_time()
		// total_shake_time is in milliseconds
		alarm[0] = game_get_speed(gamespeed_fps) * total_shake_time / 1000
		if (is_undefined(streak_fire)) {
			return
		}
		destroy_particle(streak_fire.system)
		streak_fire = undefined
	}
}, owner_player_id)
