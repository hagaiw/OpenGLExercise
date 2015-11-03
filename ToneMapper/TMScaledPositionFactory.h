// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMScaledPosition;

NS_ASSUME_NONNULL_BEGIN

/// Factory providing \c TMScaledPosition objects.
@interface TMScaledPositionFactory : NSObject

/// Returns the default \c TMScaledPosition with translation of 0 and scale of 1 on both axis.
- (TMScaledPosition *)defaultPosition;

/// Returns the default \c TMScaledPosition with the given \c translation.
- (TMScaledPosition *)positionWithTranslation:(CGPoint)translation;

/// Returns the default \c TMScaledPosition with the given \c scale.
- (TMScaledPosition *)positionWithScale:(GLfloat)scale;

/// Returns a \c TMScaledPosition with the given \c translation and \c scale.
- (TMScaledPosition *)positionWithTranslation:(CGPoint)trasnlation scale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
