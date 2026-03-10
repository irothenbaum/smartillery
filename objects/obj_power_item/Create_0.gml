/// @description Initialize settings
initialize_instance_has_equation(self)

radius = global.player_body_radius

// Build weighted selection for type
var _player = get_player()
var _missing_health = global.max_health - _player.my_health
var _shield_count = instance_number(obj_shield)

// Calculate weights for each type
var _weights = {}
_weights[$ BONUS_ITEM_SHIELD] = 1 / power(2, _shield_count)
_weights[$ BONUS_ITEM_LEVEL_UP] = 1
_weights[$ BONUS_ITEM_HEALTH] = (_missing_health > 0) ? power(2, floor(_missing_health / 20)) : 1
_weights[$ BONUS_ITEM_POINTS] = 1
_weights[$ BONUS_ITEM_TURRET] = 1

// Sum total weight and pick random value
var _types = struct_get_names(_weights)
var _total_weight = 0
for (var _i = 0; _i < array_length(_types); _i++) {
	_total_weight += _weights[$ _types[_i]]
}

var _roll = random(_total_weight)
var _cumulative = 0
type = _types[0]

for (var _i = 0; _i < array_length(_types); _i++) {
	_cumulative += _weights[$ _types[_i]]
	if (_roll < _cumulative) {
		type = _types[_i]
		break
	}
}

function register_hit() {
	debug(string_concat("ITEM HIT by ", last_hit_by_player_id))
}