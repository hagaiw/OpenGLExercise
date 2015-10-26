// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Represents a \c matrix to be bound to a \uniform variable.
@interface TMMatrixUniform : NSObject

/// Initializes with \c matrix, \c uniform.
- (instancetype)initWithMatrix:(GLKMatrix4)matrix uniform:(NSString *)uniform;

@property (readonly, nonatomic) GLKMatrix4 matrix;
@property (readonly, strong, nonatomic) NSString *uniform;

@end

NS_ASSUME_NONNULL_END
