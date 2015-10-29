// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMConcatProcessor : NSObject <TMProcessor>

/// Default initializer shouldn't be available.
- (instancetype)init NS_UNAVAILABLE;

/// A \c TMTexture processor that applies the given \c processors in order.
- (instancetype)initWithProcsessors:(NSArray *)processors;

@end

NS_ASSUME_NONNULL_END
