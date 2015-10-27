// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMMatrixUniform.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMMatrixUniform

@synthesize name = _name;

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithMatrix:(GLKMatrix4)matrix uniform:(NSString *)uniform {
  if (self = [super init]) {
    _matrix = matrix;
    _name = uniform;
  }
  return self;
}

#pragma mark -
#pragma mark Linking
#pragma mark -

- (void)linkToHandle:(GLuint)handle {
  glUniformMatrix4fv(handle, 1, 0, self.matrix.m);
}

@end

NS_ASSUME_NONNULL_END
