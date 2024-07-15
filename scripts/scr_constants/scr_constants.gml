#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"



global.max_health = 100
global.ultimate_requirement = 30
global.scene_transition_duration = 6
global.body_color = c_ltgrey;
global.turret_color = c_ltgrey;
global.wave_difficulty_step = 4;
global.launch_code = "000"
global.point_streak_requirement = 5
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)

global.total_paused_time = 0
global.paused = false