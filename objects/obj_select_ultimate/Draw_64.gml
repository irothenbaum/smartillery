/// @description Draw per-player ultimate selection card

var _ult   = get_current_ultimate()
var _color = global.ultimate_colors[$ _ult]
var _spr   = global.ultimate_icons[$ _ult]
var _desc  = global.ultimate_descriptions[$ _ult]
var _taken = is_taken_by_other(_ult)

var _card_h      = 380
var _card_bounds = new Bounds(x - card_half_w, y - _card_h / 2, x + card_half_w, y + _card_h / 2)

// ── Background ────────────────────────────────────────────────
draw_set_color(is_locked ? _color : #2a2a2a)
draw_set_alpha(is_locked ? 0.25 : 0.6)
draw_rounded_rectangle(_card_bounds, 14, 0)

draw_set_color(is_locked ? _color : c_dkgray)
draw_set_alpha(is_locked ? 1.0 : 0.45)
draw_rounded_rectangle(_card_bounds, 14, 3)
draw_set_alpha(1)

// ── Player label ──────────────────────────────────────────────
draw_set_font(fnt_base)
draw_set_color(c_ltgrey)
var _pnum  = get_player_number(owner_player_id) + 1
var _label = owner_player_id == 0 ? "YOU  (P1)" : ("PLAYER " + string(_pnum))
draw_text_with_alignment(x, _card_bounds.y0 + 14, _label, ALIGN_CENTER)

// ── Cycle arrows ──────────────────────────────────────────────
if (!is_locked) {
	draw_set_font(fnt_title)
	draw_set_color(_taken ? c_dkgray : c_white)
	draw_set_alpha(0.45)
	draw_text_with_alignment(_card_bounds.x0 + 24, y - 28, "<", ALIGN_CENTER)
	draw_text_with_alignment(_card_bounds.x1 - 24, y - 28, ">", ALIGN_CENTER)
	draw_set_alpha(1)
}

// ── Icon ──────────────────────────────────────────────────────
draw_sprite_ext(_spr, 0, x, y - 30, 0.13, 0.13, 0, _taken ? c_dkgray : _color, _taken ? 0.3 : 1)

// ── Name ──────────────────────────────────────────────────────
draw_set_font(fnt_title)
draw_set_color(_taken ? c_dkgray : _color)
draw_text_with_alignment(x, y + 60, _desc.title, ALIGN_CENTER)

// ── Description ───────────────────────────────────────────────
draw_set_font(fnt_base)
draw_set_color(_taken ? c_dkgray : c_white)
draw_text_with_alignment(x, y + 92, _desc.description, ALIGN_CENTER)

// ── Status / hint ─────────────────────────────────────────────
draw_set_font(fnt_base)
if (is_locked) {
	draw_set_color(_color)
	draw_text_with_alignment(x, _card_bounds.y1 - 28, "READY", ALIGN_CENTER)
} else if (_taken) {
	draw_set_color(c_red)
	draw_text_with_alignment(x, _card_bounds.y1 - 28, "TAKEN — keep cycling", ALIGN_CENTER)
} else {
	draw_set_color(c_dkgray)
	var _hint = device_index >= 0
		? "[D-Pad]  Cycle     [A]  Confirm"
		: "[< >]  Cycle     [Enter]  Confirm"
	draw_text_with_alignment(x, _card_bounds.y1 - 28, _hint, ALIGN_CENTER)
}

// ── Shared screen title (drawn once by player 0's card) ───────
if (owner_player_id == 0) {
	draw_set_font(fnt_title)
	draw_set_color(c_white)
	draw_text_with_alignment(room_width / 2, 28, "Select Your Ultimate", ALIGN_CENTER)
}

reset_composite_color()
draw_set_font(fnt_base)
