// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

varying highp vec2 vTexCoordOut;
varying highp vec2 vTexCoordOut2;
varying highp vec2 vTexCoordOut3;
varying highp vec2 vTexCoordOut4;
varying highp vec2 vTexCoordOut5;
varying highp vec2 vTexCoordOut6;
varying highp vec2 vTexCoordOut7;
varying highp vec2 vTexCoordOut8;
varying highp vec2 vTexCoordOut9;

uniform sampler2D texture;

void main(void) {
  highp vec4 colorSum = texture2D(texture, vTexCoordOut) + texture2D(texture, vTexCoordOut2)
                            + texture2D(texture, vTexCoordOut3) + texture2D(texture, vTexCoordOut4)
                            + texture2D(texture, vTexCoordOut5) + texture2D(texture, vTexCoordOut6)
                            + texture2D(texture, vTexCoordOut7) + texture2D(texture, vTexCoordOut8)
                            + texture2D(texture, vTexCoordOut9);
  gl_FragColor = colorSum / 9.0;
}
