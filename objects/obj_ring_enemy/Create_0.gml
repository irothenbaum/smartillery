/// @description spawn entries
enemy_initialize(self, true)

image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
sequence_data = string_length(sequence_key) == 0 ? generate_sequence_from_wave(get_current_wave_number()) : get_sequence_from_label_and_length(sequence_key, sequence_length)
sequence = sequence_data.sequence
sequence_key = sequence_data.key
sequence_label = sequence_data.label
sequence_length = array_length(sequence)
sequence_label_length = string_length(sequence_label)
angle_between_entries = 360 / sequence_length
target_index = target_index < 0 ? irandom(sequence_length - 1) : target_index

// ------------------------------------------------------
// Swap the target number in sequence and register it with game controller
var _num = sequence[target_index]
var _game_controller = get_game_controller()

var _attempts = 0
answer = undefined
while(is_undefined(answer)) {
	// swap it with some number between 1 and 2*n
	answer = roll_dice(_num * 2)
	// in the unlikely event that our random number is exactly our starting number, we just add 1
	if (answer == _num) {
		answer = _num + 1
	}
	
	answer = string(answer)
	
	if (_game_controller.is_answer_reserved(answer)) {
		answer = undefined
		_attempts++
		
		if (_attempts > 5) {
			debug("Failed to select answer for enemy_5")
			instance_destroy()
		}
	} else {
		debug("Answer not reserved,", answer)
	}
}

debug("Reserving answer", answer, typeof(answer), _game_controller.is_answer_reserved(answer))

equation = answer
_game_controller.reserve_answer(answer, self)
// ------------------------------------------------------

distance_to_player = point_distance(x, y, global.xcenter, global.ycenter) // this is updated at the start of every step
direction_to_target = point_direction(global.xcenter, global.ycenter, x, y)
direction = direction_to_target + 180
speed = 1.6

death_duration = 2 * game_get_speed(gamespeed_fps)
function register_hit(_insta_kill = false) {
	speed = 0
	instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: draw_particle_enemy_1_destroy});
	alarm[0] = death_duration
}

// this function ensures our target entry is drawn on our x,y position
	// all the other entries are shifted in degree based on their relative position
	// in the sequence to the target index
function get_entry_position(_index) {
	// always draw the target on our x,y
	if (_index == target_index) {
		return {x: x, y: y, rotation: direction}
	}
	
	// otherwise, determine how far in the sequence this entry is from the target
	var _dif_from_index = _index - target_index
	
	// use that difference to determine angular distance from target entry
	// (multiplying by the known angle between entries
	var _direction_to_entry = direction_to_target + (_dif_from_index * angle_between_entries)
	
	// work back the x,y, and rotation using this angle
	return {
		x: global.xcenter + lengthdir_x(distance_to_player, _direction_to_entry),
		y: global.ycenter + lengthdir_y(distance_to_player, _direction_to_entry),
		rotation: _direction_to_entry + 180,
	}
}

function draw_label_on_curve(_start_angle) {
	draw_set_font(fnt_small)
	var _circumference = TAU * distance_to_player
	var _label_width = string_width(sequence_label)
	
	// this is the distance in pixels available to draw in, 
	// it subtracts sprite_width to ensure we don't overlap the entiry sprites
	var _arc_space = ((angle_between_entries / 360) * _circumference) - sprite_width
	
	// if we don't have enough space to draw the label, then don't
	if (_label_width > _arc_space) {
		return
	}
	
	// the total arc area of the label
	var _label_arc_angle = (_label_width / _circumference) * 360
	
	// the angle to start drawing the first character at
	// this will be modified in the loop after each character is drawn
	var _label_draw_start_angle = _start_angle + (angle_between_entries - _label_arc_angle) / 2 
	
	for (var _i = 0; _i < sequence_label_length; _i++) {
		var _this_char = string_char_at(sequence_label, _i)
		// draw the current character in the label at the specified position
		draw_text_transformed(
			global.xcenter + lengthdir_x(distance_to_player, _label_draw_start_angle), 
			global.ycenter + lengthdir_y(distance_to_player, _label_draw_start_angle),
			_this_char,
			1, 
			1,
			_label_draw_start_angle
		)
		
		// increment our draw angle so the next character is shifted apprporiately
		_label_draw_start_angle = _label_draw_start_angle + (string_width(_this_char) / _circumference) * 360
	}
}

broadcast(EVENT_ENEMY_SPAWNED, self)