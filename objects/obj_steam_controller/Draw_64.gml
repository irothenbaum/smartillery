/// @description Debug draw
draw_set_font(fnt_small)
draw_text(32,32, $"steam {steam_initialised() ? "is": "is not"} initalized")
draw_text(32,48, $"steam name \"{steam_get_persona_name()}\"")

draw_sprite(steam_avatar_sprite, 0, 32, 96)