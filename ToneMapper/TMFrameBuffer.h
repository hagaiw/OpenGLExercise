// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Protocol that should be implemented by bindable framebuffer objects.
@protocol TMFrameBuffer <NSObject>

/// Binds the framebuffer.
- (void)bind;

/// Size of the framebuffer.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
