// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgramFactory.h"
#import "TMProgram.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProgramFactory

/// Name of vertex shader which includes a projection uniform.
static NSString * const kPassThroughWithProjectionVertexShader = @"TMPassThroughWithProjection";

/// Name of a pass through fragment shader.
static NSString * const kPassThroughFragmentShader = @"TMPassThrough";

/// Name of a fragment shader which allows tone adjustments.
static NSString * const kToneFragmentShader = @"TMToneAdjustment";

/// Name of a vertex shader that performs horizontal bilateral filtering on a texture.
static NSString * const kBilateralHorizontalVertexShader = @"TMBilateralHorizontal";

/// Name of a vertex shader that performs vertical bilateral filtering on a texture.
static NSString * const kBilateralVerticalVertexShader = @"TMBilateralVertical";

/// Name of a fragment shader that performs bilateral filtering on a texture.
static NSString * const kBilateralFragmentShader = @"TMBilateral";

/// Name of fragment shader that mixes 3 different textures together;
static NSString * const kMixerFragmentShader = @"TMMixing";

/// Name of a \c GLKMatrix4 uniform tone adjustment projection to be applied to the color value in
/// the fragment shader.
NSString * const kToneAdjustment = @"toneAdjustment";

/// Name of a \c GLKVector2 uniform indicating the size and width of the inputed texture.
NSString * const kTextureDimensions = @"textureDimensions";

/// Name of a uniform texture created by applying a bilateral filter with a strong blur kernel
/// to the inputed texture.
NSString * const kStrongBlurTexture = @"strongBlurTexture";

/// Name of a uniform texture created by applying a bilateral filter with a strong blur kernel
/// to the inputed texture.
NSString * const kWeakBlurTexture = @"weakBlurTexture";

/// Name of a \c GLFloat uniform indicating weight given to the fine details of the image in a local
/// contrast filter.
NSString * const kFineWeight = @"fineWeight";

/// Name of a \c GLFloat uniform indicating weight given to the medium details of the image in a
/// local contrast filter.
NSString * const kMediumWeight = @"mediumWeight";

#pragma mark -
#pragma mark Factory Methods
#pragma mark -

- (TMTextureProgram *)passThroughWithProjection {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[self defaultUniforms]
                                            vertexShaderName:kPassThroughWithProjectionVertexShader
                                          fragmentShaderName:kPassThroughFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)globalToneProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:kToneAdjustment]
                                            vertexShaderName:kPassThroughWithProjectionVertexShader
                                          fragmentShaderName:kToneFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)bilateralHorizontalFilterProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:kTextureDimensions]
                                            vertexShaderName:kBilateralHorizontalVertexShader
                                          fragmentShaderName:kBilateralFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)bilateralVerticalFilterProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:kTextureDimensions]
                                            vertexShaderName:kBilateralVerticalVertexShader
                                          fragmentShaderName:kBilateralFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)textureMixingProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObjectsFromArray:
                                                                  @[kStrongBlurTexture,
                                                                    kWeakBlurTexture,
                                                                    kFineWeight, kMediumWeight]]
                                            vertexShaderName:kPassThroughWithProjectionVertexShader
                                          fragmentShaderName:kMixerFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (NSArray *)defaultAttributes {
  return @[kPositionAttribute, kTextureCoordinateAttribute];
}

- (NSArray *)defaultUniforms {
  return @[kTextureUniform, kProjectionUniform];
}

@end

NS_ASSUME_NONNULL_END
