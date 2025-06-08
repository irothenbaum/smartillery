// This mini challenge is when an equation or word is presented to you and you need to fill
// in the missing areas. Not currently in use in the game

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
		total_letters: _const_phrase_credits - _phrase_credits,
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
	
	return _ret_val
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
				var _this_character = string_char_at(_input, _unshifted_count + 1)
				if (typeof(_this_character) != "string" || _this_character == "") {
					_this_character = " "
				}
				_solution += _this_character
				_unshifted_count++
			}
		}
	}
	
	return _solution
}

#macro MINI_CHALLENGE_BLOCK_STYLE_GIVEN "given"
#macro MINI_CHALLENGE_BLOCK_STYLE_GUESS "guess"
#macro MINI_CHALLENGE_BLOCK_STYLE_WRONG "wrong"
#macro MINI_CHALLENGE_BLOCK_STYLE_RIGHT "right"

/**
 * @param {number} _x -- x position
 * @param {number} _y -- y position
 * @param {Array<string>} _block -- the block content
 * @param {Array<string>} _styles -- the block styles
 * @param {boolean} _is_focused
 */
function draw_word_blocks(_x, _y, _block, _styles, _is_focused) {
	debug("DRAWING WORD BLOCK", _block, _styles, _is_focused)
	
	var _padding = 20
	var _bounds = {
		x0: _x,
		y0: _y,
		x1: _x,
		y1: _y
	}
	var _squares_count = array_length(_block)
	for (var _i = 0; _i < _squares_count; _i++) {
		
		// draw the square content
		var _this_square_bounds = draw_text_with_alignment(_bounds.x1, _bounds.y0, _block[_i], ALIGN_LEFT)
		// shift our bounds to include this new square
		_bounds.x1 = _this_square_bounds.x1
		// apply padding to all internal squares
		if (_i > 0 && _i < _squares_count - 1) {
			_bounds.x1 = _bounds.x1 + _padding
			// draw vertical line indicating space between characters
			draw_line(_bounds.x1, _bounds.y0 - _padding, _bounds.x1, _bounds.y1 + _padding)
			_bounds.x1 = _bounds.x1 + _padding
		}
	}
	
	// draw external padding and then draw the word containing box
	_bounds = _apply_padding_to_bounds(_bounds, _padding, _padding)
	draw_rounded_rectangle(_bounds, _padding / 2, _is_focused ? 6 : 2)
	return _bounds
}