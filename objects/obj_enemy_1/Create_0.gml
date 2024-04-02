spawn_time = current_time
point_value = 10
speed = 1;
equation = "";

function register_hit(_answer) {
	// TODO: show explosion, particles, etc
	instance_destroy();
	
	get_enemy_controller().handle_enemy_killed(self)
}

function initialize_new_equation() {
	var _values = generate_equation_and_answer()
	get_enemy_controller().reserve_answer(_values.answer, self)
	equation = _values.equation
}


function initalize() {
	_attempts = 10;
	do {
		try {
			_attempts--;
			initialize_new_equation();
		} catch (_err) {
			debug(_err)
			if (_err != "Answer in use") {
				throw _err
			}
		}
	} until (equation != "" || _attempts <= 0)
	
	if (equation == "") {
		instance_destroy();
		debug("Could not create equation");
	}
}

initalize();

