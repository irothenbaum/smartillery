/// @description Main menu version of obj_player
// Looks like obj_player, but has no health, game controller, or input: it auto-fires at obj_menu_enemy_1 every
// shot_interval seconds, or right away when one comes inside threat_radius.
_u_color = shader_get_uniform(sh_hue_shift, "u_vColor")
body_color_arr = color_to_array(global.body_color)
turret_color_arr = color_to_array(global.turret_color)

recoil_amount = 0
max_recoil_amount = 20

rotate_aim_speed = 720 // in degrees per second
rotate_idle_speed = 90 // in degrees per second
rotate_speed = rotate_idle_speed
rotate_to = 90
direction = 90 // point upwards - the default and starting position
image_angle = rotate_to

x = global.xcenter
y = global.ycenter

image_scale = 0.16
image_xscale = image_scale
image_yscale = image_scale

target = noone
shot_interval = 2 // in seconds between unprovoked shots
shot_interval_jitter = 0.6 // in seconds, +/- so the rhythm doesn't feel mechanical
shot_timer = shot_interval // in seconds until the next unprovoked shot
// enemies inside this get shot right away. Matches the player's distance from the top/right of the view
threat_radius = MENU_PLAYER_MARGIN
idle_delay = 3 // in seconds with no target before the turret eases back to vertical
idle_timer = 0

/**
 * @param {Id.Instance} _inst
 * @returns {Bool} whether _inst is inside the (zoomed) menu camera
 */
function is_on_screen(_inst) {
	var _cam = view_camera[0]
	var _x0 = camera_get_view_x(_cam)
	var _y0 = camera_get_view_y(_cam)
	return _inst.x > _x0 && _inst.x < _x0 + camera_get_view_width(_cam)
		&& _inst.y > _y0 && _inst.y < _y0 + camera_get_view_height(_cam)
}

/**
 * @param {Bool} _threats_only -- only consider enemies inside threat_radius
 * @returns {Id.Instance} the closest on-screen enemy (or threat), or noone
 */
function find_target(_threats_only) {
	var _best = noone
	var _best_dist = _threats_only ? threat_radius : infinity
	with (obj_menu_enemy_1) {
		var _dist = point_distance(x, y, other.x, other.y)
		// a threat is always fair game, otherwise only shoot what the viewer can see
		if (_dist < _best_dist && (_threats_only || other.is_on_screen(id))) {
			_best = id
			_best_dist = _dist
		}
	}
	return _best
}

function fire_at_target() {
	var _muzzle = get_turret_muzzle()
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target: target,
		width: global.beam_width,
		color: global.beam_color,
	})
	recoil_amount = max_recoil_amount
	instance_destroy(target)
	target = noone
	shot_timer = shot_interval + random_range(-shot_interval_jitter, shot_interval_jitter)
	idle_timer = 0
}

// a menu item the player typed: the turret drops whatever it was doing, shoots the item, and the item's
// on_click runs menu_trigger_delay seconds after the shot so the hit reads first
menu_item = noone
menu_item_hit = false
menu_trigger_delay = 0.2 // in seconds
menu_trigger_timer = 0

/**
 * @param {Id.Instance} _inst -- an obj_menu_button, obj_menu_toggle, or obj_menu_number_input
 */
function shoot_menu_item(_inst) {
	// one at a time -- ignore anything typed while a menu shot is in flight
	if (menu_item != noone) {
		return
	}
	menu_item = _inst
	menu_item_hit = false
	target = noone
}

/**
 * Menu items draw on the GUI layer, so aim at the room position under the middle of the item
 * @returns {{x: Real, y: Real}}
 */
function get_menu_item_world_position() {
	var _bounds = menu_item.bounds
	return is_undefined(_bounds) ? gui_to_world(menu_item.x, menu_item.y) : gui_to_world(_bounds.xcenter, _bounds.ycenter)
}

function fire_at_menu_item() {
	var _hit = get_menu_item_world_position()
	var _muzzle = get_turret_muzzle()
	instance_create_layer(_muzzle.x, _muzzle.y, LAYER_BG_EFFECTS, obj_muzzle_flash, {
		target: noone,
		target_x: _hit.x,
		target_y: _hit.y,
		width: global.beam_width,
		color: global.beam_color,
	})
	instance_create_layer(_hit.x, _hit.y, LAYER_FG_EFFECTS, obj_particle_effect, {effect: draw_particle_shockwave})
	recoil_amount = max_recoil_amount
	menu_item_hit = true
	menu_trigger_timer = menu_trigger_delay
}

function trigger_menu_item() {
	var _item = menu_item
	menu_item = noone
	menu_item_hit = false
	shot_timer = shot_interval
	idle_timer = 0
	if (instance_exists(_item)) {
		_item.on_click(_item)
	}
}

function get_turret_muzzle() {
	return {
		x: x + lengthdir_x(global.turret_length, image_angle),
		y: y + lengthdir_y(global.turret_length, image_angle)
	}
}
