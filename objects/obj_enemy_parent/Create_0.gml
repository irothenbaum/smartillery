/// @description Shared enemy setup
// Every enemy (and the training target) inherits from this object. Children call event_inherited()
// at the top of their own Create, then override the values below as needed.

// These defaults must be set BEFORE enemy_initialize: if no unused answer can be found, enemy_initialize
// destroys the instance immediately, which runs the Destroy event (and reads destroy_effect) mid-Create.
// damage dealt to the player on contact (the enemy is destroyed). undefined = this enemy doesn't ram the player
collision_damage = undefined
// particle effect function played when this enemy is destroyed
destroy_effect = undefined

enemy_initialize(self)

function register_hit(_damage_amount) {
	instance_destroy()
}
