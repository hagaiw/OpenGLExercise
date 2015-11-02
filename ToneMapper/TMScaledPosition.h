// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Value class holding translation and scale parameters.
@interface TMScaledPosition : NSObject

/// Initializes with \c translation, \c scale.
- (instancetype)initWithTranslation:(CGPoint)translation scale:(CGFloat)scale;

/// Creates a new \c TMScaledPosition by adding the translation values and multiplying the scale
/// values of the current and the given \c TMScaledPosition objects.
- (TMScaledPosition *)scaledPositionWithDeltaScaledPosition:(TMScaledPosition *)scaledPosition;

/// Translation value.
@property (readonly, nonatomic) CGPoint translation;

/// Scale value.
@property (readonly, nonatomic) CGFloat scale;

@end

NS_ASSUME_NONNULL_END
