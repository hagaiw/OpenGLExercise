// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A class used to generate color-projections that apply brightness, contrast,
/// saturation, tint and temperature adjustments.
@interface TMToneAdjustmentGenerator : NSObject

/// Types of tone-adjustments.
typedef NS_ENUM(NSInteger, ToneAdjustment) {
  ToneAdjustmentBrightness,
  ToneAdjustmentContrast,
  ToneAdjustmentSaturation,
  ToneAdjustmentTint,
  ToneAdjustmentTemperature,
  ToneAdjustmentNone
};

/// Tone matrix representing all the tone adjustments set in this generator.
- (GLKMatrix4)toneMatrix;

/// Normalized brightness value between 0 and 1.
@property (nonatomic) GLfloat brightnessValue;

/// Normalized contrast value between 0 and 1.
@property (nonatomic) GLfloat contrastValue;

/// Normalized saturation value between 0 and 1.
@property (nonatomic) GLfloat saturationValue;

/// Normalized tint value between 0 and 1.
@property (nonatomic) GLfloat tintValue;

/// Normalized temperature value between 0 and 1.
@property (nonatomic) GLfloat temperatureValue;

@end

NS_ASSUME_NONNULL_END
