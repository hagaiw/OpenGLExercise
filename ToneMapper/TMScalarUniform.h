// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A value class composed of a name-value pair representing a scalar program attribute.
@interface TMScalarUniform : NSObject

/// Initializes with \c name, \c value.
- (instancetype)initWithName:(NSString *)name value:(GLfloat)value;

/// Name of the attribute in the shader.
@property (readonly, nonatomic) NSString *name;

/// Value of the attribute.
@property (readonly, nonatomic) GLfloat value;

@end

NS_ASSUME_NONNULL_END
