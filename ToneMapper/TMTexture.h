// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Wraps an openGL texture object.
@interface TMTexture : NSObject

/// Default initializer shouldn't be available.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c UIImage.
- (instancetype)initWithImage:(UIImage *)image;

/// Initializes with \c image, \c textureIndex.
- (instancetype)initWithImage:(UIImage *)image textureIndex:(GLuint)textureIndex;

/// Initializes with \c GLuint handle, \c GLenum target, \c CGSize size.
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size
                         index:(GLuint)index;

/// Binds the texture by calling glBindTexture.
- (void)bind;

/// Binds and links the texture to \c handle by calling glUniform1i;
- (void)bindAndlinkToHandle:(GLuint)handle;

/// Binds and links the texture to \c handle by calling glUniform1i with \c index;
- (void)bindAndlinkToHandle:(GLuint)handle withIndex:(GLuint)index;

/// Binding target of the texture.
@property (readonly, nonatomic) GLenum target;

/// Size of the texture.
@property (readonly, nonatomic) CGSize size;

/// OpenGL index of texture.
@property (readonly, nonatomic) GLuint index;

@end

NS_ASSUME_NONNULL_END
