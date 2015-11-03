// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

@class TMProgram;
@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

/// Name of a \c GLKMatrix4 uniform tone adjustment projection to be applied to the color value in
/// the fragment shader.
extern NSString * const kToneAdjustment;

/// Name of a \c GLKVector2 uniform indicating the size and width of the input texture.
extern NSString * const kTextureDimensions;

/// Name of a uniform texture created by applying a bilateral filter with a strong blur kernel
/// to the inputed texture.
extern NSString * const kStrongBlurTexture;

/// Name of a uniform texture created by applying a bilateral filter with a strong blur kernel
/// to the inputed texture.
extern NSString * const kWeakBlurTexture;

/// Name of a \c GLFloat uniform indicating weight given to the fine details of the image in a local
/// contrast filter.
extern NSString * const kFineWeight;

/// Name of a \c GLFloat uniform indicating weight given to the medium details of the image in a
/// local contrast filter.
extern NSString * const kMediumWeight;

/// Factory class used to create new \c TMPrograms.
@interface TMProgramFactory : NSObject

/// Pass-through texture display program.
- (TMTextureProgram *)passThroughWithProjection;

/// Program that allows adjusting of brightness.
- (TMTextureProgram *)globalToneProgram;

/// Bilateral horizontal filter program.
- (TMTextureProgram *)bilateralHorizontalFilterProgram;

/// Bilateral vertical filter program.
- (TMTextureProgram *)bilateralVerticalFilterProgram;

/// Texture Mixing Program that mixes the inputed texture with 2 others given by uniforms.
- (TMTextureProgram *)textureMixingProgram;

@end

NS_ASSUME_NONNULL_END
