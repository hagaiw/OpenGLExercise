// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

/// A wrapper for the \c GLKView class that allows it to be treated as a frame-buffer.
@interface TMGLKViewFrameBuffer : NSObject <TMFrameBuffer>

/// Initializes with \c glkView.
- (instancetype)initWithGLKView:(GLKView *)glkView;

@end

NS_ASSUME_NONNULL_END
