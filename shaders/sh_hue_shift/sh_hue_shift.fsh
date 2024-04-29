//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec4 u_vColor;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
	if (
		texColor.r == 1.0 &&
		texColor.g == 1.0 &&
		texColor.b == 1.0
	) {
		gl_FragColor = v_vColour * texColor;
	} else {
		gl_FragColor = vec4(u_vColor.rgb, texColor.a);
	}
	
}
