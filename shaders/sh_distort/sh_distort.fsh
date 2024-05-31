//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordDistorted;

void main()
{
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoordDistorted);
    gl_FragColor = baseColor;
}
