/// @description Insert description here
size = lerp(0, size, 0.05)

if (size < 0.01 || !instance_exists(target)) {
	instance_destroy();
}

x = target.x
y = target.y
