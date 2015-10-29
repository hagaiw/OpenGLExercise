// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMMatrixUniform.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMMatrixUniform

- (instancetype)initWithMatrix:(GLKMatrix4)matrix uniform:(NSString *)uniform {
  if (self = [super init]) {
    _matrix = matrix;
    _uniform = uniform;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
