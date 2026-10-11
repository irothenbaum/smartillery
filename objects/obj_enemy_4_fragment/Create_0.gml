event_inherited()
collision_damage = global.damage_enemy_4_fragment_collision
destroy_effect = draw_particle_enemy_4_fragment_destroy

image_scale = 0.12
image_xscale = image_scale
image_yscale = image_scale
speed = 2
wobble_frequency = 1500
wobble_amplitude = 30
target_location = undefined
target_direction = direction
target_delay = (irandom_range(500,2000) / 1000) * game_get_speed(gamespeed_fps)
alarm[0] = target_delay
