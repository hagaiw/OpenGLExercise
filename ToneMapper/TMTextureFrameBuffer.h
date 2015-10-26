// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// A class representing an openGL texture backed frame-buffer.
@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

/// Initializes with \c size of the texture the frame buffer should be backed on.
- (instancetype)initWithSize:(CGSize)size;

/// Bind the frame buffer.
- (void)bind;

/// The texture the frame buffer is backed on.
@property (readonly, strong, nonatomic) TMTexture *texture;

@end

NS_ASSUME_NONNULL_END
