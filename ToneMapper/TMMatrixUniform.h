// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMUniform.h"

NS_ASSUME_NONNULL_BEGIN

/// \c GLKMatrix4 uniform wrapper.
@interface TMMatrixUniform : NSObject <TMUniform>

/// Default initializer should not be called.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c matrix, \c name.
- (instancetype)initWithMatrix:(GLKMatrix4)matrix uniform:(NSString *)uniform;

/// Value of matrix uniform.
@property (readonly, nonatomic) GLKMatrix4 matrix;

@end

NS_ASSUME_NONNULL_END
