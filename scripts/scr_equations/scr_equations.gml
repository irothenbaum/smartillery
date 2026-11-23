function get_allowed_operations_for_answer(_answer, _max) {
	return [
		true, // can always do addition
		_answer < _max, // subtraction only allowed if answer is less than max
		_answer > 1, // we want multiplication equations to be >= 2
		_answer > 0 && _answer <= _max * 0.25, // only allow division if the answer is less than one fourth of _max,
		_answer >= 4, // the lowest power we'll consider is 2^2
		_answer >= 4, // the lowest power we'll consider is 2^2
	]
}

/**
 * @param {Real} _answer
 * @param {Real} _max
 * @param {Real} [_difficulty] index into global.operations_order of the hardest operation allowed
 * @param {Real} [_newest_operation_weight] how likely the hardest operation is compared to the others (1 = equally
 *   likely). Used to ease a newly unlocked operation in over a few waves (see generate_equation_and_answer)
 */
function generate_equation(_answer, _max, _difficulty = 0, _newest_operation_weight = 1) {
	_difficulty = min(_difficulty, array_length(global.operations_order) - 1)
	var _allowed_operations = get_allowed_operations_for_answer(_answer, _max)

	// weighted pick among the allowed operations up to _difficulty. Addition is always allowed, so there's always
	// at least one option
	var _weights = array_create(_difficulty + 1, 0)
	var _total_weight = 0
	for (var _i = 0; _i <= _difficulty; _i++) {
		if (_allowed_operations[_i]) {
			_weights[_i] = (_i == _difficulty) ? _newest_operation_weight : 1
			_total_weight += _weights[_i]
		}
	}

	var _dice = 0
	var _roll = random(_total_weight)
	for (var _i = 0; _i <= _difficulty; _i++) {
		if (_weights[_i] <= 0) {
			continue
		}
		_dice = _i
		_roll -= _weights[_i]
		if (_roll < 0) {
			break
		}
	}
	
	var _term1 = undefined;
	var _term2 = undefined;
	// equation override is only use for dice == 4 or 5 because those exponent equations don't follow the same pattern
	var _equation_override = undefined
	var _operation = "";
	if (_dice == 0) {
		_operation = "+";
		_term1 = irandom_range(1, _answer - 1)
		_term2 = _answer - _term1
		
	} else if (_dice == 1) {
		_operation = "-";
		_term1 = irandom_range(_answer, _max)
		_term2 = _term1 - _answer;
		
	} else if (_dice == 2) {
		_operation = "x";
		_term1 = irandom_range(2, _answer / 2)
		_term2 = max(2, int64(_answer / _term1))
		_answer = _term1 * _term2
	} else if (_dice == 3) {
		_operation = "/";
		// due to the above dice roll, we know the answer < 25% of _max
		_term2 = irandom_range(2, ceil(_max / _answer))
		_term1 = _answer * _term2;
		_answer = _term1 / _term2;
	} else {
		// we only do powers of 2 and 3
		var _exponent = _answer > (_max / 2) ? 3 : 2
		var _nearest_base = round(power(_answer, 1/_exponent))
		var _expo_answer = power(_nearest_base, _exponent)
		
		_equation_override = string(_nearest_base) + "^" + string(_exponent)
		if (_dice == 4 || _expo_answer == _answer) {
			// on difficulty 4 the equation is simply the exponent math
			_answer = _expo_answer
			// no need to modify equation override
		} else {
			var _answer_diff = _answer - _expo_answer
			// on difficulty 5 we include the difference
			_equation_override = _equation_override + (_answer_diff < 0 ? " - " : " + ") + string(abs(_answer_diff))
		}
	}
	
	return {
		equation: is_undefined(_equation_override) 
			? string(_term1) + " " + _operation +  " " + string(_term2) 
			: _equation_override,
		answer: _answer
	}
}

// how many waves a newly unlocked math operation takes to become as common as the others
#macro OPERATION_EASE_IN_WAVES 4

function generate_answer(_max) {
	return irandom(_max - 1) + 1;
}

function math_determine_max_from_wave(_wave) {
	return global.starting_max_answer + (2 * _wave)
}

/**
 * @param {Real} _wave
 * @param {Real} [_max_multiplier] scales the max answer value, used to widen the range of options when answers collide
 */
function generate_equation_and_answer(_wave, _max_multiplier = 1) {
	var _max = math_determine_max_from_wave(_wave) * _max_multiplier
	var _unlocked_difficulty = floor(_wave / global.wave_difficulty_step)
	var _difficulty = min(global.max_math_difficulty, _unlocked_difficulty)

	// ease a newly unlocked operation in: it grows to equal footing with the others over OPERATION_EASE_IN_WAVES
	// waves, starting the wave it unlocks (with 4: 25%, 50%, 75%, then 100% as likely as each older operation)
	var _newest_operation_weight = 1
	if (_unlocked_difficulty > 0 && _unlocked_difficulty < array_length(global.operations_order)) {
		var _waves_since_unlock = _wave - (_unlocked_difficulty * global.wave_difficulty_step)
		_newest_operation_weight = min(1, (_waves_since_unlock + 1) / OPERATION_EASE_IN_WAVES)
	}

	var _answer = generate_answer(_max)
	return generate_equation(_answer, _max, _difficulty, _newest_operation_weight)
}

function get_max_word_length_from_wave(_wave) {
	return min(global.max_word_length, global.min_word_length + floor(_wave / global.wave_difficulty_step))
}

function generate_text_and_answer(_wave) {
	var _max_word_length = get_max_word_length_from_wave(_wave)
	var _text = select_word_of_length(irandom_range(global.min_word_length, _max_word_length))
	return {
		equation: _text,
		answer: _text
	}
}

function select_word_of_length(_length) {
	if (_length < global.min_word_length || _length > global.max_word_length) {
		throw "Invalid word length"
	}
	
	var _dictionary_name = string_concat("length", string(_length))
	
	var _dictionary = global.dictionaries[$ _dictionary_name]
	return _dictionary[irandom_range(0, array_length(_dictionary) - 1)]
}


function generate_sequence_from_wave(_wave) {
	var _keys = variable_struct_get_names(global.sequences)
	var _max_index = min(array_length(_keys) - 1, ceil(_wave / global.wave_difficulty_step)) // this basically identifies the most challenging sequence we'll give
	var _max_length = 5 + _max_index - 1
	
	var _selected_index = irandom(_max_index)
	var _selected_key = _keys[_selected_index]
	var _selected_sequence = global.sequences[$ _selected_key]
	
	return get_sequence_from_label_and_length(_selected_key, min(_max_length, array_length(_selected_sequence)))
}

function get_sequence_from_label_and_length(_key, _length) {
	var _selected_sequence = global.sequences[$ _key]
	var _final_sequence = array_copy_all(_selected_sequence)
	return {
		key: _key,
		label: string_replace(_key, "_", " "),
		sequence: _final_sequence
	}
}