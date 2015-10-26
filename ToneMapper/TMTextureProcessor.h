// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMTextureProgram;

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// A \c TMTexture processing object.
@interface TMTextureProcessor : NSObject <TMProcessor>

/// Initializes default properties of the \c TMTextureProcessor.
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Initialize with \c TMTextureProgram to be used whenprocessing.
- (instancetype)initWithProgram:(TMTextureProgram *)program;

/// Binds the given \c matrix to the the given \c uniform.
- (void)bindMatrix:(GLKMatrix4)matrix toUniform:(NSString *)uniform;

@end

NS_ASSUME_NONNULL_END
