// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMTextureProgram;

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// A \c TMTexture processing object.
@interface TMTextureProcessor : NSObject <TMProcessor>

/// Default initializer shouldn't be available.
- (instancetype)init NS_UNAVAILABLE;

/// Initialize with \c TMTextureProgram to be used whenprocessing.
- (instancetype)initWithProgram:(TMTextureProgram *)program NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
