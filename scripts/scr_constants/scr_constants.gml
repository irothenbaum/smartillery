#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"

global.bg_color = #150c1f
global.heal_color_tint = #02f6fa
global.heal_color = #02fa4d;
global.power_color = c_aqua
global.ultimate_color = c_red;
global.beam_color = c_white

global.heal_radius = 75
global.fade_speed = 0.1
global.max_health = 100
global.min_answer = 10
global.ultimate_requirement = 10
global.heal_requirement = 20
global.scene_transition_duration = 6
global.body_color = c_ltgrey;
global.turret_color = c_ltgrey;
global.wave_difficulty_step = 4;
global.point_streak_requirement = 5
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)
global.is_math_mode = true
global.min_word_length = 4
global.max_word_length = 11
global.total_paused_time = 0
global.paused = false