/// @description TODO: Draw the blocks and selcted idicator
// You can write your code in this editor
var _block_count_before = 0
var _guess = build_solution_from_keyboard_input(keyboard_string, blocks)
var _guess_string_length = string_length(_guess)
// TODO: this is not the right starting position
var _draw_pos = {x: global.xcenter, y: global.ycenter}
for (var _w = 0; _w < words_count; _w++) {
	var _blocks_count = array_length(words[_w])
	var _blocks = []
	var _styles = []
	for (var _b = 0; _b < _blocks_count; _b++) {
		array_push(_blocks, words[_w][_b])
		array_push(_styles, 
			typeof(_blocks[_w][_b]) == "string" 
				? MINI_CHALLENGE_BLOCK_STYLE_GIVEN
				: _blocks[_w][_b]
					? MINI_CHALLENGE_BLOCK_STYLE_RIGHT
					: MINI_CHALLENGE_BLOCK_STYLE_GUESS
					
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