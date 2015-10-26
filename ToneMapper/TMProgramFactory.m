// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgramFactory.h"
#import "TMProgram.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProgramFactory

/// The name of a vertex shader which includes a projection uniform.
static NSString * const kPassThroughWithProjectionVertexShader =
                            @"passThroughWithProjectionVertexShader";

/// The name of a pass through fragment shader.
static NSString * const kPassThroughFragmentShader = @"passThroughFragmentShader";

/// The name of a fragment shader which allows brightness adjustment.
static NSString * const kBrightnessFragmentShader = @"brightnessFragmentShader";

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

- (TMTextureProgram *)brightnessProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[[self defaultUniforms] arrayByAddingObject:@"toneAdjustment"]
                                            vertexShaderName:kPassThroughWithProjectionVertexShader
                                          fragmentShaderName:kBrightnessFragmentShader];
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
