// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMViewController.h"
#import "TMGLViewController.h"
#import "TMToneAdjustmentGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMViewController ()

typedef NS_ENUM(NSInteger, ContrastType) {
  MediumContrastType,
  FineContrastType,
  NoneContrastType
};

/// A view controller in charge of openGL handling.
@property (strong, nonatomic) TMGLViewController *openGLVC;

/// The view to be used by \c openGLVC.
@property (weak, nonatomic) IBOutlet UIView *glview;

/// Object holding the values of the current tone adjustments.
@property (strong, nonatomic) TMToneAdjustmentGenerator *toneAdjustmentGenerator;

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
  self.mediumContrastValue = kDefaultToneValue;
  self.fineContrastValue = kDefaultToneValue;
  self.currentLocalContrastType = NoneContrastType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
  [self.openGLVC moveTextureWithTranslation:CGPointMake(dx*[UIScreen mainScreen].scale,
                                                        -dy*[UIScreen mainScreen].scale)
                              movementEnded:([sender state] == UIGestureRecognizerStateEnded)];
}

- (IBAction)zoomImage:(UIPinchGestureRecognizer *)sender {
  CGPoint point = [sender locationInView:self.openGLVC.view];
  
  // Convert to world coordinates.
  CGFloat pinchX = (2*point.x - (self.openGLVC.view.frame.size.width) ) /
  self.openGLVC.view.frame.size.width;
  CGFloat pinchY = (2*point.y - (self.openGLVC.view.frame.size.height) ) /
  self.openGLVC.view.frame.size.height;
  [self.openGLVC zoomImageByScale:[sender scale] zoomLocation:CGPointMake(pinchX, pinchY)
                        zoomEnded:([sender state] == UIGestureRecognizerStateEnded)];
}

- (IBAction)pickImage:(UIButton *)sender {
  UIImagePickerController *mediaUI = [UIImagePickerController new];
  mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  mediaUI.allowsEditing = NO;
  mediaUI.delegate = self;
  [self presentViewController:mediaUI animated:YES completion:nil];
  self.toneAdjustmentGenerator = [[TMToneAdjustmentGenerator alloc] init];
  self.toneAdjustmentSlider.value = 0.5;
  [self.openGLVC setToneMatrix:[self.toneAdjustmentGenerator toneMatrix]];
}

- (IBAction)sliderMoved:(UISlider *)sender {
  if (self.localContrast.selectedSegmentIndex != kDeselectedValue) {
    switch (self.currentLocalContrastType) {
      case MediumContrastType:
        self.mediumContrastValue = sender.value;
        break;
      case FineContrastType:
        self.fineContrastValue = sender.value;
        break;
      default:
        break;
    }
    [self.openGLVC createLocalContrastWithMediumWeight:self.mediumContrastValue fineWeight:self.fineContrastValue];
  } else {
    switch (self.currentToneAdjustment) {
      case ToneAdjustmentBrightness:
        self.toneAdjustmentGenerator.brightnessValue = sender.value;
        break;
      case ToneAdjustmentContrast:
        self.toneAdjustmentGenerator.contrastValue = sender.value;
        break;
      case ToneAdjustmentSaturation:
        self.toneAdjustmentGenerator.saturationValue = sender.value;
        break;
      case ToneAdjustmentTint:
        self.toneAdjustmentGenerator.tintValue = sender.value;
        break;
      case ToneAdjustmentTemperature:
        self.toneAdjustmentGenerator.temperatureValue = sender.value;
        break;
      default:
        break;
    }
    [self.openGLVC setToneMatrix:[self.toneAdjustmentGenerator toneMatrix]];
  }
}

- (IBAction)toneAdjustmentSelected:(UISegmentedControl *)sender {
  NSString *title =  ([sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
  if ([title isEqualToString:kBrightnessName]) {
    self.currentToneAdjustment = ToneAdjustmentBrightness;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.brightnessValue;
  }
  else if ([title isEqualToString:kContrastName]) {
    self.currentToneAdjustment = ToneAdjustmentContrast;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.contrastValue;
  }
  else if ([title isEqualToString:kSaturationName]) {
    self.currentToneAdjustment = ToneAdjustmentSaturation;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.saturationValue;
  }
  else if ([title isEqualToString:kTintName]) {
    self.currentToneAdjustment = ToneAdjustmentTint;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.tintValue;
  }
  else if ([title isEqualToString:kTemperatureName]) {
    self.currentToneAdjustment = ToneAdjustmentTemperature;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.temperatureValue;
  }
  self.localContrast.selectedSegmentIndex = kDeselectedValue;
  self.currentLocalContrastType = NoneContrastType;
  self.toneAdjustmentSlider.enabled = true;
}

- (IBAction)bilateralEffectSelected:(UISegmentedControl *)sender {
  NSString *title =  ([sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
  if ([title isEqualToString:kMediumContrastName]) {
    self.currentLocalContrastType = MediumContrastType;
    self.toneAdjustmentSlider.value = self.mediumContrastValue;
  }
  else if ([title isEqualToString:kFineContrastName]) {
    self.currentLocalContrastType = FineContrastType;
    self.toneAdjustmentSlider.value = self.fineContrastValue;
  }
  else {
    self.currentLocalContrastType = NoneContrastType;
  }
  self.globalTones.selectedSegmentIndex = kDeselectedValue;
  self.toneAdjustmentSlider.enabled = true;
}

- (IBAction)applyEffect:(UIButton *)sender {
  self.globalTones.selectedSegmentIndex = kDeselectedValue;
  self.localContrast.selectedSegmentIndex = kDeselectedValue;
  self.toneAdjustmentSlider.value = kDefaultToneValue;
  [self.openGLVC applyCurrentTextureState];
}

#pragma mark -
#pragma mark Image Preprocessing
#pragma mark -

- (UIImage *)prepareImage:(UIImage *)image {
  // Calculate maximum possible image dimensions and set scaling accordingly.
  NSUInteger maxTextureSize = [self.openGLVC maxTextureSize];
  NSUInteger maxDimension = image.size.height > image.size.width ? image.size.height
                                : image.size.width;
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

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
  [self dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self.openGLVC loadTextureFromImage:[self prepareImage:image]];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (TMToneAdjustmentGenerator *)toneAdjustmentGenerator {
  if (!_toneAdjustmentGenerator){
    _toneAdjustmentGenerator = [[TMToneAdjustmentGenerator alloc] init];
  }
  return _toneAdjustmentGenerator;
}

@end

NS_ASSUME_NONNULL_END
