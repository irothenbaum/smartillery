attribute vec2 in_Position;
attribute vec2 in_TextureCoord;
varying vec2 v_vTexcoord;
// varying vec4 v_vColour;

void main()
{
    v_vTexcoord = in_TextureCoord;
    // v_vColour = vec4(1.0, 1.0, 1.0, 1.0); // passing a neutral color to indicate no modification needed
    gl_Position = vec4(in_Position, 0.0, 1.0);
}
