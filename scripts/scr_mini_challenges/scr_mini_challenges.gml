
function create_typing_phrase(_level = 1){
	var _blocks = []
	
	var _const_phrase_credits = global.max_word_length + _level
	var _phrase_credits = _const_phrase_credits
	do {
		var _next_word_length = irandom_range(global.min_word_length, min(_phrase_credits, global.max_word_length)) 
		_phrase_credits -= _next_word_length
		var _next_word = select_word_of_length(_next_word_length)
		array_push(_blocks, _next_word)
	} until(_phrase_credits < global.min_word_length)
	
	return {
		words: _blocks,
		total_letters: _const_phrase_credits,
		blocks: _remove_solution_boxes(_blocks)
	}
}

function create_math_phrase(_level = 1) {
	var _phrase = generate_equation_and_answer(_level)
	var _blocks = string_split(_phrase.equation, " ")
	
	return {
		equation: _phrase.equation,
		answer: _phrase.answer,
		terms: _blocks,
		blocks: _remove_solution_boxes(_blocks)
	}
}

/// @returns {Array<Array<boolean|string>>}
function _remove_solution_boxes(_words) {
	var _words_count = array_length(_words)
	
	var _ret_val = []
	for (var _h = 0; _h < _words_count; _h++) {
		var _block_count = string_length(_words[_h])
		var _blocks = []
		var _count_filled = 0
		var _max_fill = floor(_block_count / 2)
		for (var _i = 0; _i < _block_count; _i++) {
			// make sure we don't put too many prefilled blocks in
			// it's ok if we have very few or none prefilled blocks, but not a lot of filled blocks
			if (!flip_coin(2 + round((_i + 1) * _count_filled / (_block_count - _i)))) {
				_blocks[_i] = false
			} else {
				_blocks[_i] = string_char_at(_words[_h], _i + 1)
				_count_filled++
			}		
		}
	
		// if every box is filled at the end (very unlikely), just make the first and last unfilled
		if (_count_filled == _block_count) {
			_blocks[0] = false
			_blocks[_block_count - 1] = false
		}
	
		array_push(_ret_val, _blocks)
	}
}

function build_solution_from_keyboard_input(_input, _blocks) {
	var _solution = ""
	var _unshifted_count = 0
	var _block_count = array_length(_blocks)
	for (var _b = 0; _b < _block_count; _b++)  {
		var _this_block = _blocks[_b]
		var _word_length = array_length(_this_block)
		for (var _w = 0; _w < _word_length; _w++) {
			if (typeof(_this_block[_w]) == "string") {
				_solution += _this_block[_w]
			} else {
				_solution += string_char_at(_input, _unshifted_count + 1)
				_unshifted_count++
			}
		}
	}
	
	return _solution
}