// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMToneAdjustmentGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMToneAdjustmentGenerator

#pragma mark -
#pragma mark Tone Adjustment Matrix Generators
#pragma mark -

- (GLKMatrix4)toneMatrixForBrightness:(GLfloat)brightness {
  GLfloat value = (brightness * 2) - 1;
  return GLKMatrix4Translate(GLKMatrix4Identity, value, value, value);
}

- (GLKMatrix4)toneMatrixForContrast:(GLfloat)contrast {
  GLfloat value = contrast * 2;
  return GLKMatrix4Scale(GLKMatrix4Identity, value, value, value);
}

- (GLKMatrix4)toneMatrixForSaturation:(GLfloat)saturation {
  GLfloat value = saturation * 2;
  GLKVector4 vector1 = GLKVector4Make(0.2126, 0.2126, 0.2126, 0.0);
  GLKVector4 vector2 = GLKVector4Make(0.7152, 0.7152, 0.7152, 0.0);
  GLKVector4 vector3 = GLKVector4Make(0.0722, 0.0722, 0.0722, 0.0);
  GLKVector4 vector4 = GLKVector4Make(0, 0, 0, 1.0);
  GLKMatrix4 grayscale = GLKMatrix4MakeWithColumns(vector1, vector2, vector3, vector4);
  GLKMatrix4 matrix = GLKMatrix4Scale(grayscale, 1-value, 1-value, 1-value);
  return GLKMatrix4Add(GLKMatrix4Scale(GLKMatrix4Identity, value, value, value), matrix);
}

- (GLKMatrix4)toneMatrixForTint:(GLfloat)tint {
  GLfloat value = ((tint * 2) - 1)/7;
  return GLKMatrix4Translate(GLKMatrix4Identity, 0.0, value, 0.0);
}

- (GLKMatrix4)toneMatrixForTemperature:(GLfloat)temperature {
  GLfloat value = ((temperature * 2) - 1)/6;
  return GLKMatrix4Translate(GLKMatrix4Identity, value, 0.0, -value);
}

@end

NS_ASSUME_NONNULL_END
