// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMScalarUniform;
@class TMHandleDictionary;

NS_ASSUME_NONNULL_BEGIN

/// Object wrapping an OpenGL program.
@interface TMProgram : NSObject

/// Initialize with attribute names \c attributes, uniform names \c uniforms, \c vertexShaderName
/// and \c fragmentShader name.
- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName;

/// Maps attribute names to \GLuint handles.
@property (readonly, nonatomic) TMHandleDictionary *handlesForAttributes;

/// Maps uniform names to \GLuint handles.
@property (readonly, nonatomic) TMHandleDictionary *handlesForUniforms;

/// Binds the given \c scalarUniform to this program.
- (void)bindScalarUniform:(TMScalarUniform *)scalarUniform;

/// Calls glUseProgram for the program.
- (void)useProgram;

@end

NS_ASSUME_NONNULL_END
