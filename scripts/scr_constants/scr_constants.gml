#macro TIME_BONUS_PERIOD 10 // 10 seconds to score a time bonus
#macro BASE_ANSWER_VALUE 20
#macro MESSAGE_SHOW_DURATION 4
#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"

global.max_health = 100
global.ultimate_requirement = 30
global.total_paused_time = 0
global.paused = false
global.scene_transition_duration = 6
global.body_color = color_to_array(c_white);
global.turret_color = color_to_array(c_white);

#macro LAUNCH_CODE "000"
#macro POINT_STREAK_REQUIREMENT 5


#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"

global.operations_order = ["+", "-", "x", "/", "^", "^"]
#macro MAX_MATH_DIFFICULTY 5

#macro WAVE_DIFFICULTY_STEP 5