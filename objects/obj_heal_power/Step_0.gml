player.my_health = min(global.max_health, player.my_health + heal_rate)
var _gc = get_game_controller()
_gc.ultimate_charge = lerp(_gc.ultimate_charge, global.ultimate_requirement * alarm[0] / starting_duration, global.fade_speed)