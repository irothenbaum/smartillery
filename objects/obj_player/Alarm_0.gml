// This alarm resets the turret's direction to idle
rotate_speed = rotate_idle_speed;
rotate_to = direction;

broadcast(EVENT_NEW_TURRET_ANGLE, {
	rotate_to: rotate_to,
	rotate_speed: rotate_speed,
})