// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Protocol for OpenGL uniform variable wrappers.
@protocol TMUniform <NSObject>

/// Name of this uniform variable as it appears in the shader.
@property (readonly, strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
