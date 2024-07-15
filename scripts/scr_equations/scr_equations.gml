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

function generate_equation(_answer, _max, _difficulty = 0) {
	_difficulty = min(_difficulty, array_length(global.operations_order) - 1)
	var _dice = undefined
	var _allowed_operations = get_allowed_operations_for_answer(_answer, _max)
	
	debug("Generating equation for values a: " + string(_answer) + " m: " + string(_max) + " d: " + string(_difficulty))
	
	var _breaker = 10;
	do {
		 _breaker --
		 if (_breaker == 0) {
			throw "Cannot create equation with a: " + string(_answer) + " m: " + string(_max) + " d: " + string(_difficulty)
		}
		
		_dice = irandom(_difficulty)
	} until (_allowed_operations[_dice])
	
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

function generate_answer(_max) {
	return irandom(_max);
}

function generate_equation_and_answer(_max, _difficulty) {
	_answer = generate_answer(_max)
	return generate_equation(_answer, _max, _difficulty)
}