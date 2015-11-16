// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Coresponds to a texture-unit.
/// Different \c TMTextureTypes are guarenteed to correspond to different textue units, thus
/// allowing simultaneous usage.
typedef NS_ENUM(NSInteger, TMTextureType) {
  TMTextureTypeDefault,
  TMTextureTypeUniform1,
  TMTextureTypeUniform2
};

/// Wraps an openGL texture object.
@interface TMTexture : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c UIImage.
- (instancetype)initWithImage:(UIImage *)image;

/// Initializes with \c GLuint handle, \c GLenum target, \c CGSize size.
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target size:(CGSize)size
    NS_DESIGNATED_INITIALIZER;

/// Binds the texture by calling glBindTexture.
- (void)bind;

/// Binds and links the texture to \c handle by calling glUniform1i with the texture-unit
/// corresponding to \c textureType;
- (void)bindAndlinkToHandle:(GLuint)handle withTextureType:(TMTextureType)textureType;

/// Binding target of the texture.
@property (readonly, nonatomic) GLenum target;

/// Size of the texture.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
