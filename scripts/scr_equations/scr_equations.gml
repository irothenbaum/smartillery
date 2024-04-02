function generate_equation(_answer, _max) {
	// only allow division if the answer is less than one fourth of _max
	var _dice = irandom(_answer < _max * 0.25 ? 3 : 2)
	var _term1 = 0;
	var _term2 = 0;
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
	}
	
	return {
		equation: string(_term1)+ " " + _operation + " " + string(_term2) + " = " + string(_answer),
		answer: _answer
	}
}

function generate_answer(_max) {
	return irandom(_max);
}

function generate_equation_and_answer() {
	_answer = generate_answer(MAX_ANSWER_VALUE)
	return generate_equation(_answer, MAX_ANSWER_VALUE)
}