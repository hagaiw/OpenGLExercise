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

/// Initializes with \c GLuint handle, \c GLenum target, \c CGSize size.
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size;

/// Binds the texture by calling glBindTexture.
- (void)bind;

/// Binding target of the texture.
@property (readonly, nonatomic) GLenum target;

/// Size of the texture.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
