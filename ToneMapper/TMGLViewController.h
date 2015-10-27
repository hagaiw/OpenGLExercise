// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// \c UIViewController responsible of loading, processing, displaying and saving of images.
@interface TMGLViewController : UIViewController <GLKViewDelegate>

/// Converts the given \c UIImage into a \c TMTexture and sets it as the input for the processing
/// pipeline.
- (void)loadTextureFromImage:(UIImage *)image;

/// Saves the \c TMTexture outputed from the processing pipeline to disk.
- (void)saveProcessedTexture;

/// Applies the given \c translation to the displayed \c TMTexture.
/// \c movementEnded indicates whether the given translation resulted from an ongoing movement.
- (void)moveTextureWithTranslation:(CGPoint)translation movementEnded:(BOOL)movementEnded;

/// Applies the given scale factor to the displayed \c TMTexture.
/// \c zoomLocation is used to preserver the relative position of the presented \c TMTexture
/// on the screen.
- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
               zoomEnded:(BOOL)zoomEnded;

/// The maximum texture size allowed.
- (NSUInteger)maxTextureSize;

/// TODO: document
- (void)setToneMatrix:(GLKMatrix4)toneMatrix;

/// TODO: document
- (void)useBilateralFilter;

@end

NS_ASSUME_NONNULL_END
