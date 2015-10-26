// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTexture

@synthesize handle = _handle;
@synthesize target = _target;
@synthesize size = _size;

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)initWithImage:(UIImage *)image {
  if (self = [super init]) {
    glActiveTexture(GL_TEXTURE0);
    NSError *textureLoaderError;
    
    // Read the current openGL error, if exists, to address an issue where \c GLKTextureLoader
    // returns nil if such error is not read.
    glGetError();
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[image CGImage] options:nil error:&textureLoaderError];
    self = [self initWithHandle:info.name target:info.target
                           size:CGSizeMake(info.width, info.height)];
  }
  return self;
}

- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size {
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


#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  GLuint textureHandle = self.handle;
  glDeleteTextures(1, &textureHandle);
}

@end

NS_ASSUME_NONNULL_END
