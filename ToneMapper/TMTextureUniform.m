// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureUniform.h"

#import "TMTexture.h"
#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureUniform ()

/// Value of this uniform.
@property (readonly, strong, nonatomic) TMTexture *texture;

/// Texture unit to be enabled before binding this uniform.
@property (readonly, nonatomic) GLuint textureUnit;

@end

@implementation TMTextureUniform

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithTexture:(TMTexture *)texture name:(NSString *)name
                    textureUnit:(GLuint)textureUnit {
  if (self = [super init]) {
    _texture = texture;
    _name = name;
    _textureUnit = textureUnit;
  }
  return self;
}

#pragma mark -
#pragma mark TMUniform
#pragma mark -

- (void)linkToProgramWithHandleDictionary:(TMHandleDictionary *)handleDictionary {
  [self.texture bindAndlinkToHandle:[handleDictionary handleForKey:self.name]
                    withTextureUnit:self.textureUnit];
}

@end

NS_ASSUME_NONNULL_END
