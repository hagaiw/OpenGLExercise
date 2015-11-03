// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMProgram;
@class TMScalarUniform;
@class TMHandleDictionary;

NS_ASSUME_NONNULL_BEGIN

/// The name of the position attribute in the vertex shader.
extern NSString * const kPositionAttribute;

/// The name of the texture coordinate attribute in the fragment shader.
extern NSString * const kTextureCoordinateAttribute;

/// The name of the texture uniform in the fragment shader.
extern NSString * const kTextureUniform;

/// The name of the projection uniform in the vertex shader.
extern NSString * const kProjectionUniform;

/// A \c TMProgram wrapper class that represents a texture-program, which displays a texture
/// and applies a projection matrix to its vertices.
/// \c Program's shaders are expected to include the "Position" and "TexCoordIn" attributes. They
/// are also expected to include the "Texture" and "Projection" uniforms.
@interface TMTextureProgram : NSObject

/// Initializes with \c TMProgram, \c textureUniform, \c projectionUniform, \c textureCoordAttribute
/// and \c positionAttribute.
- (instancetype)initWithProgram:(TMProgram *)program;

/// Binds the program using \c glUseProgram.
- (void)use;

/// Maps uniform names to handles.
- (TMHandleDictionary *)handlesForUniforms;

/// The texture uniform handle of the program.
@property (readonly, nonatomic) GLuint textureUniform;

/// The projection uniform handle of the program.
@property (readonly, nonatomic) GLuint projectionUniform;

/// The texture coordinate attribute handle of the program.
@property (readonly, nonatomic) GLuint textureCoordAttribute;

/// The position attribute handler of the program.
@property (readonly, nonatomic) GLuint positionAttribute;

@end

NS_ASSUME_NONNULL_END
