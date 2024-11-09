varying vec2 v_vTexcoord;
uniform sampler2D u_maskTexture;
uniform vec2 u_scale; // Uniform for scaling

void main()
{
    // Scale the texture coordinates based on u_scale
    vec2 scaledTexCoord = v_vTexcoord / u_scale;

    // Sample colors from the base texture and the mask texture
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord); // Use GameMaker's built-in base texture
    vec4 maskColor = texture2D(u_maskTexture, scaledTexCoord);

    // Use the mask's alpha to determine transparency
    gl_FragColor = vec4(baseColor.rgb, baseColor.a * maskColor.a);
}
