// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A factory calss the produces \c GLKMatrix4 projections.
@interface TMProjectionFactory : NSObject

/// Returns a \c GLKMatrix4 projection that fits an object of size \c origin inside an object of
/// size \c target.
- (GLKMatrix4)projectionFitSize:(CGSize)origin inSize:(CGSize)target;

/// Returns a \TMProjection resulting from multiplying \c left by \c right.
- (GLKMatrix4)projectionByMultiplyingLeft:(GLKMatrix4)left right:(GLKMatrix4)right;

/// Returns the identity projection.
- (GLKMatrix4)identityProjection;

/// Returns a \c GLKMatrix4 projection that mirros along the vertical (y) axis.
- (GLKMatrix4)verticalMirrorProjection;

/// Returns a \c GLKMatrix4 projection which translates by \c x and \c y.
- (GLKMatrix4)translationProjectionWithX:(GLfloat)x y:(GLfloat)y;

/// Returns a \c GLKMatrix4 projection which scales the x and y axis by \c scale.
- (GLKMatrix4)scaleProjectionWithScale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
