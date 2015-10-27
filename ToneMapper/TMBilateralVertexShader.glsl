// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

attribute vec4 position;
attribute vec2 texCoordIn;

uniform vec2 textureDimensions;
uniform mat4 projection;

varying vec2 vTexCoordOut;
varying vec2 vTexCoordOut2;
varying vec2 vTexCoordOut3;
varying vec2 vTexCoordOut4;
varying vec2 vTexCoordOut5;
varying vec2 vTexCoordOut6;
varying vec2 vTexCoordOut7;
varying vec2 vTexCoordOut8;
varying vec2 vTexCoordOut9;

void main(void) {
  float pixelWidth = 1.0/textureDimensions.x;
  float pixelHeight = 1.0/textureDimensions.y;
  gl_Position = projection * position;
  vTexCoordOut = texCoordIn;
  vTexCoordOut2 = texCoordIn + vec2(pixelWidth, 0.0);
  vTexCoordOut3 = texCoordIn + vec2(0.0, pixelHeight);
  vTexCoordOut4 = texCoordIn + vec2(-pixelWidth, 0.0);
  vTexCoordOut5 = texCoordIn + vec2(0.0, -pixelHeight);
  vTexCoordOut6 = texCoordIn + vec2(pixelWidth, pixelHeight);
  vTexCoordOut7 = texCoordIn + vec2(pixelWidth, -pixelHeight);
  vTexCoordOut8 = texCoordIn + vec2(-pixelWidth, pixelHeight);
  vTexCoordOut9 = texCoordIn + vec2(-pixelWidth, -pixelHeight);
}
