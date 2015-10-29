// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProjectionFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProjectionFactory

#pragma mark -
#pragma mark Factory Methods
#pragma mark -

- (GLKMatrix4)identityProjection {
  return GLKMatrix4Identity;
}

- (GLKMatrix4)projectionByMultiplyingLeft:(GLKMatrix4)left
                                        right:(GLKMatrix4)right {
  return GLKMatrix4Multiply(left, right);
}

- (GLKMatrix4)projectionFitSize:(CGSize)origin inSize:(CGSize)target {
  GLfloat targetRatio = target.height / target.width;
  GLfloat originRatio = origin.height / origin.width;
  GLfloat fitRatio = 1.0;
  if (targetRatio > originRatio) {
    fitRatio = target.width / origin.width;
  } else {
    fitRatio = target.height / origin.height;
  }
  GLfloat xRatio = fitRatio * origin.width / target.width;
  GLfloat yRatio = fitRatio * origin.height / target.height;
  return GLKMatrix4Scale(GLKMatrix4Identity, xRatio, yRatio, 1.0);
}

- (GLKMatrix4)translationProjectionWithX:(GLfloat)x y:(GLfloat)y {
  return GLKMatrix4Translate(GLKMatrix4Identity, x, y, 0.0);
}

- (GLKMatrix4)scaleProjectionWithScale:(GLfloat)scale {
  return GLKMatrix4Scale(GLKMatrix4Identity, scale, scale, 1.0);
}

- (GLKMatrix4)verticalMirrorProjection {
  return GLKMatrix4Scale(GLKMatrix4Identity, 1.0, -1.0, 1.0);
}

@end

NS_ASSUME_NONNULL_END
