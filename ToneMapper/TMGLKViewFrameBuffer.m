// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMGLKViewFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLKViewFrameBuffer ()

/// Wrapped \c GLKView.
@property (readonly, strong, nonatomic) GLKView *glkView;

/// Size of the glkView's display in pixels.
@property (readonly, nonatomic) CGSize screenSize;

@end

@implementation TMGLKViewFrameBuffer

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)init {
  return nil;
}

- (instancetype)initWithGLKView:(GLKView *)glkView {
  if (self = [super init]) {
    _glkView = glkView;
    _screenSize = CGSizeMake(self.glkView.frame.size.width*[UIScreen mainScreen].scale,
                                self.glkView.frame.size.height*[UIScreen mainScreen].scale);
  }
  return self;
}

#pragma mark -
#pragma mark TMFrameBuffer
#pragma mark -

- (void)bind {
  [self.glkView bindDrawable];
}

- (CGSize)size {
  return self.screenSize;
}

@end

NS_ASSUME_NONNULL_END
