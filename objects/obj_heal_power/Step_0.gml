// player.my_health = min(global.max_health, player.my_health + heal_rate)
var _gc = get_game_controller()
_gc.ultimate_charge = max(0, global.ultimate_requirement * alarm[0] / starting_duration)

ultimate_step(self)