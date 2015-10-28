// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMUniform.h"

NS_ASSUME_NONNULL_BEGIN

/// A value class composed of a name-value pair representing a scalar program attribute.
@interface TMScalarUniform : NSObject <TMUniform>

/// Default initializer should not be called.
- (instancetype)init NS_UNAVAILABLE;

/// Initializes with the given \c name indicating the shader attribute this object is associated
/// with and the given \c value.
- (instancetype)initWithName:(NSString *)name scalar:(GLfloat)scalar;

/// Name of the attribute in the shader.
@property (readonly, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
