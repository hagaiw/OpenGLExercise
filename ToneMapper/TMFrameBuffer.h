// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Protocol that should be implemented by openGL wrapping objects.
@protocol TMFrameBuffer <NSObject>

/// Binds the frame buffer.
- (void)bind;

/// Size of the frame-buffer.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
