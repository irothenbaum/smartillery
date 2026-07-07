/// @description Draw per-player ultimate selection card

var _ult   = get_current_ultimate()
var _color = global.ultimate_colors[$ _ult]
var _spr   = global.ultimate_icons[$ _ult]
var _desc  = global.ultimate_descriptions[$ _ult]
var _taken = is_taken_by_other(_ult)

// ── Layout ──────────────────────────────────────────────────────
// the card is a fixed size (doesn't resize as you cycle) and is built top-down:
// label -> header (icon + title) -> video preview -> description -> hint (pinned to the bottom)
var _card_top     = y - card_half_h
var _card_bottom  = y + card_half_h
var _card_bounds  = new Bounds(x - card_half_w, _card_top, x + card_half_w, _card_bottom)
var _text_x       = _card_bounds.x0 + global.margin_md
// fixed position (rather than relative to content above) since that content varies in
// size slightly between ultimates, which would otherwise make this jump around as you cycle
var _desc_y       = _card_top + (card_height * 0.75)

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
draw_text_with_alignment(_text_x, _card_top + 14, _label, ALIGN_LEFT)

// ── Header: icon + title, left-aligned together ────────────────
draw_set_font(fnt_title)
var _header_y   = _card_top + 54
var _title_h    = string_height(_desc.title)
// the icon is sized to roughly match the title text's height
var _icon_size  = _title_h
var _icon_scale = _icon_size / sprite_get_height(_spr)
var _icon_x     = _text_x + (_icon_size / 2)
var _title_x    = _text_x + _icon_size + global.margin_sm

draw_sprite_ext(_spr, 0, _icon_x, _header_y, _icon_scale, _icon_scale, 0, _taken ? c_dkgray : _color, _taken ? 0.3 : 1)

draw_set_color(_taken ? c_dkgray : _color)
draw_text_with_alignment(_title_x, _header_y, _desc.title, ALIGN_LEFT)

// ── Video preview area ──────────────────────────────────────────
// reserves the space the (now much smaller, relocated) icon used to occupy for a
// pre-recorded clip of the ultimate in action. See scr_constants for
// global.ultimate_video_clips -- once an entry exists for this ultimate, swap this
// placeholder block for actual video_open()/video_draw() calls.
var _video_top    = _header_y + (_title_h / 2) + global.margin_lg
var _video_bottom = _desc_y - global.margin_lg
var _video_bounds = new Bounds(_card_bounds.x0 + 50, _video_top, _card_bounds.x1 - 50, _video_bottom)

draw_set_color(c_black)
draw_set_alpha(0.35)
draw_rounded_rectangle(_video_bounds, 10, 0)
draw_set_alpha(1)

draw_set_font(fnt_title)
draw_set_color(_taken ? c_dkgray : c_white)
draw_set_alpha(0.5)
draw_text_with_alignment(_video_bounds.xcenter, _video_bounds.ycenter, "▶", ALIGN_CENTER)
draw_set_alpha(1)

// ── Cycle arrows ──────────────────────────────────────────────
if (!is_locked) {
	draw_set_font(fnt_title)
	draw_set_color(_taken ? c_dkgray : c_white)
	draw_set_alpha(0.45)
	// bounds are stashed so Step can tell whether a click landed on an arrow
	left_arrow_bounds  = draw_text_with_alignment(_card_bounds.x0 + 24, _video_bounds.ycenter, "<", ALIGN_CENTER)
	right_arrow_bounds = draw_text_with_alignment(_card_bounds.x1 - 24, _video_bounds.ycenter, ">", ALIGN_CENTER)
	draw_set_alpha(1)
} else {
	left_arrow_bounds  = undefined
	right_arrow_bounds = undefined
}

// ── Description ───────────────────────────────────────────────
draw_set_font(fnt_base)
draw_set_color(_taken ? c_dkgray : c_white)
var _card_inner_w = card_width - (global.margin_md * 2)
var _wrapped_desc = word_wrap(_desc.description, _card_inner_w)
draw_text_with_alignment(_text_x, _desc_y, _wrapped_desc, ALIGN_LEFT)

// ── Status / hint ─────────────────────────────────────────────
draw_set_font(fnt_base)
var _hint_y = _card_bottom - 28
if (is_locked) {
	draw_set_color(_color)
	draw_text_with_alignment(_text_x, _hint_y, "READY", ALIGN_LEFT)
} else if (_taken) {
	draw_set_color(c_red)
	draw_text_with_alignment(_text_x, _hint_y, "TAKEN — keep cycling", ALIGN_LEFT)
} else {
	draw_set_color(c_dkgray)
	var _hint = device_index >= 0
		? "[D-Pad]  Cycle     [A]  Confirm"
		: "[< >]  Cycle     [Enter]  Confirm"
	draw_text_with_alignment(_text_x, _hint_y, _hint, ALIGN_LEFT)
}

// ── Shared screen title (drawn once by player 0's card) ───────
if (owner_player_id == 0) {
	draw_set_font(fnt_title)
	draw_set_color(c_white)
	draw_text_with_alignment(global.room_width / 2, global.room_height * 0.1, "Select Your Ultimate", ALIGN_CENTER)
}

reset_composite_color()
draw_set_font(fnt_base)
