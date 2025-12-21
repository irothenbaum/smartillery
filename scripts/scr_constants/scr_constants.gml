// constants
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"
#macro LAYER_BG_EFFECTS "BG_Effects"
#macro LAYER_FG_EFFECTS "FG_Effects"

#macro ALIGN_CENTER "center"
#macro ALIGN_LEFT "left"
#macro ALIGN_RIGHT "right"

#macro ULTIMATE_NONE "none"
#macro ULTIMATE_STRIKE "strike"
#macro ULTIMATE_SLOW "slow"
#macro ULTIMATE_HEAL "heal"
#macro ULTIMATE_ASSIST "assist"
#macro ULTIMATE_COLLATERAL "collateral"
#macro ULTIMATE_TURRET "turret"

#macro ORB_TYPE_SCORE "score"
#macro ORB_TYPE_ULT "ult"
#macro ORB_TYPE_HEALTH "health"
#macro ORB_TYPE_COMBO "combo"

#macro BONUS_TYPE_ITEM "item"
#macro BONUS_TYPE_ULT "ult"



#macro TAU (2 * pi)


// colors
global.bg_color = #260b26
global.combo_color = #ff0000
global.beam_color = c_white
global.near_white = #c7c7c7

global.ultimate_colors = {
	ULTIMATE_NONE: c_white, 
	ULTIMATE_STRIKE: #e03a3a, 
	ULTIMATE_SLOW: #4ccdfc, 
	ULTIMATE_HEAL: #11d94e,
	ULTIMATE_TURRET: #11d94e,  // TODO:
	ULTIMATE_ASSIST: #a711d9,
	ULTIMATE_COLLATERAL: #f5fc90,
}
// TODO: Revisit these
global.ultimate_color_tints = {
	ULTIMATE_NONE: #eeeeee, 
	ULTIMATE_STRIKE: #e0773a, 
	ULTIMATE_SLOW: #0ce7eb, 
	ULTIMATE_HEAL: #c0ed2b,
	ULTIMATE_TURRET: #c0ed2b,  // TODO:
	ULTIMATE_ASSIST: #a711d9,
	ULTIMATE_COLLATERAL: #f5fc90,
}
global.ultimate_icons = {
	ULTIMATE_STRIKE: spr_ult_strike,
	ULTIMATE_SLOW: spr_ult_slow,
	ULTIMATE_HEAL: spr_ult_heal,
	ULTIMATE_TURRET: spr_ult_heal, // TODO:
	ULTIMATE_ASSIST: spr_ult_heal, // TODO:
	ULTIMATE_COLLATERAL: spr_ult_heal, // TODO:
}

// in-game configurable
global.selected_ultimate = {};
global.body_color = c_white;
global.turret_color = c_white;
global.is_math_mode = true
global.total_paused_time = 0
global.paused = false
global.game_seed = randomize()
global.starting_wave = 0

// multiplayer stuff
global.lobby_id = undefined
global.is_solo = false
global.is_coop = false
global.is_training = false
global.focused_input = undefined
global.max_players = 4

// seemingly magic numbers
global.turret_length = 53
global.player_body_radius = 26 // player sprite_width * image_scale / 2 =  (326 * 0.16 / 2)
global.room_width = 1440
global.room_height = 1000
global.xcenter = global.room_width / 2
global.ycenter = global.room_height / 2
global.beam_width = 12
global.beam_width_lg = 16
global.beam_width_sm = 8

// layout
global.margin_xs = 8
global.margin_sm = 12
global.margin_md = 20
global.margin_lg = 32
global.margin_xl = 60
 
// these match the font settings
global.font_size_sm = 8
global.font_size_md = 12
global.font_size_lg = 16
global.font_size_xl = 24

// gameplay
global.point_streak_requirement = 3
global.combo_delay_ms = 1200
global.minimum_combo = 2
global.combo_phrases = ["Double strike", "Triple strike", "Quadruple clap", "Monster stop", "Feral firepower!", "Menace!!", "Untouchable!!!", "Impossible!!!!"]
global.ultimate_requirement = 40 // how many seconds until your charge is ready
global.ultimate_code = "000"
global.max_health = 100
global.starting_max_answer = 10
global.wave_difficulty_step = 5;
global.operations_order = ["+", "-", "x", "/", "^", "^"]
global.max_math_difficulty = array_length(global.operations_order)
global.min_word_length = 4
global.max_word_length = 11
global.directional_hint_bounds = new Bounds(
	40,
	40,
	global.room_width - 40,
	global.room_height - 40
)

// enemy damage & points
global.damage_enemy_1_collision = 30
global.damage_enemy_2_shot = 20
global.damage_enemy_3_collision = 40
global.damage_enemy_4_collision = 50
global.damage_enemy_4_fragment_collision = 15
global.damage_enemy_5_collision = 40

global.points_map = ds_map_create()
ds_map_add(global.points_map, obj_enemy_1, 10)
ds_map_add(global.points_map, obj_enemy_2, 20)
ds_map_add(global.points_map, obj_enemy_3, 30)
ds_map_add(global.points_map, obj_enemy_4, 20)
ds_map_add(global.points_map, obj_enemy_4_fragment, 10)

// the higher this number is, the easier the equations are
global.enemy_difficulty_multiplier = ds_map_create()
ds_map_add(global.enemy_difficulty_multiplier, obj_enemy_1, 1)
ds_map_add(global.enemy_difficulty_multiplier, obj_enemy_2, 3)
ds_map_add(global.enemy_difficulty_multiplier, obj_enemy_3, 6)
ds_map_add(global.enemy_difficulty_multiplier, obj_enemy_4, 2)
ds_map_add(global.enemy_difficulty_multiplier, obj_enemy_4_fragment, 1)

// effects
global.fade_speed = 0.1
global.scene_transition_duration = 2
global.bg_number_of_circles = 24
global.bg_circle_max_radius = ceil(sqrt(power(global.room_width, 2) + power(global.room_height, 2)) / 2)
global.bg_cicle_min_radius = global.turret_length
global.bg_circle_magnitude = global.bg_circle_max_radius - global.bg_cicle_min_radius
global.bg_circle_ring_width = global.bg_circle_magnitude / global.bg_number_of_circles


// this is a dynamic global variable lookup
global._G = {}

// copy
global.ultimate_descriptions = {
	ULTIMATE_STRIKE: {title: "Air strike", description: "Launch a barrage from the air that targets and eliminates your most dangerous enemies"},
	ULTIMATE_SLOW: {title: "Time slow", description: "Reduce the approach and attack speed of enemies nearing your position"},
	ULTIMATE_HEAL: {title: "Leech", description: "Destroying enemies repairs damage to your ship so you can stay in the fight longer"},
	ULTIMATE_COLLATERAL: {title: "Collateral Damage", description: "Destroying an enemy will also explode nearby foes"},
	ULTIMATE_ASSIST: {title: "Aim Assist", description: "Near misses will magically turn into direct strikes on target"},
	ULTIMATE_TURRET: {title: "Turrets", description: "Spawn turrets to bolster your attack"},
}
