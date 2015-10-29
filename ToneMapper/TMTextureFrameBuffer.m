// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureFrameBuffer.h"
#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureFrameBuffer ()

/// \c GLuint handle of the frame buffer.
@property (readonly, nonatomic) GLuint handle;

@end

@implementation TMTextureFrameBuffer

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithSize:(CGSize)size {
  return [self initWithSize:size textureUnit:0];
}

- (instancetype)initWithSize:(CGSize)size textureUnit:(GLuint)textureUnit {
  if (self = [super init]) {
    glGenFramebuffers(1, &_handle);
    GLuint bufferTextureHandle;
    glGenTextures(1, &bufferTextureHandle);
    _texture = [[TMTexture alloc] initWithHandle:bufferTextureHandle target:GL_TEXTURE_2D
                                                size:size textureUnit:textureUnit];
    [self setupFrameBufferWithTextureHandle:bufferTextureHandle];
  }
  return self;
}

- (void)setupFrameBufferWithTextureHandle:(GLuint)handle {
  [self bind];
  glBindTexture(GL_TEXTURE_2D, handle);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.texture.size.width, self.texture.size.height, 0,
               GL_RGBA, GL_UNSIGNED_BYTE, NULL);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, handle,
                         0);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
  if(status != GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"Failed to make complete framebuffer object %x", status);
  }
}


#pragma mark -
#pragma mark TMFrameBuffer
#pragma mark -

- (void)bind {
  glBindFramebuffer(GL_FRAMEBUFFER, self.handle);
}

- (CGSize)size {
  return self.texture.size;
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  GLuint handle = self.handle;
  glDeleteFramebuffers(1, &handle);
}

@end

NS_ASSUME_NONNULL_END
