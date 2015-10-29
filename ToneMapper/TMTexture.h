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

/// Initializes with \c image, \c textureUnit.
- (instancetype)initWithImage:(UIImage *)image textureUnit:(GLuint)textureUnit;

/// Initializes with \c GLuint handle, \c GLenum target, \c CGSize size.
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size
                   textureUnit:(GLuint)textureUnit;

/// Binds the texture by calling glBindTexture.
- (void)bind;

/// Binds and links the texture to \c handle by calling glUniform1i with the default \c textureUnit;
- (void)bindAndlinkToHandle:(GLuint)handle;

/// Binds and links the texture to \c handle by calling glUniform1i with \c unit;
- (void)bindAndlinkToHandle:(GLuint)handle withTextureUnit:(GLuint)textureUnit;

/// Binding target of the texture.
@property (readonly, nonatomic) GLenum target;

/// Size of the texture.
@property (readonly, nonatomic) CGSize size;

/// The default texture-unit to use when binding this texture.
@property (readonly, nonatomic) GLuint textureUnit;

@end

NS_ASSUME_NONNULL_END
