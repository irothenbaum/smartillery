// Spawn 2 training targets at 20% down from top, at 1/3 and 2/3 room width
var _y_pos = room_height * 0.25

instance_create_layer(room_width * 0.4, _y_pos, LAYER_INSTANCES, obj_training_target)
instance_create_layer(room_width * 0.6, _y_pos, LAYER_INSTANCES, obj_training_target)

get_player().y = global.room_height * 0.75