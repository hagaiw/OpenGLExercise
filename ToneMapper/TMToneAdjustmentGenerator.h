// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A class used to generate color-projections that apply brightness, contrast,
/// saturation, tint and temperature adjustments.
@interface TMToneAdjustmentGenerator : NSObject

/// Brightness tone matrix for normalized brightness values (0-1).
- (GLKMatrix4)toneMatrixForBrightness:(GLfloat)brightness;

/// Contrast tone matrix for normalized brightness values (0-1).
- (GLKMatrix4)toneMatrixForContrast:(GLfloat)contrast;

/// Saturation tone matrix for normalized brightness values (0-1).
- (GLKMatrix4)toneMatrixForSaturation:(GLfloat)saturation;

/// Tint tone matrix for normalized brightness values (0-1).
- (GLKMatrix4)toneMatrixForTint:(GLfloat)tint;

/// Temperature tone matrix for normalized brightness values (0-1).
- (GLKMatrix4)toneMatrixForTemperature:(GLfloat)temperature;

@end

NS_ASSUME_NONNULL_END
