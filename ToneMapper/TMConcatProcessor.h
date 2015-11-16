// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// Processor that connects multiple processors together into a processing pipeline.
@interface TMConcatProcessor : NSObject <TMProcessor>

- (instancetype)init NS_UNAVAILABLE;

/// A \c TMTexture processor that applies the given \c processors in order.
- (instancetype)initWithProcessors:(NSArray *)processors;

@end

NS_ASSUME_NONNULL_END
