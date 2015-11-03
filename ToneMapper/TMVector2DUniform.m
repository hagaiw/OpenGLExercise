// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMVector2DUniform.h"
#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMVector2DUniform

@synthesize name = _name;

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithVector:(GLKVector2)vector uniform:(NSString *)name {
  if (self = [super init]) {
    _vector = vector;
    _name = name;
  }
  return self;
}

#pragma mark -
#pragma mark TMUniform
#pragma mark -

- (void)linkToProgramWithHandleDictionary:(TMHandleDictionary *)handleDictionary {
  glUniform2fv([handleDictionary handleForKey:self.name], 1, self.vector.v);
}

@end

NS_ASSUME_NONNULL_END
