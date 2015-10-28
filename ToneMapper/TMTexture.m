// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTexture ()

/// Handle of the openGL texture;
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMTexture

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)initWithImage:(UIImage *)image {
  return [self initWithImage:image textureIndex:0];
}

- (instancetype)initWithImage:(UIImage *)image textureIndex:(GLuint)textureIndex {
  glActiveTexture(GL_TEXTURE0 + textureIndex);
  NSError *textureLoaderError;
  
  // Read the current openGL error, if exists, to address an issue where \c GLKTextureLoader
  // returns nil if such error is not read.
  glGetError();
  GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[image CGImage] options:nil error:&textureLoaderError];
  return [self initWithHandle:info.name target:info.target
                         size:CGSizeMake(info.width, info.height) index:textureIndex];
}

- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size
                         index:(GLuint)index{
  if (self = [super init]) {
    _handle = handle;
    _target = target;
    _size = size;
  }
  return self;
}

#pragma mark -
#pragma mark OpenGL
#pragma mark -

- (void)bind {
  glBindTexture(self.target, self.handle);
}

- (void)bindAndlinkToHandle:(GLuint)handle {
  [self bindAndlinkToHandle:handle withIndex:self.index];
}

- (void)bindAndlinkToHandle:(GLuint)handle withIndex:(GLuint)index {
  glActiveTexture(GL_TEXTURE0 + index);
  [self bind];
  glUniform1i(handle, index);
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
