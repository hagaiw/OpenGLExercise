// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMToneTextureProcessor.h"

#import "TMTextureProcessor.h"
#import "TMMatrixUniform.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMToneTextureProcessor ()

@property (strong, nonatomic) TMTextureProcessor *processor;
@property (nonatomic) GLKMatrix4 brightness;
@property (nonatomic) GLKMatrix4 contrast;
@property (nonatomic) GLKMatrix4 saturation;
@property (nonatomic) GLKMatrix4 tint;
@property (nonatomic) GLKMatrix4 temperature;

@end

@implementation TMToneTextureProcessor

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithProgram:(TMTextureProgram *)program {
  if (self = [super init]) {
    self.processor = [[TMTextureProcessor alloc] initWithProgram:program];
    self.brightness = GLKMatrix4Identity;
    self.contrast = GLKMatrix4Identity;
    self.saturation = GLKMatrix4Identity;
    self.tint = GLKMatrix4Identity;
    self.temperature = GLKMatrix4Identity;
  }
  return self;
}

#pragma mark -
#pragma mark Tone Adjustments
#pragma mark -

- (void)value:(GLfloat)value forToneAdjustment:(ToneAdjustment)toneAdjustment {
  
  
  if (toneAdjustment == ToneAdjustmentBrightness) {
    value = (value * 2) - 1;
    self.brightness = GLKMatrix4Translate(GLKMatrix4Identity, value, value, value);
  }
  else if (toneAdjustment == ToneAdjustmentContrast) {
    value = (value * 2);
    self.contrast = GLKMatrix4Scale(GLKMatrix4Identity, value, value, value);
  }
  else if (toneAdjustment == ToneAdjustmentSaturation) {
    value = (value*3);
    GLKVector4 vector1 = GLKVector4Make(0.2126, 0.2126, 0.2126, 0.0);
    GLKVector4 vector2 = GLKVector4Make(0.7152, 0.7152, 0.7152, 0.0);
    GLKVector4 vector3 = GLKVector4Make(0.0722, 0.0722, 0.0722, 0.0);
    GLKVector4 vector4 = GLKVector4Make(0, 0, 0, 1.0);
    
    GLKMatrix4 grayscale = GLKMatrix4MakeWithColumns(vector1, vector2, vector3, vector4);
    
    GLKMatrix4 matrix = GLKMatrix4Scale(grayscale, 1-value, 1-value, 1-value);
    matrix = GLKMatrix4Add(GLKMatrix4Scale(GLKMatrix4Identity, value, value, value), matrix);
    self.saturation = matrix;
  }
  else if (toneAdjustment == ToneAdjustmentTint) {
    value = ((value * 2) - 1)/2;
    GLKMatrix4 matrix = GLKMatrix4Scale(GLKMatrix4Identity, 1-value, 1-value, 1-value);
    self.tint = GLKMatrix4Translate(matrix, value, value, value);
  }
  else if (toneAdjustment == ToneAdjustmentTemperature) {
    value = ((value * 2) - 1)/3;
    self.temperature = GLKMatrix4Translate(GLKMatrix4Identity, value, 0.0, -value);
  }
}

#pragma mark -
#pragma mark TMProcessor
#pragma mark -

- (TMTexture *)processTexture:(TMTexture *)texture {
  return [self.processor processTexture:texture withMatrixUniforms:@[[self toneMatrix]]];
}

- (TMTexture *)processTexture:(TMTexture *)texture
           withMatrixUniforms:(NSArray *)matrixUniforms {
  return [self.processor processTexture:texture withMatrixUniforms:[matrixUniforms arrayByAddingObject:[self toneMatrix]]];
}

- (TMMatrixUniform *)toneMatrix {
  GLKMatrix4 matrix = GLKMatrix4Identity;
  matrix = GLKMatrix4Multiply(self.brightness, matrix);
  matrix = GLKMatrix4Multiply(self.contrast, matrix);
  matrix = GLKMatrix4Multiply(self.saturation, matrix);
  matrix = GLKMatrix4Multiply(self.tint, matrix);
  matrix = GLKMatrix4Multiply(self.temperature, matrix);
  return [[TMMatrixUniform alloc] initWithMatrix:matrix uniform:@"toneAdjustment"];
}

@end

NS_ASSUME_NONNULL_END
