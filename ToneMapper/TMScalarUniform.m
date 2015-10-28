// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMScalarUniform.h"

#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMScalarUniform ()

/// Value of the attribute.
@property (readonly, nonatomic) GLfloat scalar;

@end

@implementation TMScalarUniform

#pragma mark -
#pragma mark Initialization
#pragma mark -

@synthesize scalar = _scalar;
@synthesize name = _name;

- (instancetype)initWithName:(NSString *)name scalar:(GLfloat)scalar {
  if (self = [super init]) {
    _name = name;
    _scalar = scalar;
  }
  return self;
}

#pragma mark -
#pragma mark TMUniform
#pragma mark -

- (void)linkToProgramWithHandleDictionary:(TMHandleDictionary *)handleDictionary {
  glUniform1f([handleDictionary handleForKey:self.name], self.scalar);
}

@end

NS_ASSUME_NONNULL_END
