// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

varying lowp vec2 vTexCoordOutNegative2;
varying lowp vec2 vTexCoordOutNegative1;
varying lowp vec2 vTexCoordOutCenter;
varying lowp vec2 vTexCoordOut1;
varying lowp vec2 vTexCoordOut2;

uniform sampler2D texture;

lowp float weight(lowp vec4 color1, lowp vec4 color2);

void main(void) {
  lowp vec4 colorNegative2 = texture2D(texture, vTexCoordOutNegative2);
  lowp vec4 colorNegative1 = texture2D(texture, vTexCoordOutNegative1);
  lowp vec4 colorCenter = texture2D(texture, vTexCoordOutCenter);
  lowp vec4 color1 = texture2D(texture, vTexCoordOut1);
  lowp vec4 color2 = texture2D(texture, vTexCoordOut2);

  lowp float weightNegative2 = 0.06136 * weight(colorCenter, colorNegative2);
  lowp float weightNegative1 = 0.24477 * weight(colorCenter, colorNegative1);
  lowp float weightCenter = 0.38774;
  lowp float weight1 = 0.24477 * weight(colorCenter, color1);
  lowp float weight2 = 0.06136 * weight(colorCenter, color2);
  
  lowp vec4 colorSum = weightNegative2 * colorNegative2 + weightNegative1 * colorNegative1 +
                            weightCenter * colorCenter + weight1 * color1 + weight2 * color2;
  gl_FragColor = colorSum / (weightCenter + weightNegative2 + weightNegative1 + weight1 + weight2);
}


lowp float weight(lowp vec4 color1, lowp vec4 color2) {
  lowp float norm = length(color1 - color2);
  lowp float sigma = 0.02;
  return exp(-norm * norm / sigma);
}
