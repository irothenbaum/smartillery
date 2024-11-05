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
#macro EVENT_UTLTIMATE_LEVEL_UP "ultimate-level-up"
#macro EVENT_ON_OFF_STREAK "on-streak"

#macro RESET_COLOR {c: c_white, o: 1}

#macro TAU (2 * pi)


// colors
global.bg_color = #260b26
global.power_color = c_aqua
global.combo_color = c_red
global.beam_color = c_white
global.ultimate_colors = {"none": c_white, "strike": #e03a3a, "slow": #3e7bed, "heal": #11d94e}
global.ultimate_color_tints = {"none": #eeeeee, "strike": #e0773a, "slow": #0ce7eb, "heal": #c0ed2b}

// in-game configurable
global.selected_ultimate = "none";
global.body_color = c_white;
global.turret_color = c_white;
global.is_math_mode = true
global.total_paused_time = 0
global.paused = false
global.game_seed = randomize()

global.focused_input = undefined

// seemingly magic numbers
global.heal_radius = 75
global.turret_length = 50
global.room_width = 1440
global.room_height = 1000
global.xcenter = global.room_width / 2
global.ycenter = global.room_height / 2

// gameplay
global.point_streak_requirement = 1 // 3
global.combo_delay_ms = 1600
global.minimum_combo = 2
global.combo_phrases = ["Double strike", "Triple strike", "Quadruple clap", "Monster stop", "Feral firepower!", "Menace!!", "Untouchable!!!", "Impossible!!!!"]
global.ultimate_requirement = 6
global.ultimate_code = "000"
global.max_health = 100
global.starting_max_answer = 10
global.wave_difficulty_step = 5;
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)
global.min_word_length = 4
global.max_word_length = 11

// effects
global.fade_speed = 0.1
global.scene_transition_duration = 2
global.bg_number_of_circles = 20
global.bg_circle_max_radius = ceil(sqrt(power(global.room_width, 2) + power(global.room_height, 2)) / 2)
global.bg_cicle_min_radius = global.turret_length
global.bg_circle_magnitude = global.bg_circle_max_radius - global.bg_cicle_min_radius
global.bg_circle_ring_width = global.bg_circle_magnitude / global.bg_number_of_circles

// copy
global.ultimate_descriptions = {
	ULTIMATE_STRIKE: {title: "Air strike", description: "Launch a barrage from the air that targets and eliminates your most dangerous enemies"},
	ULTIMATE_SLOW: {title: "Time slow", description: "Reduce the approach and attack speed of enemies nearing your position"},
	ULTIMATE_HEAL: {title: "Regenerate", description: "Repair damage to your ship so you can stay in the fight longer"}
}