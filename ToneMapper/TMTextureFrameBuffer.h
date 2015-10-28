// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// Class representing an openGL texture backed frame-buffer.
@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

/// Initializes with \c size of the texture the frame buffer should be backed on.
/// The texture will have a default textureIndex of 0.
- (instancetype)initWithSize:(CGSize)size;

/// Initializes with \c size of the texture the frame buffer should be backed on, \c textureIndex
/// in case this texture is going to be used simultaneously with other textures.
- (instancetype)initWithSize:(CGSize)size textureIndex:(GLuint)textureIndex;

/// Binds the frame buffer.
- (void)bind;

/// Texture the frame buffer is backed on.
@property (readonly, strong, nonatomic) TMTexture *texture;

@end

NS_ASSUME_NONNULL_END
