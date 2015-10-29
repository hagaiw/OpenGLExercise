// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.
#import "TMScalarUniform.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMScalarUniform

#pragma mark -
#pragma mark Initialization
#pragma mark -

@synthesize value = _value;
@synthesize name = _name;

- (instancetype)initWithName:(NSString *)name value:(GLfloat)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
