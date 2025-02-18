/// @description Draw the blocks and selcted idicator
// You can write your code in this editor
var _block_count_before = 0
var _guess = build_solution_from_keyboard_input(keyboard_string, blocks)
debug(string_concat("_guess: '", _guess, "'"))
var _guess_string_length = string_length(_guess)
// TODO: this is not the right starting position
var _draw_pos = {x: global.xcenter * 0.5, y: global.ycenter * 0.5}
for (var _w = 0; _w < words_count; _w++) {
	var _blocks_count = string_length(words[_w])
	var _blocks = []
	var _styles = []
	for (var _b = 0; _b < _blocks_count; _b++) {
		// TODO: This is basically always pushing the correct answer to the _blocks array.
		// in reality we only want to push the _guess
		array_push(_blocks, string_char_at(_guess, _block_count_before + _b + 1))
		array_push(_styles, 
			typeof(blocks[_w][_b]) == "string" 
				? MINI_CHALLENGE_BLOCK_STYLE_GIVEN
				: (
					blocks[_w][_b]
						? MINI_CHALLENGE_BLOCK_STYLE_RIGHT
						: MINI_CHALLENGE_BLOCK_STYLE_GUESS
				)
		)				
	}
	
	var _this_boundary = draw_word_blocks(
		_draw_pos.x, 
		_draw_pos.y, 
		_blocks, 
		_styles, 
		_guess_string_length >= _block_count_before && _guess_string_length < (_block_count_before + _blocks_count)
	)
	
	_draw_pos.x = _this_boundary.x1 + 40
	
	_block_count_before += _blocks_count
}