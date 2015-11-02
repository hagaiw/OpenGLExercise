// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMTextureProgram;

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// \c TMTexture processing object.
@interface TMTextureProcessor : NSObject <TMProcessor>

/// Default initializer shouldn't be available.
- (instancetype)init NS_UNAVAILABLE;

/// Initialize with \c program to be used when processing.
- (instancetype)initWithProgram:(TMTextureProgram *)program NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
