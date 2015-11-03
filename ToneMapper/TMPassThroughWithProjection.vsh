// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

attribute vec4 position;
attribute vec2 texCoordIn;

uniform mat4 projection;

varying vec2 vTexCoordOut;

void main(void) {
  gl_Position = projection * position;
  vTexCoordOut = texCoordIn;
}
