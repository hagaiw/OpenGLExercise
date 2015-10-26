// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

@class TMProgram;
@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

/// A factory class used to create new \c TMPrograms.
@interface TMProgramFactory : NSObject

/// A pass-through texture display program.
- (TMTextureProgram *)passThroughWithProjection;

/// A program that allows adjusting of brightness.
- (TMTextureProgram *)brightnessProgram;

@end

NS_ASSUME_NONNULL_END
