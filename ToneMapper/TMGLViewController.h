// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// \c UIViewController responsible of loading, processing, displaying and saving of images.
@interface TMGLViewController : UIViewController

/// States of gestures.
typedef NS_ENUM(NSInteger, TMGestureState) {
  TMGestureStateStarted,
  TMGestureStateOngoing,
  TMGestureStateEnded
};

/// Loads the given \c image into the workspace.
- (void)loadTextureFromImage:(UIImage *)image;

/// Saves the image currently displayed to disk.
- (void)saveProcessedTexture;

/// Applies the given \c translation to the currently displayed image.
/// \c gestureState is the current state of the translation gesture.
- (void)moveTextureWithTranslation:(CGPoint)translation gestureState:(TMGestureState)gestureState;

/// Applies a scale transformation with the given \c scale to the x and y axis.
/// \c zoomLocation is the centroid around which the zoom operation should occur.
/// \c gestureState is the current state of the zoom gesture.
- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
            gestureState:(TMGestureState)gestureState;

/// The maximum allowed texture-dimension size.
- (NSUInteger)maxTextureSize;

/// Sets the \c brightness, \c contrast, \c stauration, \c tint and \c temperature values of the
/// tone adjustment that is applied to the presented texture.
- (void)setToneAdjustmentWithBrightness:(GLfloat)brightness contrast:(GLfloat)contrast
                             saturation:(GLfloat)saturation tint:(GLfloat)tint
                            temperature:(GLfloat)temperature;

/// Applies a local contrast filter to the image, with \c mediumWeight and \c fineWight indicating
/// the intensity of the medium and fine details in the result.
- (void)setLocalContrastWithMediumWeight:(GLfloat)mediumWeight fineWeight:(GLfloat)fineWeight;

/// Applies the current state to be the input for subsequent editing operations.
/// If not called, switching between features will result in loss of work.
- (void)applyCurrentTextureState;

@end

NS_ASSUME_NONNULL_END
