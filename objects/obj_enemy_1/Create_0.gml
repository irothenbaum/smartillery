spawn_time = current_time
point_value = 10
speed = 2;
equation = "";

function register_hit(_answer) {
	// TODO: show explosion, particles, etc
	instance_destroy();
	
	get_enemy_controller().handle_enemy_killed(self)
}

function generate_equation() {
	get_enemy_controller().reserve_answer(11, self)
	equation = "3 + 8"
}


function initalize() {
	_attempts = 10;
	do {
		try {
			_attempts--;
			generate_equation();
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

