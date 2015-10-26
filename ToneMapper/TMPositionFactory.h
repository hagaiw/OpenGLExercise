// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMScaledPosition;

NS_ASSUME_NONNULL_BEGIN

@interface TMPositionFactory : NSObject

/// Returns the default \c TMPosition.
- (TMScaledPosition *)defaultPosition;

/// Returns the default \c TMPosition with the given \c translation.
- (TMScaledPosition *)positionWithTranslation:(CGPoint)translation;

/// Returns the default \c TMPosition with the given \c scale.
- (TMScaledPosition *)positionWithScale:(GLfloat)scale;

/// Returns a \c TMPosition with the given \c translation.
- (TMScaledPosition *)positionWithTranslation:(CGPoint)trasnlation scale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
