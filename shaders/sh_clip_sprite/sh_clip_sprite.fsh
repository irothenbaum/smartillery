varying vec2 v_vTexcoord;
uniform sampler2D u_maskTexture;
uniform vec2 u_scale; // Uniform for scaling

void main()
{
    // Scale the texture coordinates based on u_scale
    // vec2 scaledTexCoord = v_vTexcoord / u_scale;
	vec2 scaledTexCoord = v_vTexcoord;

    // Sample colors from the base texture and the mask texture
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 maskColor = texture2D(u_maskTexture, scaledTexCoord);

    // Use the mask's alpha to determine transparency
    // gl_FragColor = vec4(baseColor.rgb, baseColor.a * (1.0 - maskColor.a));
	// gl_FragColor = vec4(v_vTexcoord, 0.0, 1.0); // Should give a gradient from black to blue and green
	gl_FragColor = baseColor;

}
