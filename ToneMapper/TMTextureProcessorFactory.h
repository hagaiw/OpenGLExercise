// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

@protocol TMProcessor;
@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

/// Factory class that produces \c TMTextureProcessor objects.
@interface TMTextureProcessorFactory : NSObject

/// \c TMProcessor that uses the given \c program.
- (id<TMProcessor>)processorWithProgram:(TMTextureProgram *)program;

/// \c TMProcessor that uses the given \c programs in-order.
- (id<TMProcessor>)processorWithPrograms:(NSArray *)programs;

/// \c TMProcessor that applies the given \c processor \c numberOfPasses times.
- (id<TMProcessor>)multipassProcessorFromProcessor:(id<TMProcessor>)processor
                                    numberOfPasses:(NSUInteger)numberOfPasses;

@end

NS_ASSUME_NONNULL_END
