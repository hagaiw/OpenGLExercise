// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureUniform.h"

#import "TMTexture.h"
#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureUniform ()

@property (readonly, strong, nonatomic) TMTexture *texture;
@property (readonly, nonatomic) GLuint index;

@end

@implementation TMTextureUniform

- (instancetype)initWithTexture:(TMTexture *)texture name:(NSString *)name index:(GLuint)index {
  if (self = [super init]) {
    _texture = texture;
    _name = name;
    _index = index;
  }
  return self;
}

- (void)linkToProgramWithHandleDictionary:(TMHandleDictionary *)handleDictionary {
  [self.texture bindAndlinkToHandle:[handleDictionary handleForKey:self.name] withIndex:self.index];
}

@end

NS_ASSUME_NONNULL_END
