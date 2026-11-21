/// @description Shared orb cluster power item setup
// Parent of the power items drawn as a cluster of the orbs they pay out (obj_power_item_points, _health). The cluster
// is built from the same split obj_orb_score_increase uses, so it shows the same number and sizes of orbs that will
// fly to the player. When hit, those orbs spawn starting from the cluster's current positions, so the cluster itself
// flies off. Children set orb_type and orb_layer, override get_orb_amount(), then call sync_cluster()
event_inherited()

orb_type = ORB_TYPE_SCORE
orb_layer = LAYER_FG_EFFECTS
cluster = []
hover_radius = 0

/// Children override this with how much their orbs pay out
function get_orb_amount() {
	return 1
}

/**
 * Rebuilds the cluster when the payout's orb split changes (e.g. the points item is worth more once the wave goes up),
 * keeping each surviving orb's motion so nothing jumps
 */
function sync_cluster() {
	var _values = split_orb_amount(get_orb_amount())
	var _count = array_length(_values)

	// unchanged? keep going as we are
	if (_count == array_length(cluster)) {
		var _same = true
		for (var _i = 0; _i < _count; _i++) {
			if (cluster[_i].value != _values[_i]) {
				_same = false
				break
			}
		}
		if (_same) {
			return
		}
	}

	var _new_cluster = []
	for (var _i = 0; _i < _count; _i++) {
		// each orb drifts on its own loop (different speeds per axis, so the paths never sync up) around the center
		var _orb = _i < array_length(cluster) ? cluster[_i] : {
			phase_x: random(360),
			phase_y: random(360),
			speed_x: random_range(60, 140), // degrees per second
			speed_y: random_range(60, 140),
			x_diff: 0,
			y_diff: 0,
		}
		_orb.value = _values[_i]
		array_push(_new_cluster, _orb)
	}
	cluster = _new_cluster

	// more orbs spread out more, approaching the flying cloud's spread
	hover_radius = min(ORB_CLOUD_RADIUS, 6 * sqrt(_count))
	update_cluster_positions()
}

function update_cluster_positions() {
	for (var _i = 0; _i < array_length(cluster); _i++) {
		var _orb = cluster[_i]
		_orb.x_diff = dcos(_orb.phase_x) * hover_radius
		_orb.y_diff = dsin(_orb.phase_y) * hover_radius
	}
}

function register_hit() {
	// (the answer is released by obj_bonus_item_parent's Destroy)
	debug("ORB ITEM", object_get_name(object_index), "HIT by", last_hit_by_player_id)
	var _start_offsets = []
	for (var _i = 0; _i < array_length(cluster); _i++) {
		array_push(_start_offsets, {x: cluster[_i].x_diff, y: cluster[_i].y_diff})
	}
	instance_create_layer(x, y, orb_layer, obj_orb_score_increase, {
		amount: get_orb_amount(),
		type: orb_type,
		owner_player_id: last_hit_by_player_id,
		start_offsets: _start_offsets,
	})
	instance_destroy()
}
