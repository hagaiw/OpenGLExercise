// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Wraps an openGL shader.
@interface TMShader : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c shaderName, \c shaderType and compile the shader.
- (instancetype)initWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

/// Handle of the wrapped shader.
@property (readonly, nonatomic) GLuint handle;

@end

NS_ASSUME_NONNULL_END
