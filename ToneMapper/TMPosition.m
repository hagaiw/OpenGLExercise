//
//  TMDisplayData.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMPosition.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMPosition

- (instancetype)initWithTranslation:(CGPoint)translation scale:(CGFloat)scale {
  if (self = [super init]) {
    _tranlsation = translation;
    _scale = scale;
  }
  return self;
}

- (TMPosition *)poistionByAddingPosition:(TMPosition *)position {
  return [[TMPosition alloc]
          initWithTranslation:CGPointMake(self.tranlsation.x + position.tranlsation.x,
                                          self.tranlsation.y + position.tranlsation.y)
          scale:self.scale * position.scale];
}

@end

NS_ASSUME_NONNULL_END
