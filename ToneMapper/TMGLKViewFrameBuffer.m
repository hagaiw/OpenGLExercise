// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMGLKViewFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLKViewFrameBuffer ()

/// The wrapped \c GLKView.
@property (strong, nonatomic) GLKView *glkView;

/// The size of the glkView's display in pixels.
@property (nonatomic) CGSize screenSize;

@end

@implementation TMGLKViewFrameBuffer

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithGLKView:(GLKView *)glkView {
  if (self = [super init]) {
    self.glkView = glkView;
    self.screenSize = CGSizeMake(self.glkView.frame.size.width*[UIScreen mainScreen].scale,
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
