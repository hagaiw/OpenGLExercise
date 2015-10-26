// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMViewController.h"
#import "TMGLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMViewController ()

/// A view controller in charge of openGL handling.
@property (strong, nonatomic) TMGLViewController *openGLVC;

/// The view to be used by \c openGLVC.
@property (weak, nonatomic) IBOutlet UIView *glview;

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
}

- (IBAction)sliderMoved:(UISlider *)sender {
  [self.openGLVC sliderMovedTo:(sender.value)];
}

- (IBAction)toneAdjustmentSelected:(UISegmentedControl *)sender {
  [self.openGLVC currentToneAdjustmentByTitle:
      [sender titleForSegmentAtIndex:sender.selectedSegmentIndex]];
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

@end

NS_ASSUME_NONNULL_END
