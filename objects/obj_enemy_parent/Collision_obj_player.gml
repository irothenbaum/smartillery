/// @description Ram the player
if (is_undefined(collision_damage)) {
	return
}

get_player().execute_take_damage(collision_damage)
instance_destroy()
