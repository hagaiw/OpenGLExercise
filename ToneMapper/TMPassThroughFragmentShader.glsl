// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

varying highp vec2 vTexCoordOut;
uniform sampler2D texture;

void main(void) {
  gl_FragColor = texture2D(texture, vTexCoordOut);
}
