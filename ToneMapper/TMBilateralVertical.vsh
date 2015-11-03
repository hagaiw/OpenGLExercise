// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

attribute vec4 position;
attribute vec2 texCoordIn;

uniform vec2 textureDimensions;
uniform mat4 projection;

varying highp vec2 vTexCoordOutNegative2;
varying highp vec2 vTexCoordOutNegative1;
varying highp vec2 vTexCoordOutCenter;
varying highp vec2 vTexCoordOut1;
varying highp vec2 vTexCoordOut2;

void main(void) {
  float pixelHeight = 1.0 / textureDimensions.y;
  vTexCoordOutNegative2 = texCoordIn + vec2(0.0, -2.0 * pixelHeight);
  vTexCoordOutNegative1 = texCoordIn + vec2(0.0, -pixelHeight);
  vTexCoordOutCenter = texCoordIn;
  vTexCoordOut1 = texCoordIn + vec2(0.0, pixelHeight);
  vTexCoordOut2 = texCoordIn + vec2(0.0, 2.0 * pixelHeight);
  gl_Position = projection * position;
}
