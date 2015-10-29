// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgramFactory.h"
#import "TMProgram.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProgramFactory

/// Name of vertex shader which includes a projection uniform.
static NSString * const kPassThroughWithProjectionVertexShader =
                            @"TMPassThroughWithProjectionVertexShader";

/// Name of a pass through fragment shader.
static NSString * const kPassThroughFragmentShader = @"TMPassThroughFragmentShader";

/// Name of a fragment shader which allows tone adjustments.
static NSString * const kToneFragmentShader = @"TMToneAdjustmentFragmentShader";

/// Name of a vertex shader that performs horizontal bilateral filtering on a texture.
static NSString * const kBilateralHorizontalVertexShader = @"TMBilateralHorizontalVertexShader";

/// Name of a vertex shader that performs vertical bilateral filtering on a texture.
static NSString * const kBilateralVerticalVertexShader = @"TMBilateralVerticalVertexShader";

/// Name of a fragment shader that performs bilateral filtering on a texture.
static NSString * const kBilateralFragmentShader = @"TMBilateralFragmentShader";

/// Name of frament shader that mixes 3 different textures together;
static NSString * const kMixerFragmentShader = @"TMMixingFragmentShader";

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
                                                              arrayByAddingObject:@"toneAdjustment"]
                                            vertexShaderName:kPassThroughWithProjectionVertexShader
                                          fragmentShaderName:kToneFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)bilateralHorizontalFilterProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:@"textureDimensions"]
                                            vertexShaderName:kBilateralHorizontalVertexShader
                                          fragmentShaderName:kBilateralFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)bilateralVerticalFilterProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:@"textureDimensions"]
                                            vertexShaderName:kBilateralVerticalVertexShader
                                          fragmentShaderName:kBilateralFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)textureMixingProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObjectsFromArray:
                                                                  @[@"texture2", @"texture3", @"alpha1", @"alpha2"]]
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
