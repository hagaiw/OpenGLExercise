// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMScalarUniform.h"

#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMScalarUniform

#pragma mark -
#pragma mark Initialization
#pragma mark -

@synthesize scalar = _scalar;
@synthesize name = _name;

- (instancetype)init {
  return nil;
}

- (instancetype)initWithName:(NSString *)name scalar:(GLfloat)scalar {
  if (self = [super init]) {
    _name = name;
    _scalar = scalar;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
