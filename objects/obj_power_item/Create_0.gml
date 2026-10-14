/// @description Initialize settings
initialize_instance_has_equation(self)
my_bounds = get_bounds_for_instance(self)

radius = global.player_body_radius

// Build weighted selection for type
var _player = get_player()
var _missing_health = global.max_health - _player.my_health
var _shield = instance_find(obj_shield, 0)
var _shield_health = _shield == noone ? 0 : _shield.shield_health

// Calculate weights for each type
var _weights = {}
_weights[$ BONUS_ITEM_SHIELD] = 1 / power(2, _shield_health)
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

// placeholder label until proper sprite assets are made: the type's initials (e.g. "level-up" -> "LU")
var _words = string_split(type, "-")
label = ""
for (var _i = 0; _i < array_length(_words); _i++) {
	label += string_upper(string_char_at(_words[_i], 1))
}

function register_hit() {
	get_game_controller().release_answer(answer)
	debug(string_concat("ITEM \"", type, "\" HIT by ", last_hit_by_player_id))

	switch (type) {
		case BONUS_ITEM_SHIELD:
			// shields stack: a second shield item adds health to the existing shield
			var _shield = instance_find(obj_shield, 0)
			if (_shield != noone) {
				_shield.add_health(1)
			} else {
				instance_create_layer(global.xcenter, global.ycenter, LAYER_BG_EFFECTS, obj_shield)
			}
			break

		case BONUS_ITEM_TURRET:
			instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_stationary_turret, {owner_player_id: last_hit_by_player_id})
			break

		case BONUS_ITEM_HEALTH:
			// fly a health orb to the player, same as the leech ultimate
			instance_create_layer(x, y, LAYER_BG_EFFECTS, obj_orb_score_increase, {
				amount: global.health_item_amount,
				type: ORB_TYPE_HEALTH,
				owner_player_id: last_hit_by_player_id,
			})
			break

		case BONUS_ITEM_POINTS:
			instance_create_layer(x, y, LAYER_FG_EFFECTS, obj_orb_score_increase, {
				amount: 10 * get_current_wave_number(),
				type: ORB_TYPE_SCORE,
				owner_player_id: last_hit_by_player_id,
			})
			break

		case BONUS_ITEM_LEVEL_UP:
			// only the player who hit the item levels up
			var _game_controller = get_game_controller()
			_game_controller.increate_ult_level(last_hit_by_player_id)
			// an active ultimate drives its own charge meter (counting down), so only fill it when not ulting
			if (!_game_controller.is_ulting(last_hit_by_player_id)) {
				_game_controller.ultimate_charge[$ last_hit_by_player_id] = global.ultimate_requirement
			}
			break
	}

	instance_destroy()
}