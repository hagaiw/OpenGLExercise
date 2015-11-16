// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureUniform.h"

#import "TMTexture.h"
#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTextureUniform

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithTexture:(TMTexture *)texture name:(NSString *)name
                    textureType:(TMTextureType)textureType {
  if (self = [super init]) {
    _texture = texture;
    _name = name;
    _textureType = textureType;
  }
  return self;
}
@end

NS_ASSUME_NONNULL_END
