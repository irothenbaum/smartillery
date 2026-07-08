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
// icon is sized to match the title text's height, same visual scale for every
// ultimate -- but that means its rendered width still varies by aspect ratio, so the
// title instead starts at a fixed reserved column rather than at the icon's actual
// (varying) right edge, so its x position doesn't shift as you cycle
var _icon_height       = _title_h
var _icon_scale        = _icon_height / sprite_get_height(_spr)
// generous enough for the widest ultimate icon (currently spr_ult_turret, ~1.3x
// wider than tall); the icon is left-aligned within this column, not centered in it
var _icon_column_width = _icon_height * 1.4
var _icon_x            = _text_x + (sprite_get_width(_spr) * _icon_scale / 2)
var _title_x           = _text_x + _icon_column_width + global.margin_sm

draw_sprite_ext(_spr, 0, _icon_x, _header_y, _icon_scale, _icon_scale, 0, _taken ? c_dkgray : _color, _taken ? 0.3 : 1)

draw_set_color(_taken ? c_dkgray : _color)
draw_text_with_alignment(_title_x, _header_y, _desc.title, ALIGN_LEFT)

// ── Video preview area ──────────────────────────────────────────
// fixed-size (video_width x video_height, see Create) preview of the ultimate in
// action. See global.ultimate_preview_sprites (scr_constants) -- an ultimate with no
// entry there just shows the placeholder box below instead.
var _video_top    = _header_y + (_title_h / 2) + global.margin_lg
var _video_bounds = new Bounds(x - (video_width / 2), _video_top, x + (video_width / 2), _video_top + video_height)

// fixed position (rather than relative to content above) since the video box is the
// same size for every ultimate, so this doesn't need to vary either
var _desc_y = _video_bounds.y1 + global.margin_lg

var _preview_sprite = global.ultimate_preview_sprites[$ _ult]

if (is_undefined(_preview_sprite)) {
	draw_set_color(c_black)
	draw_set_alpha(0.35)
	draw_roundrect_ext(_video_bounds.x0, _video_bounds.y0, _video_bounds.x1, _video_bounds.y1, 10, 10, false)
	draw_set_alpha(1)

	draw_set_font(fnt_title)
	draw_set_color(_taken ? c_dkgray : c_white)
	draw_set_alpha(0.5)
	draw_text_with_alignment(_video_bounds.xcenter, _video_bounds.ycenter, "▶", ALIGN_CENTER)
	draw_set_alpha(1)
} else {
	// clips are exported (see notes/GeneratingUltCardVideos) already cropped to this
	// box's exact aspect ratio, so a uniform scale fills it exactly -- no clipping needed
	var _frame_count   = sprite_get_number(_preview_sprite)
	var _preview_scale = video_width / sprite_get_width(_preview_sprite)

	// reveal/loop sequence (generic across every ultimate's preview clip -- see Create):
	// hold on a black + ult-icon title card -> fade out, revealing the video paused on
	// its first frame -> play through once -> fade back to black on the last frame ->
	// repeat forever. Driven entirely by preview_elapsed (mod the total cycle length)
	// instead of a separately-ticking frame counter, so there's nothing else to desync.
	var _play_duration  = _frame_count / video_playback_fps
	var _hold_end       = preview_hold_seconds
	var _fade_out_end   = _hold_end + preview_fade_seconds
	var _play_end       = _fade_out_end + _play_duration
	var _cycle_duration = _play_end + preview_fade_seconds
	var _cycle_t        = preview_elapsed mod _cycle_duration

	var _overlay_alpha = 1
	var _preview_frame = 0

	if (_cycle_t < _hold_end) {
		// holding on the title card
		_overlay_alpha = 1
		_preview_frame = 0
	} else if (_cycle_t < _fade_out_end) {
		// fading out, revealing the video paused on its first frame
		_overlay_alpha = 1 - ((_cycle_t - _hold_end) / preview_fade_seconds)
		_preview_frame = 0
	} else if (_cycle_t < _play_end) {
		// playing
		_overlay_alpha = 0
		_preview_frame = floor((_cycle_t - _fade_out_end) * video_playback_fps) mod _frame_count
	} else {
		// finished playing -- fade back to black on the last frame, then loop
		_overlay_alpha = (_cycle_t - _play_end) / preview_fade_seconds
		_preview_frame = _frame_count - 1
	}
	_overlay_alpha = clamp(_overlay_alpha, 0, 1)

	// this sprite's origin is Top Left, not centered, so draw from the box's top-left corner
	draw_sprite_ext(_preview_sprite, _preview_frame, _video_bounds.x0, _video_bounds.y0, _preview_scale, _preview_scale, 0, c_white, _taken ? 0.3 : 1)

	if (_overlay_alpha > 0) {
		// slightly larger than the video bounds so scaling/rounding can't leave a
		// sliver of video peeking out around the edge of the black overlay
		var _overlay_bounds = apply_padding_to_bounds(_video_bounds, 6, 6)

		draw_set_color(c_black)
		draw_set_alpha(_overlay_alpha)
		draw_roundrect_ext(_overlay_bounds.x0, _overlay_bounds.y0, _overlay_bounds.x1, _overlay_bounds.y1, 10, 10, false)
		draw_set_alpha(1)

		var _reveal_icon_size  = video_width * 0.75
		var _reveal_icon_scale = _reveal_icon_size / sprite_get_width(_spr)
		draw_sprite_ext(_spr, 0, _video_bounds.xcenter, _video_bounds.ycenter, _reveal_icon_scale, _reveal_icon_scale, 0, _taken ? c_dkgray : _color, _overlay_alpha)
	}
}

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
