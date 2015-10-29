// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMUniform.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents a \c matrix to be bound to a uniform variable.
@interface TMMatrixUniform : NSObject <TMUniform>

/// Default initializer should not be called.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c matrix, \c name.
- (instancetype)initWithMatrix:(GLKMatrix4)matrix uniform:(NSString *)uniform;

/// Matrix \c name will be linked to.
@property (readonly, nonatomic) GLKMatrix4 matrix;

@end

NS_ASSUME_NONNULL_END
