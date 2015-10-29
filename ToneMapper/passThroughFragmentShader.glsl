varying highp vec2 vTexCoordOut;
uniform sampler2D texture;

void main(void) {
  gl_FragColor = texture2D(texture, vTexCoordOut);
}
