align = ALIGN_LEFT;
expire_in = 999999999;
message=""

x = room_width / 2;
y = room_height / 2;

function set_text(_msg, _val = MESSAGE_SHOW_DURATION) {
	debug(_msg)
	message = _msg
	expire_in = _val * game_get_speed(gamespeed_fps)
	debug(expire_in)
	alarm_set(0, expire_in);
}