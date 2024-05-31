// Vertex shader
attribute vec2 in_Position;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordDistorted;

void main()
{
    gl_Position = vec4(in_Position.x, in_Position.y, 0.0, 1.0);
    v_vTexcoord = in_TextureCoord;
    
    // Apply distortion effect (you can adjust the values as needed)
    float distortionStrength = 0.1; // Adjust this for the strength of the distortion
    float distortionSpeed = 5.0; // Adjust this for the speed of the distortion
    v_vTexcoordDistorted = v_vTexcoord + vec2(sin(v_vTexcoord.y * distortionSpeed) * distortionStrength, 0.0);
}