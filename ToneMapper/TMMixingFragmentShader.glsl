varying highp vec2 vTexCoordOut;
uniform sampler2D texture;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform lowp float alpha1;
uniform lowp float alpha2;

void main(void) {
  
  lowp vec4 original = texture2D(texture, vTexCoordOut);
  lowp vec4 midBlur = texture2D(texture2, vTexCoordOut);
  lowp vec4 largeBlur = texture2D(texture3, vTexCoordOut);
  gl_FragColor = (alpha1 + alpha2)*original + (0.5 - alpha1) * (midBlur)
                    + (0.5 - alpha2)*texture2D(texture3, vTexCoordOut);
}