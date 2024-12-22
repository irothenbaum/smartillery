/// @description create phrase
// You can write your code in this editor

game_controller = get_game_controller()
var _phrase_details = create_typing_phrase(game_controller.current_wave + game_controller.ultimate_level)
words = _phrase_details.words
blocks = _phrase_details.blocks
total_letters = _phrase_details.total_letters

// seed keyboard_string with the first n letters that are provided
keyboard_string = ""
var _i = 0
while (typeof(blocks[0][_i]) == "string") {
	keyboard_string += blocks[0][_i]
	_i++
}

function check_solution(_solution) {
	var _previous_word_lengths = 0
	for (var _i = 0; _i < words; _i++) {
		var _this_word = words[_i]
		var _this_word_length = string_length(_this_word)
		var _entered_word = string_copy(_solution, _previous_word_lengths + 1, _this_word_length)
		
		update_blocks_from_guess(_entered_word, _i)
	}
}


function update_blocks_from_guess(_guessed_word, _block_index) {
	var _word = words[_block_index]
	var _word_length = string_length(_word)
	for (var _i = 0; _i < _word_length; _i++) {
		// this letter becoems either true (if it matches) or false (if it doesn't)
		// string values indicate that block was provided
		blocks[_block_index][_i] = string_char_at(_guessed_word, _i + 1) == string_char_at(_word, _i + 1)
	}
}