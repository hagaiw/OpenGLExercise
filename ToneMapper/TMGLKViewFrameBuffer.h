// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

/// A wrapper for the \c GLKView class that allows it to be treated as a frame-buffer.
@interface TMGLKViewFrameBuffer : NSObject <TMFrameBuffer>

/// Default initializer should not be called.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c glkView.
- (instancetype)initWithGLKView:(GLKView *)glkView NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
