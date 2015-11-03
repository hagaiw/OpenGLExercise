// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMUniform.h"

NS_ASSUME_NONNULL_BEGIN

/// GLKVector2 uniform wrapper.
@interface TMVector2DUniform : NSObject <TMUniform>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes with \c vector, \c uniform.
- (instancetype)initWithVector:(GLKVector2)vector uniform:(NSString *)uniform;

/// Vector \c name will be linked to.
@property (readonly, nonatomic) GLKVector2 vector;

@end

NS_ASSUME_NONNULL_END
