attribute vec4 Position;
attribute vec2 TexCoordIn;

uniform mat4 Projection;

varying vec2 TexCoordOut;

void main(void) {
  gl_Position = Projection * Position;
  TexCoordOut = TexCoordIn;
}