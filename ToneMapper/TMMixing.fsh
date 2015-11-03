// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

varying highp vec2 vTexCoordOut;
uniform sampler2D texture;
uniform sampler2D strongBlurTexture;
uniform sampler2D weakBlurTexture;
uniform lowp float fineWeight;
uniform lowp float mediumWeight;

void main(void) {
  lowp vec4 originalColor = texture2D(texture, vTexCoordOut);
  lowp vec4 weakBlurColor = texture2D(weakBlurTexture, vTexCoordOut);
  lowp vec4 strongBlurColor = texture2D(strongBlurTexture, vTexCoordOut);
  gl_FragColor = (fineWeight + mediumWeight) * originalColor + (0.5 - fineWeight) *
      (strongBlurColor) + (0.5 - mediumWeight)*weakBlurColor;
}
