/// @description Draw square target
// Save previous matrix
var _m = matrix_get(matrix_world);

var _scale = (1 + size) / 2
var _size = smallest_size + (size / 1) * (largest_size - smallest_size)
var _dimension = _size / 2
// Build a new matrix that applies rotation around the rectangle center
var _mx = matrix_build(x, y, 0, 0, 0, 45 * (1 - size), _scale, _scale, 1);
matrix_set(matrix_world, _mx);

// Draw rectangle centered on (0,0)
draw_set_color(global.ultimate_colors[$ ULTIMATE_ASSIST]);
draw_rectangle(x - _dimension, y - _dimension, x + _dimension, y + _dimension, true);

// Restore old matrix
matrix_set(matrix_world, _m);