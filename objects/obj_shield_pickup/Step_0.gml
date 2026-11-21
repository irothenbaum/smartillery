/// @description Move toward the player and grow
if (global.paused) {
	return
}

elapsed += step_seconds()
var _progress = min(1, elapsed / duration)
// ease in-out: lifts off the orbit gently, then settles into place
var _eased = _progress < 0.5 ? 4 * power(_progress, 3) : 1 - power(-2 * _progress + 2, 3) / 2

x = lerp(start_x, global.xcenter, _eased)
y = lerp(start_y, global.ycenter, _eased)
scale = lerp(start_scale, 1, _eased)

if (_progress >= 1) {
	land()
}
