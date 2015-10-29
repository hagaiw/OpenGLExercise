// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// Class representing an openGL texture backed frame-buffer.
@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

/// Initializes with \c size of the texture the frame buffer should be backed on.
/// The texture will have a default texture-unit of 0.
- (instancetype)initWithSize:(CGSize)size;

/// Initializes with \c size of the texture the frame buffer should be backed on, \c textureUnit to
/// use when binding thix texture.
- (instancetype)initWithSize:(CGSize)size textureUnit:(GLuint)textureUnit;

/// Binds the frame buffer.
- (void)bind;

/// Texture the frame buffer is backed on.
@property (readonly, strong, nonatomic) TMTexture *texture;

@end

NS_ASSUME_NONNULL_END
