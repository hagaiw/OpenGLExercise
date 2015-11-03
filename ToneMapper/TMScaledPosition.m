// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMScaledPosition.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMScaledPosition

- (instancetype)initWithTranslation:(CGPoint)translation scale:(CGFloat)scale {
  if (self = [super init]) {
    _translation = translation;
    _scale = scale;
  }
  return self;
}

- (TMScaledPosition *)scaledPositionWithDeltaScaledPosition:(TMScaledPosition *)scaledPosition {
  return [[TMScaledPosition alloc]
          initWithTranslation:CGPointMake(self.translation.x + scaledPosition.translation.x,
                                          self.translation.y + scaledPosition.translation.y)
          scale:self.scale * scaledPosition.scale];
}

@end

NS_ASSUME_NONNULL_END
