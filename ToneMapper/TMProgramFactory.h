// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

@class TMProgram;
@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

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

/// Texture Mixing Program.
- (TMTextureProgram *)textureMixingProgram;

@end

NS_ASSUME_NONNULL_END
