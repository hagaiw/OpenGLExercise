// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMTextureProgram;

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// Processes a texture by applying a shader program to it.
@interface TMTextureProcessor : NSObject <TMProcessor>

- (instancetype)init NS_UNAVAILABLE;

/// Initialize with \c program to be used when processing.
- (instancetype)initWithProgram:(TMTextureProgram *)program NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
