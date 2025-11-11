//                length
//         ------------------
//         |                | }
//  x,y ---O                | }---- width
//         |                | }
//         ------------------
//
// x and y are the origins of the bar, defined as the center point along one side
// in Create, we calculate the rectangle length by determine point_distance and direction to target.x, target.y
// At this point we have rectangle height, width, and "origin" which is the center point along one width side
// we then want to rotate about this origin to face `direction` and calculate our new x0, x1, y0, y1 given x,y, and width


draw_sprite_ext(spr_pixel, 0, x, y, length / sprite_height, width / sprite_width, direction, color, image_alpha)