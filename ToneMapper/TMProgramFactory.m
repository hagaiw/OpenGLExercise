// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgramFactory.h"
#import "TMProgram.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProgramFactory

/// Name of vertex shader which includes a projection uniform.
static NSString * const kPassThroughWithProjectionVertexShader =
                            @"passThroughWithProjectionVertexShader";

/// Name of a pass through fragment shader.
static NSString * const kPassThroughFragmentShader = @"passThroughFragmentShader";

/// Name of a fragment shader which allows tone adjustments.
static NSString * const kToneFragmentShader = @"toneAdjustmentFragmentShader";

/// Name of a vertex shader that performs bilateral filtering on a texture.
static NSString * const kBilateralVertexShader = @"TMBilateralVertexShader";

/// Name of a fragment shader that performs bilateral filtering on a texture.
static NSString * const kBilateralFragmentShader = @"TMBilateralFragmentShader";

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

- (TMTextureProgram *)bilateralFilterProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms]
                                                              arrayByAddingObject:@"textureDimensions"]
                                            vertexShaderName:kBilateralVertexShader
                                          fragmentShaderName:kBilateralFragmentShader];
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
