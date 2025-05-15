/// @description Check for events

var _new_events = check_for_network_events()

array_foreach(_new_events, handle_network_event)