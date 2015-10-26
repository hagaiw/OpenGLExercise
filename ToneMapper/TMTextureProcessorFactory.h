// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

@class TMTextureProcessor;
@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

/// A factory class that produces \c TMTextureProcessor objects.
@interface TMTextureProcessorFactory : NSObject

/// Returns a \c TMTextureProcessor with the given \c TMTexturePRogram.
- (TMTextureProcessor *)processorWithProgram:(TMTextureProgram *)program;

@end

NS_ASSUME_NONNULL_END
