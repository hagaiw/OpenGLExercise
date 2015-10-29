// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// \c UIViewController responsible of loading, processing, displaying and saving of images.
@interface TMGLViewController : UIViewController <GLKViewDelegate>

/// Loads the given \c image into the workspace.
- (void)loadTextureFromImage:(UIImage *)image;

/// Saves the image currently displayed to disk.
- (void)saveProcessedTexture;

/// Applies the given translation to the displayed image.
/// \c movementEnded indicates whether the current translation process ended or is still ongoing.
- (void)moveTextureWithTranslation:(CGPoint)translation movementEnded:(BOOL)movementEnded;

/// Applies a scale transformation with the given \c scale to the x and y axis.
/// \c zoomLocation is the centroid around which the zoom operation should occur.
/// \c zoomEnded indicates whether the zoom operation has ended or is still ongoing.
- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
               zoomEnded:(BOOL)zoomEnded;

/// The maximum dimension size of for an image to be loaded as a texture.
- (NSUInteger)maxTextureSize;

/// Applies the given toneMatrix to the image's color values.
- (void)setToneMatrix:(GLKMatrix4)toneMatrix;

/// Applies a local contrast filter to the image, with \c mediumWeight and \c fineWight indicating
/// the intensity of the medium and fine details in the result.
- (void)createLocalContrastWithMediumWeight:(GLfloat)mediumWeight fineWeight:(GLfloat)fineWeight;

/// Applies the current state to be the input for subsequent editing operations.
/// If not called, switching between features will result in loss of work.
- (void)applyCurrentTextureState;

@end

NS_ASSUME_NONNULL_END
