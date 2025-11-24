/// @description Draw square target
// Save previous matrix
var _m = matrix_get(matrix_world);

var _size = smallest_size + (max(0, 1 - animation_progress) * (largest_size - smallest_size))
var _dimension = _size / 2

// Build a new matrix that applies rotation around the rectangle center
var _mx = matrix_build(x, y, 0, 0, 0, 180 * animation_progress, 1, 1, 1);
matrix_set(matrix_world, _mx);

// Draw rectangle centered on (0,0)
draw_set_color(color);
draw_rounded_rectangle(new Bounds(-_dimension, -_dimension, _dimension, _dimension), 0, 3);
reset_composite_color()

// Restore old matrix
matrix_set(matrix_world, _m);