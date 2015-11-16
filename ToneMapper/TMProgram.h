// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMScalarUniform;
@class TMHandleDictionary;

NS_ASSUME_NONNULL_BEGIN

/// Wrapper for an OpenGL program.
@interface TMProgram : NSObject

/// Initializes with attribute names \c attributes, uniform names \c uniforms, \c vertexShaderName
/// and \c fragmentShader name.
- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName;

/// Maps attribute names to \GLuint handles.
@property (readonly, nonatomic) TMHandleDictionary *handlesForAttributes;

/// Maps uniform names to \GLuint handles.
@property (readonly, nonatomic) TMHandleDictionary *handlesForUniforms;

/// Calls glUseProgram for this program.
- (void)useProgram;

/// Sets the the value of this program's uniforms according to the given \c uniforms.
/// Uniforms is an \c NSArray of \c TMUniforms.
- (void)useProgramWithUniforms:(NSArray *)uniforms;


@end

NS_ASSUME_NONNULL_END
