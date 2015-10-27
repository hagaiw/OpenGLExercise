// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// Class representing an openGL texture backed frame-buffer.
@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

/// Initializes with \c size of the texture the frame buffer should be backed on.
- (instancetype)initWithSize:(CGSize)size;

/// Binds the frame buffer.
- (void)bind;

/// Texture the frame buffer is backed on.
@property (readonly, strong, nonatomic) TMTexture *texture;

@end

NS_ASSUME_NONNULL_END
