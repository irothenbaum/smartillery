#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"
#macro ULTIMATE_NONE "none"
#macro ULTIMATE_STRIKE "strike"
#macro ULTIMATE_SLOW "slow"
#macro ULTIMATE_HEAL "heal"

global.bg_color = #150c1f
global.power_color = c_aqua
global.selected_ultimate = "none";
global.beam_color = c_white

global.ultimate_colors = {"none": c_white, "strike": #ffaaaa, "slow": c_blue, "heal": #02fa4d}
global.ultimate_color_tints = {"none": #eeeeee, "strike": #ffccaa, "slow": c_blue, "heal": #02f6fa}
global.heal_radius = 75
global.fade_speed = 0.1
global.max_health = 100
global.min_answer = 10
global.ultimate_requirement = 10
global.ultimate_code = "000"
global.scene_transition_duration = 6
global.body_color = c_ltgrey;
global.turret_color = c_ltgrey;
global.wave_difficulty_step = 4;
global.point_streak_requirement = 3
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)
global.is_math_mode = true
global.min_word_length = 4
global.max_word_length = 11

global.total_paused_time = 0
global.paused = false
