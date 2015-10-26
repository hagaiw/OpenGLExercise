// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMProcessor.h"

@class TMTextureProgram;

NS_ASSUME_NONNULL_BEGIN

/// A processor for adjusting texture brightness, contrast, saturation, tint and temperature.
@interface TMToneTextureProcessor : NSObject <TMProcessor>

/// Types of tone-adjustments.
typedef NS_ENUM(NSInteger, ToneAdjustment) {
  ToneAdjustmentBrightness,
  ToneAdjustmentContrast,
  ToneAdjustmentSaturation,
  ToneAdjustmentTint,
  ToneAdjustmentTemperature
};

/// Initializes with \c program whos fragment shader includes a color-adjustment matrix.
- (instancetype)initWithProgram:(TMTextureProgram *)program NS_DESIGNATED_INITIALIZER;

/// Sets a new value for the given adjustment.
/// Value should be a normalized between 0 and 1. 
- (void)value:(GLfloat)value forToneAdjustment:(ToneAdjustment)toneAdjustment;

@end

NS_ASSUME_NONNULL_END
