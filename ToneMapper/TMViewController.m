// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMViewController.h"
#import "TMGLViewController.h"
#import "TMToneAdjustmentGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMViewController ()

/// Types of local, contrast tone-adjustments.
typedef NS_ENUM(NSInteger, ContrastType) {
  ContrastTypeMedium,
  ContrastTypeFine,
  ContrastTypeNone
};

/// Types of tone-adjustments.
typedef NS_ENUM(NSInteger, ToneAdjustment) {
  ToneAdjustmentBrightness,
  ToneAdjustmentContrast,
  ToneAdjustmentSaturation,
  ToneAdjustmentTint,
  ToneAdjustmentTemperature,
  ToneAdjustmentNone
};

/// A view controller in charge of openGL handling.
@property (strong, nonatomic) TMGLViewController *openGLVC;

/// The view to be used by \c openGLVC.
@property (weak, nonatomic) IBOutlet UIView *glview;

/// Tone adjustment that the slider affects.
@property (nonatomic) ToneAdjustment currentToneAdjustment;

/// Slider controlling the current adjustment.
@property (weak, nonatomic) IBOutlet UISlider *toneAdjustmentSlider;

/// Currently selected local contrast.
@property (nonatomic) ContrastType currentLocalContrastType;

/// Current value of the fine contrast filter.
@property (nonatomic) GLfloat fineContrastValue;

/// Current value of the medium contrast filter.
@property (nonatomic) GLfloat mediumContrastValue;

/// Global tones segmented controller.
@property (weak, nonatomic) IBOutlet UISegmentedControl *globalTones;

/// Local contrast segmented controller.
@property (weak, nonatomic) IBOutlet UISegmentedControl *localContrast;

/// Current brightness adjustment value.
@property (nonatomic) GLfloat brightnessValue;

/// Current contrast adjustment value.
@property (nonatomic) GLfloat contrastValue;

/// Current saturation adjustment value.
@property (nonatomic) GLfloat saturationValue;

/// Current tint adjustment value.
@property (nonatomic) GLfloat tintValue;

/// Current temperature adjustment value.
@property (nonatomic) GLfloat temperatureValue;

@end

@implementation TMViewController

/// Default scale of a loaded image.
static const float kDefaultImageScale = 1.0;

/// Default tone value.
static const float kDefaultToneValue = 0.5;

/// Segmented controller deselected value.
static const int kDeselectedValue = -1;

/// Brightness tonal filter name.
static NSString * const kBrightnessName = @"Brightness";

/// Brightness tonal filter name.
static NSString * const kContrastName = @"Contrast";

/// Brightness tonal filter name.
static NSString * const kSaturationName = @"Saturation";

/// Brightness tonal filter name.
static NSString * const kTintName = @"Tint";

/// Brightness tonal filter name.
static NSString * const kTemperatureName = @"Temperature";

/// Brightness tonal filter name.
static NSString * const kMediumContrastName = @"Medium";

/// Brightness tonal filter name.
static NSString * const kFineContrastName = @"Fine";

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  self.openGLVC = [[TMGLViewController alloc] init];
  [self addChildViewController:self.openGLVC];
  self.openGLVC.view.frame = self.glview.frame;
  [self.glview addSubview:self.openGLVC.view];
  [self.openGLVC didMoveToParentViewController:self];
  [self resetAdjustments];
}

- (void)resetAdjustments {
  self.mediumContrastValue = kDefaultToneValue;
  self.fineContrastValue = kDefaultToneValue;
  self.currentLocalContrastType = ContrastTypeNone;
  self.currentToneAdjustment = ToneAdjustmentNone;
  self.brightnessValue = kDefaultToneValue;
  self.contrastValue = kDefaultToneValue;
  self.saturationValue = kDefaultToneValue;
  self.tintValue = kDefaultToneValue;
  self.temperatureValue = kDefaultToneValue;
}

#pragma mark -
#pragma mark UIButton
#pragma mark -

- (IBAction)saveImage:(UIButton *)sender {
  [self.openGLVC saveProcessedTexture];
}

- (IBAction)moveImage:(UIPanGestureRecognizer *)sender {
  GLfloat dx = [sender translationInView:self.openGLVC.view].x /
      self.openGLVC.view.frame.size.width;
  GLfloat dy = [sender translationInView:self.openGLVC.view].y /
      self.openGLVC.view.frame.size.height;
  [self.openGLVC moveTextureWithTranslation:CGPointMake(dx * [UIScreen mainScreen].scale,
                                                        -dy * [UIScreen mainScreen].scale)
                               gestureState:([sender state] == UIGestureRecognizerStateEnded ?
                                             TMGestureStateEnded : TMGestureStateOngoing)];
}

- (IBAction)zoomImage:(UIPinchGestureRecognizer *)sender {
  CGPoint point = [sender locationInView:self.openGLVC.view];
  
  // Convert to world coordinates.
  CGFloat pinchX = (2*point.x - (self.openGLVC.view.frame.size.width) ) /
      self.openGLVC.view.frame.size.width;
  CGFloat pinchY = (2*point.y - (self.openGLVC.view.frame.size.height) ) /
      self.openGLVC.view.frame.size.height;
  [self.openGLVC zoomImageByScale:[sender scale] zoomLocation:CGPointMake(pinchX, pinchY)
                     gestureState:([sender state] == UIGestureRecognizerStateEnded ?
                                   TMGestureStateEnded : TMGestureStateOngoing) ];
}

- (IBAction)pickImage:(UIButton *)sender {
  UIImagePickerController *mediaPickerController = [[UIImagePickerController alloc] init];
  mediaPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  mediaPickerController.allowsEditing = NO;
  mediaPickerController.delegate = self;
  [self presentViewController:mediaPickerController animated:YES completion:nil];
  self.toneAdjustmentSlider.value = kDefaultToneValue;
  [self resetAdjustments];
  [self.openGLVC setToneAdjustmentWithBrightness:self.brightnessValue contrast:self.contrastValue
                                      saturation:self.saturationValue tint:self.tintValue
                                     temperature:self.temperatureValue];
}

- (IBAction)sliderMoved:(UISlider *)sender {
  if (self.localContrast.selectedSegmentIndex != kDeselectedValue) {
    switch (self.currentLocalContrastType) {
      case ContrastTypeMedium:
        self.mediumContrastValue = sender.value;
        break;
      case ContrastTypeFine:
        self.fineContrastValue = sender.value;
        break;
      case ContrastTypeNone:
        break;
    }
    [self.openGLVC setLocalContrastWithMediumWeight:self.mediumContrastValue
                                         fineWeight:self.fineContrastValue];
  } else {
    switch (self.currentToneAdjustment) {
      case ToneAdjustmentBrightness:
        self.brightnessValue = sender.value;
        break;
      case ToneAdjustmentContrast:
        self.contrastValue = sender.value;
        break;
      case ToneAdjustmentSaturation:
        self.saturationValue = sender.value;
        break;
      case ToneAdjustmentTint:
        self.tintValue = sender.value;
        break;
      case ToneAdjustmentTemperature:
        self.temperatureValue = sender.value;
        break;
      case ToneAdjustmentNone:
        break;
    }
    [self.openGLVC setToneAdjustmentWithBrightness:self.brightnessValue contrast:self.contrastValue
                                        saturation:self.saturationValue tint:self.tintValue
                                       temperature:self.temperatureValue];
  }
}

- (IBAction)toneAdjustmentSelected:(UISegmentedControl *)sender {
  NSString *title =  ([sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
  if ([title isEqualToString:kBrightnessName]) {
    self.currentToneAdjustment = ToneAdjustmentBrightness;
    self.toneAdjustmentSlider.value = self.brightnessValue;
  }
  else if ([title isEqualToString:kContrastName]) {
    self.currentToneAdjustment = ToneAdjustmentContrast;
    self.toneAdjustmentSlider.value = self.contrastValue;
  }
  else if ([title isEqualToString:kSaturationName]) {
    self.currentToneAdjustment = ToneAdjustmentSaturation;
    self.toneAdjustmentSlider.value = self.saturationValue;
  }
  else if ([title isEqualToString:kTintName]) {
    self.currentToneAdjustment = ToneAdjustmentTint;
    self.toneAdjustmentSlider.value = self.tintValue;
  }
  else if ([title isEqualToString:kTemperatureName]) {
    self.currentToneAdjustment = ToneAdjustmentTemperature;
    self.toneAdjustmentSlider.value = self.temperatureValue;
  }
  self.localContrast.selectedSegmentIndex = kDeselectedValue;
  self.currentLocalContrastType = ContrastTypeNone;
  self.toneAdjustmentSlider.enabled = true;
}

- (IBAction)bilateralEffectSelected:(UISegmentedControl *)sender {
  NSString *title =  ([sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
  if ([title isEqualToString:kMediumContrastName]) {
    self.currentLocalContrastType = ContrastTypeMedium;
    self.toneAdjustmentSlider.value = self.mediumContrastValue;
  }
  else if ([title isEqualToString:kFineContrastName]) {
    self.currentLocalContrastType = ContrastTypeFine;
    self.toneAdjustmentSlider.value = self.fineContrastValue;
  }
  else {
    self.currentLocalContrastType = ContrastTypeNone;
  }
  self.globalTones.selectedSegmentIndex = kDeselectedValue;
  self.currentToneAdjustment = ToneAdjustmentNone;
  self.toneAdjustmentSlider.enabled = true;
}

- (IBAction)applyEffect:(UIButton *)sender {
  [self.openGLVC applyCurrentTextureState];
  [self resetAdjustments];
  self.globalTones.selectedSegmentIndex = kDeselectedValue;
  self.localContrast.selectedSegmentIndex = kDeselectedValue;
  self.toneAdjustmentSlider.value = kDefaultToneValue;
}

#pragma mark -
#pragma mark Image Preprocessing
#pragma mark -

- (UIImage *)prepareImage:(UIImage *)image {
  // Calculate maximum possible image dimensions and set scaling accordingly.
  NSUInteger maxTextureSize = [self.openGLVC maxTextureSize];
  NSUInteger maxDimension =
      image.size.height > image.size.width ? image.size.height : image.size.width;
  GLfloat imageScale = kDefaultImageScale;
  if (maxDimension > maxTextureSize) {
    imageScale = (GLfloat)maxTextureSize / maxDimension;
  }
  
  // Fix image orientation scale, if needed.
  UIGraphicsBeginImageContextWithOptions(image.size, NO, imageScale);
  [image drawInRect:(CGRect){0, 0, image.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

#pragma mark -
#pragma mark UIImagePickerController Delegate
#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self.openGLVC loadTextureFromImage:[self prepareImage:image]];
}

@end

NS_ASSUME_NONNULL_END
