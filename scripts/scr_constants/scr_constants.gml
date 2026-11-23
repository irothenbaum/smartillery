// constants
#macro LAYER_INSTANCES "Instances"
#macro LAYER_CONTROLLERS "Controllers"
#macro LAYER_HUD "HUD"
#macro LAYER_BG_EFFECTS "BG_Effects"
#macro LAYER_FG_EFFECTS "FG_Effects"
// the shield ring (and its fly-in pickup) sits between the Background (500) and BG_Effects (400) layers, so beams,
// turrets, enemies and every other effect draw over it
#macro DEPTH_SHIELD 450

// main menu background scene: the camera shows this fraction of the world, so the player (world center) sits in
// the top-right of the screen and the menu fits in the lower-left
#macro MENU_ZOOM 0.6
// in room px: how far the menu player is from the top and right edges of the view, which is also the radius
// inside which it shoots enemies right away. The same value so the player can always see the threats it reacts to
#macro MENU_PLAYER_MARGIN 190

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
#macro ULTIMATE_RINGS "rings"

#macro ORB_TYPE_SCORE "score"
#macro ORB_TYPE_ULT "ult"
#macro ORB_TYPE_HEALTH "health"
#macro ORB_TYPE_COMBO "combo"

#macro TAU (2 * pi)

#macro TYPING_WORLD_COLOR #85c418
#macro TYPING_BACKGROUND_COLOR #111a03
#macro MATH_WORLD_COLOR #c418c4
#macro MATH_BACKGROUND_COLOR #1a031a

// colors
// both follow the game mode -- set_game_mode switches them between the MATH_ and TYPING_ colors
global.bg_color = MATH_BACKGROUND_COLOR
global.world_color = MATH_WORLD_COLOR
// enemies turn this color once they commit to attacking (enemy 1's final approach, enemy 2 in firing position)
global.enemy_attack_color = #ff0000
global.beam_color = c_white

global.ultimate_colors = {
	ULTIMATE_NONE: c_white, 
	ULTIMATE_STRIKE: #eb1e1e, 
	ULTIMATE_SLOW: #1e69eb, 
	ULTIMATE_HEAL: #1eeb2c,
	ULTIMATE_TURRET: #eba31e,
	ULTIMATE_ASSIST: #9131eb,
	ULTIMATE_COLLATERAL: #1eebe0,
	ULTIMATE_RINGS: #f01ff0,
}

global.ultimate_color_tints = {
	ULTIMATE_NONE: #eeeeee, 
	ULTIMATE_STRIKE: #e64d32, 
	ULTIMATE_SLOW: #4baee3, 
	ULTIMATE_HEAL: #4cd98e,
	ULTIMATE_TURRET: #ebd059,
	ULTIMATE_ASSIST: #ae71f5,
	ULTIMATE_COLLATERAL: #f5f569,
	ULTIMATE_RINGS: #ed6dcf,
}
global.ultimate_icons = {
	ULTIMATE_STRIKE: spr_ult_strike,
	ULTIMATE_SLOW: spr_ult_slow,
	ULTIMATE_HEAL: spr_ult_heal,
	ULTIMATE_TURRET: spr_ult_turret,
	ULTIMATE_ASSIST: spr_ult_assist,
	ULTIMATE_COLLATERAL: spr_ult_collateral,
	ULTIMATE_RINGS: spr_ult_rings
}

// Optional per-ultimate preview clip for the select-ultimate screen (obj_select_ultimate).
// Each entry is a Sprite asset imported from a recorded clip -- see
// notes/GeneratingUltCardVideos for how to produce one. An ultimate with no entry
// here just shows the placeholder box.
// TODO: every entry below except ULTIMATE_STRIKE is a placeholder reusing the Strike
// clip so all cards have *some* preview while the rest are still being recorded --
// swap each one for its own sprite as clips come in (see notes/GeneratingUltCardVideos)
global.ultimate_preview_sprites = {
	ULTIMATE_STRIKE: spr_video_preview_strike,
	ULTIMATE_SLOW: spr_video_preview_strike,
	ULTIMATE_HEAL: spr_video_preview_strike,
	ULTIMATE_TURRET: spr_video_preview_strike,
	ULTIMATE_ASSIST: spr_video_preview_strike,
	ULTIMATE_COLLATERAL: spr_video_preview_strike,
	ULTIMATE_RINGS: spr_video_preview_strike,
}

global.skip_ult_overlay = false

// in-game configurable
global.selected_ultimate = {};
global.body_color = c_white;
global.turret_color = c_white;
global.is_math_mode = true
global.play_time_ms = 0
global.paused = false
global.game_seed = randomize()
global.game_seed_text = string(global.game_seed) // what the menu's Seed box shows (see set_game_seed)
global.starting_wave = 0 // 0 is default
global.game_start_delay = 3 // in seconds after a play room starts before the first wave (and its banner) begins

// multiplayer stuff
global.active_player_ids = []   // ordered slot list, populated before entering any game room
global.player_device_map = {}   // player_id -> device_index (-1 = keyboard, 0+ = gamepad)
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
global.oob_margin = 30

// layout
global.margin_xs = 8
global.margin_sm = 12
global.margin_md = 20
global.margin_lg = 32
global.margin_xl = 60
global.margin_xxl = 100
 
// these match the font settings
global.font_size_sm = 8
global.font_size_md = 12
global.font_size_lg = 16
global.font_size_xl = 24

// gameplay
global.point_streak_requirement = 3
global.combo_delay_ms = 1200
global.minimum_combo = 2
global.combo_bonus_multiplier = 3 // a combo orb is worth the combo count times this (added to score and ultimate progress)
// we keep combo 1 even though it's not used because we want array_length to = longest combo count
global.combo_phrases = ["N/A", "Double tap", "Hat trick", "Connect four", "Cinco de Mayhem"]
global.ultimate_requirement = 30 // how many seconds until your charge is ready
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
global.damage_enemy_5_missile_collision = 40

// when the player takes damage, a burst clears all enemies within this many rings of the player
// keep this below enemy 2's firing ring (5, see obj_enemy_2 fire_distance) so the burst doesn't reach parked shooters
global.damage_burst_ring_count = 4

// power items
global.shield_ring_from_center = 3 // which ring (counting out from the player) the shield sits on
global.ult_ring_from_center = global.shield_ring_from_center - 1 // active ultimates are shown on the ring just inside the shield's
global.bonus_item_orbit_ring_from_center = 8 // power items and extra ultimates orbit the player on this ring
global.bonus_item_orbit_period = 12 // in seconds, for one full orbit
global.bonus_item_wiggle_amplitude = 1 // radial wiggle, as a fraction of the ring's width (under 0.5 keeps items inside their ring)
global.bonus_item_wiggle_period_min = 0.8 // in seconds: each item picks its own wiggle period in this range,
global.bonus_item_wiggle_period_max = 2.2 // so the formation never settles into a regular shape
global.recent_answer_grace_period = 1 // in seconds: a guess matching an answer someone just got right isn't penalized
global.shield_color = #2f7bff
// shine (see shader_set_shine): every shine_interval seconds of game time a thin white band sweeps across the room,
// lighting up anything drawn as "shiny" as it passes. One shared band, so it reads as one light crossing the screen
global.shine_enabled = true // false turns every shine off (shiny things draw normally)
global.shine_interval = 4 // in seconds between sweeps
global.shine_sweep_duration = 1 // in seconds for the band to cross the whole room
global.shine_width = 90 // px -- on something shine_reference_size across; scaled for anything that passes its size (see shader_set_shine)
global.shine_angle = 130 // in degrees (GameMaker angles, counter-clockwise): the direction the band travels -- up-left here
global.stationary_turret_range = 300 // px
global.stationary_turret_body_scale = 0.1 // of spr_player_body -- shared by the turret and its power item, which looks like its body
global.stationary_turret_fire_interval = 1 // seconds between shots
global.stationary_turret_lifetime_refund = 0.1 // fraction of its total lifetime a stationary turret regains per kill
global.stationary_turret_duration = 20 // seconds before the turret disappears
global.health_item_amount = 25

global.points_map = ds_map_create()
ds_map_add(global.points_map, obj_enemy_1, 10)
ds_map_add(global.points_map, obj_enemy_2, 20)
ds_map_add(global.points_map, obj_enemy_3, 30)
ds_map_add(global.points_map, obj_enemy_4, 20)
ds_map_add(global.points_map, obj_enemy_4_fragment, 10)
ds_map_add(global.points_map, obj_enemy_5, 30)
ds_map_add(global.points_map, obj_enemy_5_missile, 5)

// the higher this number is, the easier the equations are
global.targetable_difficulty_multiplier = ds_map_create()
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_1, 1)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_2, 3)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_3, 5)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_4, 2)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_4_fragment, 1)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_5, 2)
ds_map_add(global.targetable_difficulty_multiplier, obj_enemy_5_missile, 5)
ds_map_add(global.targetable_difficulty_multiplier, obj_training_target, 1)
// every power item type shares the same difficulty
global.power_item_objects = [obj_power_item_shield, obj_power_item_turret, obj_power_item_health, obj_power_item_points, obj_power_item_level_up]
for (var _i = 0; _i < array_length(global.power_item_objects); _i++) {
	ds_map_add(global.targetable_difficulty_multiplier, global.power_item_objects[_i], 4)
}
ds_map_add(global.targetable_difficulty_multiplier, obj_extra_ultimate, 2)


// effects
// the shared base timing for every fade in the game: a fade is 99% of the way to its target after this many seconds
global.fade_seconds = 0.7
// fades are done as `value = lerp(value, target, global.fade_speed)` once per frame, so this is the per-frame step
// that lands at 99% after global.fade_seconds -- derived from the frame rate so fades take the same time at any fps
global.fade_speed = 1 - power(0.01, 1 / (global.fade_seconds * game_get_speed(gamespeed_fps)))
global.scene_transition_duration = 2
global.bg_number_of_circles = 24
global.bg_circle_max_radius = ceil(sqrt(power(global.room_width, 2) + power(global.room_height, 2)) / 2)
global.bg_cicle_min_radius = global.turret_length
global.bg_circle_magnitude = global.bg_circle_max_radius - global.bg_cicle_min_radius
global.bg_circle_ring_width = global.bg_circle_magnitude / global.bg_number_of_circles
// the shine band is global.shine_width on something this many px across (see shader_set_shine): the shield's outer
// diameter, since that's what the width was tuned on. Same math as get_shield_geometry / get_radius_for_ring
global.shine_reference_size = 2 * (global.bg_circle_max_radius - ((global.bg_number_of_circles - global.shield_ring_from_center) / global.bg_number_of_circles) * global.bg_circle_magnitude)


// this is a dynamic global variable lookup
global._G = {}

// copy
global.ultimate_descriptions = {
	ULTIMATE_STRIKE: {title: "Air strike", description: "Launch a barrage from the air that targets and eliminates your most dangerous enemies"},
	ULTIMATE_SLOW: {title: "Time slow", description: "Reduce the approach and attack speed of enemies nearing your position"},
	ULTIMATE_HEAL: {title: "Leech", description: "Destroying enemies repairs damage to your ship so you can stay in the fight longer"},
	ULTIMATE_COLLATERAL: {title: "Collateral", description: "Destroying an enemy will also explode nearby foes"},
	ULTIMATE_ASSIST: {title: "Aim assist", description: "Near misses will magically turn into direct strikes on target"},
	ULTIMATE_TURRET: {title: "Turrets", description: "Spawn turrets to bolster your attack"},
	ULTIMATE_RINGS:  {title: "Rings", description: "Extend your strike around"},
}

global.tip_copy_map = ds_map_create()
ds_map_add(global.tip_copy_map, obj_enemy_1, {title: "Striker", description: "It may look simple, but don't blink- this little guy changes course rapidly and strikes with lethal effect."})	
ds_map_add(global.tip_copy_map, obj_enemy_2, {title: "Tank", description: "Slow moving, armored, and sporting a powerful main gun. Destroy it before it can set up a firing position or you'll pay the price."})	
ds_map_add(global.tip_copy_map, obj_enemy_3, {title: "Ram", description: "Reaching speeds over 100 kmh with a heavily armored front hull, this battering ram slams into its target with desctructive power."})	
ds_map_add(global.tip_copy_map, obj_enemy_4, {title: "Frag", description: "You may think you've won, but when this hostile is destroyed it fragments into 3 highly explosive missiles that continue the attack."})
ds_map_add(global.tip_copy_map, obj_enemy_4_fragment, {title: "Shard", description: "An explosive shard of a Frag enemy. It dips and weaves its way into an attack trajectory aimed directly at you."})
ds_map_add(global.tip_copy_map, obj_enemy_5, {title: "Silo", description: "Carrying an endless supply of honing missiles, this hostile can appear out of nowhere, but patience and persistence will win you the day."})	
ds_map_add(global.tip_copy_map, obj_enemy_5_missile, {title: "Missile", description: "Launched from a mobile silo, this missile never misses its target. You'll need to be fast and accurate to survive."})	
ds_map_add(global.tip_copy_map, obj_training_target, {title: "Dummy Target", description: "Take your time and hone your skills."})	
ds_map_add(global.tip_copy_map, obj_extra_ultimate, function(_instance) {
	var _ult_desc = global.ultimate_descriptions[$ _instance.type]
	var _ultimate_level = get_game_controller().ultimate_level
	var _player_ids = get_player_ids()

	// a bonus ultimate fires at the level of whoever activates it, so show the stats at your current level.
	// In co-op, players at different levels each get their own section
	var _all_same_level = true
	for (var _i = 1; _i < array_length(_player_ids); _i++) {
		if (_ultimate_level[$ _player_ids[_i]] != _ultimate_level[$ _player_ids[0]]) {
			_all_same_level = false
			break
		}
	}

	var _sections = []
	for (var _i = 0; _i < (_all_same_level ? 1 : array_length(_player_ids)); _i++) {
		var _level = _ultimate_level[$ _player_ids[_i]]
		var _header = _all_same_level
			? string_concat("Level: ", _level)
			: string_concat("Player ", get_player_number(_player_ids[_i]) + 1, " (Level: ", _level, ")")
		array_push(_sections, string_concat(_header, "\n", get_ultimate_stats(_instance.type, _level)))
	}

	return {
		title: string_concat("Bonus Ultimate: ", _ult_desc.title),
		description: string_concat(_ult_desc.description, "\n\n", string_join_ext("\n\n", _sections))
	}
})	
ds_map_add(global.tip_copy_map, obj_power_item_shield, {title: "Power Item: Shield", description: "Raises a shield around you that blocks one enemy or shot. Stacks with other shields."})
ds_map_add(global.tip_copy_map, obj_power_item_turret, {title: "Power Item: Stationary Turret", description: "Deploys a turret right here that fires at enemies within its range."})
ds_map_add(global.tip_copy_map, obj_power_item_health, {title: "Power Item: Repair", description: string_concat("Restores ", global.health_item_amount, " health.")})
ds_map_add(global.tip_copy_map, obj_power_item_points, {title: "Power Item: Bonus Points", description: "Grants 10 points for every wave you've reached."})
ds_map_add(global.tip_copy_map, obj_power_item_level_up, {title: "Power Item: Level Up", description: "Levels up your ultimate and fully charges it."})
ds_map_add(global.tip_copy_map, obj_shield, {title: "Defensive Shield", description: "A last resort to protect yourself if an enemy makes it past your gun."})
ds_map_add(global.tip_copy_map, obj_stationary_turret, {title: "Stationary Turret", description: "A temporary turret spawns to help defend against the horde."})
ds_map_add(global.tip_copy_map, obj_hud_ultimate_icon, function(_instance) {
	var _level = get_game_controller().ultimate_level[$ _instance.owner_player_id]
	var _this_level_stats = get_ultimate_stats(_instance.selected_ultimate, _level)
	var _next_level_stats = get_ultimate_stats(_instance.selected_ultimate, _level + 1)
	return {
		title: string_concat(_instance.selected_ultimate, " (Level ", string(_level), ")"),
		description: string_concat("This Level:\n",_this_level_stats,"\n\nNext Level:\n", _next_level_stats),
	}
})
ds_map_add(global.tip_copy_map, obj_input, function(_instance) {
	var _is_on_streak = get_game_controller().has_point_streak(_instance.owner_player_id)
	var _activate_ult_copy = (_instance.device_index >= 0)
		? "Press Y (or Triangle) to activate your ultimate."
		: string_concat("Typing \"", global.ultimate_code, "\" will activate your ultimate.")

	return {
		title: "Answer input",
		description: string_concat("Enter your answers here.\n", _activate_ult_copy, _is_on_streak ? "\nYou are currently on streak! Getting kills levels up your ultimate" : "\nAnswer correctly ", global.point_streak_requirement," times in a row to get on strewak."),
	}
})

global.show_debug = false
show_debug_message("BOOT 1: scr_constants globals initialized"); var _boot_f = file_text_open_append("boot_log.txt"); file_text_write_string(_boot_f, "BOOT 1: scr_constants globals initialized"); file_text_writeln(_boot_f); file_text_close(_boot_f) // BOOT-DEBUG
