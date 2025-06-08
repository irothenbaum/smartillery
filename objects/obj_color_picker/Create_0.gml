colors = [c_ltgrey, c_aqua, c_lime, c_orange, c_purple, c_red]
color_count = array_length(colors)
selected_color = 0
box_size = 40
margin = 10
stroke_width = 4

bounds = new FormattedBounds({x0: x, x1: x + (color_count * (box_size + margin)) - margin, y0: y, y1: y + box_size})
// a hacky way to shift to center
x = bounds.xcenter - bounds.width;
y = bounds.ycenter - bounds.height;
bounds = new FormattedBounds({x0: x, x1: x + (color_count * (box_size + margin)) - margin, y0: y, y1: y + box_size})
// ---------------------------------

// TODO: somehow selected via the menu
is_focused = true