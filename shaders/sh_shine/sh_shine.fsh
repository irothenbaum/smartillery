//
// Shine: a thin band sweeping across the room in world space. Pixels of whatever is drawn (sprite or primitive)
// that fall inside the band turn white; alpha is left alone, so the band only shows on the thing itself.
// The band's position is worked out on the CPU (see shader_set_shine)
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vWorldPos;

uniform vec2 u_vDir;       // normalized direction the band travels
uniform float u_fBandPos;  // where the band's center is, measured along u_vDir
uniform float u_fHalfWidth; // half the band's thickness, in px
uniform float u_fTextured; // 1 for sprites, 0 for primitives (no texture is bound for those, so don't sample one)

void main()
{
    vec4 base = v_vColour;
    if (u_fTextured > 0.5) {
        base *= texture2D(gm_BaseTexture, v_vTexcoord);
    }
    float dist = abs(dot(v_vWorldPos, u_vDir) - u_fBandPos);
    // 1px soft edge so the band doesn't crawl/alias as it moves
    float shine = 1.0 - smoothstep(u_fHalfWidth - 1.0, u_fHalfWidth, dist);
    gl_FragColor = vec4(mix(base.rgb, vec3(1.0), shine), base.a);
}
