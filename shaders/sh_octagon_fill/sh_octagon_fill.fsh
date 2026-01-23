//
// Octagon section fill shader
// Colors pixels purple if they fall within filled octagon sections
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_vColor;        // The fill color (purple) - RGB only
uniform float u_sections;     // Number of sections filled (0-8)
uniform float u_rotation;     // Rotation angle in radians
uniform vec4 u_uvs;           // Sprite UVs on texture page: (left, top, right, bottom)

#define PI 3.14159265359
#define TAU 6.28318530718

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);

    // Normalize texcoord to 0-1 range within the sprite's UV bounds
    vec2 normalizedCoord = (v_vTexcoord - u_uvs.xy) / (u_uvs.zw - u_uvs.xy);

    // Calculate angle from center of sprite (0.5, 0.5) to this pixel
    vec2 centered = normalizedCoord - vec2(0.5, 0.5);
    float angle = atan(centered.y, centered.x);

    // Adjust for rotation and normalize to 0-TAU range
    angle = mod(angle - u_rotation, TAU);
    if (angle < 0.0) {
        angle += TAU;
    }

    // Calculate which section this pixel is in (0-7)
    float section_angle = TAU / 8.0;
    float section = floor(angle / section_angle);

    // Check if this section should be filled (add small epsilon for float comparison)
    if (section + 0.5 < u_sections) {
        // Apply color to non-white pixels (same logic as sh_hue_shift)
        if (texColor.r == 1.0 && texColor.g == 1.0 && texColor.b == 1.0) {
            gl_FragColor = v_vColour * texColor;
        } else {
            gl_FragColor = vec4(u_vColor.rgb, texColor.a);
        }
    } else {
        // Keep original color
        gl_FragColor = v_vColour * texColor;
    }
}
