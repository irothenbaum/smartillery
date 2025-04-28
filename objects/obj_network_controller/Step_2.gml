/// @description Send events buffer

if (array_length(event_buffer) > 0) {
	send_events(event_buffer)
	event_buffer = []
}
