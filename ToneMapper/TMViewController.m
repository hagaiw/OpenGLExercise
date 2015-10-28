// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMViewController.h"
#import "TMGLViewController.h"
#import "TMToneAdjustmentGenerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMViewController ()

/// A view controller in charge of openGL handling.
@property (strong, nonatomic) TMGLViewController *openGLVC;

/// The view to be used by \c openGLVC.
@property (weak, nonatomic) IBOutlet UIView *glview;

/// Holds the values of the current tone adjustments.
@property (strong, nonatomic) TMToneAdjustmentGenerator *toneAdjustmentGenerator;

/// Tone adjustment that the slider affects.
@property (nonatomic) ToneAdjustment currentToneAdjustment;

/// Slider controlling the current adjustment.
@property (weak, nonatomic) IBOutlet UISlider *toneAdjustmentSlider;

/// Indicates whether bilateral contrast filter is active.
@property (nonatomic) BOOL bilateralActive;

@property (nonatomic) GLfloat fineBlurAlpha;
@property (nonatomic) GLfloat midBlurAlpha;

@end

@implementation TMViewController

/// The default scale of a loaded image.
static const float kDefaultImageScale = 1.0;

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
  self.bilateralActive = true;
  self.midBlurAlpha = 1.0;
  self.fineBlurAlpha = 1.0;
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
  if (self.bilateralActive) {
    [self.openGLVC useBilateralFilterWithAlpha1:sender.value alpha2:0.0];
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
  if ([title isEqualToString:@"Brightness"]) {
    self.currentToneAdjustment = ToneAdjustmentBrightness;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.brightnessValue;
  }
  else if ([title isEqualToString:@"Contrast"]) {
    self.currentToneAdjustment = ToneAdjustmentContrast;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.contrastValue;
  }
  else if ([title isEqualToString:@"Saturation"]) {
    self.currentToneAdjustment = ToneAdjustmentSaturation;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.saturationValue;
  }
  else if ([title isEqualToString:@"Tint"]) {
    self.currentToneAdjustment = ToneAdjustmentTint;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.tintValue;
  }
  else if ([title isEqualToString:@"Temperature"]) {
    self.currentToneAdjustment = ToneAdjustmentTemperature;
    self.toneAdjustmentSlider.value = self.toneAdjustmentGenerator.temperatureValue;
  }
}

- (IBAction)BilateralEffectSelected:(UISegmentedControl *)sender {
  
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
