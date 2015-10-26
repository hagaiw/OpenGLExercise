// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMShader;

NS_ASSUME_NONNULL_BEGIN

/// A factory class that produces shaders.
@interface TMShaderFactory : NSObject

/// Compiles and creates a shader with \c shaderName and \c shadertype.
/// Returns the \c GLuint handle of the shader.
- (TMShader *)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

@end

NS_ASSUME_NONNULL_END
