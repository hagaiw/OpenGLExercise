// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTexture ()

/// Handle of the openGL texture;
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMTexture

/// Default texture unit to use.
static const NSInteger defaultTextureUnit = 0;

/// Texture unit to use for uniform variable textures #1.
static const NSInteger uniformTextureUnit1 = 1;

/// Texture unit to use for uniform variable textures #2.
static const NSInteger uniformTextureUnit2 = 2;

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)init {
  return nil;
}

- (instancetype)initWithImage:(UIImage *)image {
  glActiveTexture(GL_TEXTURE0);
  NSError *textureLoaderError;
  
  // Read the current openGL error, if exists, to address an issue where \c GLKTextureLoader
  // returns nil if such error is not read.
  glGetError();
  GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[image CGImage] options:nil error:&textureLoaderError];
  return [self initWithHandle:info.name target:info.target
                         size:CGSizeMake(info.width, info.height)];
}

- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size {
  if (self = [super init]) {
    _handle = handle;
    _target = target;
    _size = size;
  }
  return self;
}

- (GLuint)textureUnitFromTextureType:(TMTextureType)textureType {
  switch (textureType) {
    case TMTextureTypeDefault:
      return defaultTextureUnit;
      break;
    case TMTextureTypeUniform1:
      return uniformTextureUnit1;
    case TMTextureTypeUniform2:
      return uniformTextureUnit2;
    default:
      break;
  }
}

#pragma mark -
#pragma mark OpenGL
#pragma mark -

- (void)bind {
  glBindTexture(self.target, self.handle);
}

- (void)bindAndlinkToHandle:(GLuint)handle withTextureType:(TMTextureType)textureType {
  glActiveTexture(GL_TEXTURE0 + [self textureUnitFromTextureType:textureType]);
  [self bind];
  glUniform1i(handle, [self textureUnitFromTextureType:textureType]);
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  GLuint textureHandle = self.handle;
  glDeleteTextures(1, &textureHandle);
}

@end

NS_ASSUME_NONNULL_END
