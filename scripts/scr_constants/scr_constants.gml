// constants
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"

#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"

#macro ULTIMATE_NONE "none"
#macro ULTIMATE_STRIKE "strike"
#macro ULTIMATE_SLOW "slow"
#macro ULTIMATE_HEAL "heal"

#macro EVENT_ENEMY_DAMAGED "enemy-damaged"
#macro EVENT_ENEMY_KILLED "enemy-killed"
#macro EVENT_TOGGLE_PAUSE "toggle-pause"
#macro EVENT_WRONG_GUESS "wrong-guess"

#macro TAU (2 * pi)


// colors
global.bg_color = #260b26
global.power_color = c_aqua
global.beam_color = c_white
global.ultimate_colors = {"none": c_white, "strike": #ffaaaa, "slow": c_blue, "heal": #02fa4d}
global.ultimate_color_tints = {"none": #eeeeee, "strike": #ffccaa, "slow": c_blue, "heal": #02f6fa}

// in-game configurable
global.selected_ultimate = "none";
global.body_color = c_ltgrey;
global.turret_color = c_ltgrey;
global.is_math_mode = true
global.total_paused_time = 0
global.paused = false

// seemingly magic numbers
global.heal_radius = 75
global.turret_length = 50
global.room_width = 1440
global.room_height = 1000
global.x_center = global.room_width / 2
global.y_center = global.room_height / 2

// gameplay
global.point_streak_requirement = 3
global.ultimate_requirement = 10
global.ultimate_code = "000"
global.max_health = 100
global.min_answer = 10
global.wave_difficulty_step = 4;
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)
global.min_word_length = 4
global.max_word_length = 11

// effects
global.fade_speed = 0.1
global.scene_transition_duration = 6
global.bg_number_of_circles = 20
global.bg_circle_max_radius = ceil(sqrt(power(global.room_width, 2) + power(global.room_height, 2)) / 2)
global.bg_cicle_min_radius = global.turret_length
global.bg_circle_magnitude = global.bg_circle_max_radius - global.bg_cicle_min_radius