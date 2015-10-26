// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMPositionFactory.h"
#import "TMScaledPosition.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMPositionFactory

/// The default scale factor used when no scale is specified.
static const GLfloat kDefaultScale = 1.0;

- (TMScaledPosition *)defaultPosition {
  return [self positionWithTranslation:CGPointZero scale:kDefaultScale];
}

- (TMScaledPosition *)positionWithTranslation:(CGPoint)translation {
  return [self positionWithTranslation:translation scale:kDefaultScale];
}

- (TMScaledPosition *)positionWithScale:(GLfloat)scale {
  return [self positionWithTranslation:CGPointZero scale:scale];
}

- (TMScaledPosition *)positionWithTranslation:(CGPoint)trasnlation scale:(GLfloat)scale {
  return [[TMScaledPosition alloc] initWithTranslation:trasnlation scale:scale];
}


@end

NS_ASSUME_NONNULL_END
