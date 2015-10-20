//
//  TMTextureParameter.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/14/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMScalarAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMScalarAttribute

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithName:(NSString *)name value:(GLfloat)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
