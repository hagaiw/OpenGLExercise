// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMToneAdjustmentGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMToneAdjustmentGenerator ()

/// Brightness adjustment matrix.
@property (nonatomic) GLKMatrix4 brightness;

/// Brightness contrast matrix.
@property (nonatomic) GLKMatrix4 contrast;

/// Brightness saturation matrix.
@property (nonatomic) GLKMatrix4 saturation;

/// Brightness tint matrix.
@property (nonatomic) GLKMatrix4 tint;

/// Brightness temperature matrix.
@property (nonatomic) GLKMatrix4 temperature;

@end

@implementation TMToneAdjustmentGenerator

static const float kDefaultToneAdjustmentValue = 0.5;

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.brightnessValue = kDefaultToneAdjustmentValue;
    self.contrastValue = kDefaultToneAdjustmentValue;
    self.saturationValue = kDefaultToneAdjustmentValue;
    self.tintValue = kDefaultToneAdjustmentValue;
    self.temperatureValue = kDefaultToneAdjustmentValue;
    self.brightness = GLKMatrix4Identity;
    self.contrast = GLKMatrix4Identity;
    self.saturation = GLKMatrix4Identity;
    self.tint = GLKMatrix4Identity;
    self.temperature = GLKMatrix4Identity;
  }
  return self;
}

#pragma mark -
#pragma mark Matrix Generation
#pragma mark -

- (GLKMatrix4)toneMatrix {
  GLKMatrix4 toneMatrix = GLKMatrix4Identity;
  toneMatrix = GLKMatrix4Multiply(self.brightness, toneMatrix);
  toneMatrix = GLKMatrix4Multiply(self.contrast, toneMatrix);
  toneMatrix = GLKMatrix4Multiply(self.saturation, toneMatrix);
  toneMatrix = GLKMatrix4Multiply(self.tint, toneMatrix);
  toneMatrix = GLKMatrix4Multiply(self.temperature, toneMatrix);
  return toneMatrix;
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setBrightnessValue:(GLfloat)brightnessValue {
  _brightnessValue = brightnessValue;
  GLfloat value = (brightnessValue * 2) - 1;
  self.brightness = GLKMatrix4Translate(GLKMatrix4Identity, value, value, value);
}

- (void)setContrastValue:(GLfloat)contrastValue {
  _contrastValue = contrastValue;
  GLfloat value = contrastValue*2;
  self.contrast = GLKMatrix4Scale(GLKMatrix4Identity, value, value, value);
}

- (void)setSaturationValue:(GLfloat)saturationValue {
  _saturationValue = saturationValue;
  GLfloat value = saturationValue * 2;
  GLKVector4 vector1 = GLKVector4Make(0.2126, 0.2126, 0.2126, 0.0);
  GLKVector4 vector2 = GLKVector4Make(0.7152, 0.7152, 0.7152, 0.0);
  GLKVector4 vector3 = GLKVector4Make(0.0722, 0.0722, 0.0722, 0.0);
  GLKVector4 vector4 = GLKVector4Make(0, 0, 0, 1.0);
  GLKMatrix4 grayscale = GLKMatrix4MakeWithColumns(vector1, vector2, vector3, vector4);
  GLKMatrix4 matrix = GLKMatrix4Scale(grayscale, 1-value, 1-value, 1-value);
  matrix = GLKMatrix4Add(GLKMatrix4Scale(GLKMatrix4Identity, value, value, value), matrix);
  self.saturation = matrix;
}

- (void)setTintValue:(GLfloat)tintValue {
  _tintValue = tintValue;
  GLfloat value = ((tintValue * 2) - 1)/2;
  self.tint = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, value, 0.0);
}

- (void)setTemperatureValue:(GLfloat)temperatureValue {
  _temperatureValue = temperatureValue;
  GLfloat value = ((temperatureValue * 2) - 1)/3;
  self.temperature = GLKMatrix4Translate(GLKMatrix4Identity, value, 0.0, -value);
}

@end

NS_ASSUME_NONNULL_END
