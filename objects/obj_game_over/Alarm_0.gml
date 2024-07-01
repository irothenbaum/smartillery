// explode on game over alarm
var _player = get_player()
var _scatter_size = 40

var _occurences = explosion_count == 0 ? 5 : (explosion_count > 0 ? 1 : 0)

for (; _occurences > 0; _occurences--) {
	instance_create_layer(_player.x + irandom_range(-_scatter_size, _scatter_size), _player.y + irandom_range(-_scatter_size, _scatter_size), LAYER_INSTANCES, obj_particle_effect, {effect: function(_x, _y) {draw_particle_sparks(_x, _y, 8)}})
	instance_create_layer(_player.x + irandom_range(-_scatter_size, _scatter_size), _player.y + irandom_range(-_scatter_size, _scatter_size), LAYER_INSTANCES, obj_particle_effect, {effect: draw_particle_shockwave})
}


if (explosion_count > 0) {
	alarm[0] = 0.3 * game_get_speed(gamespeed_fps)
} else {
	_player.hide_self = true
	alarm[1] = 1 * game_get_speed(gamespeed_fps)
}

explosion_count--;