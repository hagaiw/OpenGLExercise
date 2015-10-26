// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Wraps an openGL texture object.
@interface TMTexture : NSObject

/// Initializes with \c UIImage.
- (instancetype)initWithImage:(UIImage *)image;

/// Initialize with \c GLuint handle, \c GLenum target, \c CGSize size.
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size;

/// Bind the texture by calling glBindTexture.
- (void)bind;

/// The handle of the openGL texture;
@property (readonly, nonatomic) GLuint handle;

/// The binding target of the texture.
@property (readonly, nonatomic) GLenum target;

/// The \c CGSize size of the texture.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
