varying highp vec2 vTexCoordOut;
uniform highp mat4 toneAdjustment;
uniform highp mat4 projection;
uniform sampler2D texture;

void main(void) {
  highp vec4 textureColor = texture2D(texture, vTexCoordOut);
  gl_FragColor = toneAdjustment * textureColor;
}


