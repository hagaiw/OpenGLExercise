// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMGLViewController.h"
#import "TMTexture.h"
#import "TMGeometryFactory.h"
#import "TMProgramFactory.h"
#import "TMTextureProcessorFactory.h"
#import "TMPositionFactory.h"
#import "TMTextureFrameBuffer.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMTextureDisplay.h"
#import "TMScalarUniform.h"
#import "TMTextureProcessor.h"
#import "TMScaledPosition.h"
#import "TMTextureProgram.h"
#import "TMProjectionFactory.h"
#import "TMMatrixUniform.h"
#import "TMVector2DUniform.h"
#import "TMTextureUniform.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLViewController ()

/// Display that presents the processed texture in a scrollable manner.
@property (strong, nonatomic) TMTextureDisplay *display;

/// \c TMTexture representation of the image after applying the most recent filter.
@property (strong, nonatomic) TMTexture *inputTexture;

/// \c TMTexture representation of the image after changing the most recent filter.
@property (strong, nonatomic) TMTexture *processedTexture;

/// Preprocessed \c TMTexture created by applying a bilateral filter with a strong blur to the
/// loaded image.
@property (strong, nonatomic) TMTexture *strongBlurTexture;

/// Preprocessed \c TMTexture created by applying a bilateral filter with a weak blur to the
/// loaded image.
@property (strong, nonatomic) TMTexture *weakBlurTexture;

/// The position and scale of the currently displayed \c TMTexture on screen.
@property (strong, nonatomic) TMScaledPosition *textureScaledPosition;

/// Used to save the original scaledPosition while a transformation (scale or translation) is
/// ongoing.
@property (strong, nonatomic) TMScaledPosition *tempTextureScaledPosition;

/// Factor object used to produce \c TMPrograms.
@property (strong, nonatomic) TMProgramFactory *programFactory;

// Factory object used to produce \c TMTexturedGeometries.
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

// Factory object used to produce \c TMTextureProcessors.
@property (strong, nonatomic) TMTextureProcessorFactory *processorFactory;

// Factory object used to produce \c TMScaledPositions.
@property (strong, nonatomic) TMPositionFactory *positionFactory;

// Factory object used to produce \c GLKMatrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// \c GLKView used by this \c UIViewController.
@property (strong, nonatomic) GLKView *glkView;

/// OpenGL context;
@property (strong, nonatomic) EAGLContext *context;

/// The current tone-adjustment mode.
//@property (nonatomic) ToneAdjustment currentToneAdjustment;

@end

@implementation TMGLViewController

/// Value of bitsPerComponent to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerComponent = 8;

/// Value of bitsPerPixel to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerPixel = 32;

/// Number of passes used to create a weakly blured \c inputTexture.
static const int kWeakBlurPassesNumber = 2;

/// Number of passes used to create a strongly blured \c inputTexture.
static const int kStrongBlurPassesNumber = 7;

/// Texture unit for strongly blurred texture.
static const int kStrongTextureUnit = 1;

/// Texture unit for weakly blurred texture.
static const int kWeakTextureUnit = 2;

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.programFactory = [[TMProgramFactory alloc] init];
  self.geometryFactory = [[TMGeometryFactory alloc] init];
  self.processorFactory = [[TMTextureProcessorFactory alloc] init];
  self.positionFactory = [[TMPositionFactory alloc] init];
  self.projectionFactory = [[TMProjectionFactory alloc] init];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  self.textureScaledPosition = [self.positionFactory defaultPosition];
  self.tempTextureScaledPosition = self.textureScaledPosition;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self.glkView removeFromSuperview];
  self.glkView = [GLKView new];
  self.glkView.delegate = self;
  self.glkView.context = self.context;
  self.glkView.opaque = NO;
  self.glkView.frame = self.view.frame;
  [self.view addSubview:self.glkView];
  self.display = [[TMTextureDisplay alloc]
                  initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc]
                                       initWithGLKView:self.glkView]
                  program:[self.programFactory passThroughWithProjection]
                  geometry:[self.geometryFactory quadGeometry]];
}

#pragma mark -
#pragma mark GLKView Delegate
#pragma mark -

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.2, 0.0, 0.2, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);

  [self.display displayTexture:self.processedTexture scaledPosition:self.textureScaledPosition
                matrixUniforms:@[[[TMMatrixUniform alloc]
                                  initWithMatrix:[self.projectionFactory
                                                  verticalMirrorProjection]
                                  uniform:kProjectionUniform]]];
}

#pragma mark -
#pragma mark User Interaction
#pragma mark -

- (void)loadTextureFromImage:(UIImage *)image {
  self.inputTexture = [[TMTexture alloc] initWithImage:image];
  self.strongBlurTexture = [self texture:self.inputTexture
        AfterBilateralWithNumberOfPasses:kStrongBlurPassesNumber];
  self.weakBlurTexture = [self texture:self.inputTexture
      AfterBilateralWithNumberOfPasses:kWeakBlurPassesNumber];
  self.processedTexture = self.inputTexture;
  [self.glkView setNeedsDisplay];
}

- (void)moveTextureWithTranslation:(CGPoint)translation
                     movementEnded:(BOOL)movementEnded {
  TMScaledPosition *positionDelta = [self.positionFactory positionWithTranslation:translation];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:movementEnded];
}

- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
               zoomEnded:(BOOL)zoomEnded {
  TMScaledPosition *positionDelta = [self.positionFactory positionWithScale:scale];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:zoomEnded];
}

- (void)updateTexturePositionWithPosition:(TMScaledPosition *)position
                             gestureEnded:(BOOL)gestureEnded{
  self.textureScaledPosition = [self.tempTextureScaledPosition
                                    scaledPositionWithDeltaScaledPosition:position];
  if (gestureEnded) {
    self.tempTextureScaledPosition = self.textureScaledPosition;
  }
  [self.glkView setNeedsDisplay];
}

- (void)setToneMatrix:(GLKMatrix4)toneMatrix {
  TMMatrixUniform *toneMatrixUniform = [[TMMatrixUniform alloc] initWithMatrix:toneMatrix
                                                                       uniform:kToneAdjustment];
  TMTextureProcessor *processor = [[TMTextureProcessor alloc]
                                          initWithProgram:[self.programFactory globalToneProgram]];
  self.processedTexture = [processor processTexture:self.inputTexture
                                            withUniforms:@[toneMatrixUniform]];
  [self.glkView setNeedsDisplay];
}

- (void)createLocalContrastWithMediumWeight:(GLfloat)mediumWeight fineWeight:(GLfloat)fineWeight {
  TMTextureProgram *mixerProgram = [self.programFactory textureMixingProgram];
  id<TMProcessor> processor = [self.processorFactory processorWithProgram:mixerProgram];
  TMScalarUniform *mediumWeightUniform = [[TMScalarUniform alloc] initWithName:kMediumWeight
                                                                  scalar:mediumWeight];
  TMScalarUniform *fineWeightMedium = [[TMScalarUniform alloc] initWithName:kFineWeight
                                                                  scalar:fineWeight];
  TMTextureUniform *strongTextureUniform = [[TMTextureUniform alloc]
                                  initWithTexture:self.strongBlurTexture
                                             name:kStrongBlurTexture
                                      textureUnit:kStrongTextureUnit];
  TMTextureUniform *weakTextureUniform = [[TMTextureUniform alloc]
                                  initWithTexture:self.weakBlurTexture
                                             name:kWeakBlurTexture textureUnit:kWeakTextureUnit];
  self.processedTexture = [processor processTexture:self.inputTexture
                                            withUniforms:@[strongTextureUniform, weakTextureUniform, mediumWeightUniform, fineWeightMedium]];
  [self.glkView setNeedsDisplay];
}

- (void)applyCurrentTextureState {
  self.inputTexture = self.processedTexture;
  [self.glkView setNeedsDisplay];
}

- (TMTexture *)texture:(TMTexture *)texture
      AfterBilateralWithNumberOfPasses:(NSUInteger)numberOfPasses {
  TMTextureProgram *horizontalBilateral = [self.programFactory bilateralHorizontalFilterProgram];
  TMTextureProgram *verticalBilateral = [self.programFactory bilateralVerticalFilterProgram];
  TMTextureProcessor *bilateralProcessor = [self.processorFactory
                                   processorWithPrograms:@[horizontalBilateral,
                                                           verticalBilateral]];
  id<TMProcessor> multipassBilateralProcessor = [self.processorFactory
                                                 multipassProcessorFromProcessor:bilateralProcessor
                                                                  numberOfPasses:numberOfPasses];
  GLKVector2 vector = GLKVector2Make(texture.size.width, texture.size.height);
  TMVector2DUniform *vectorUniform = [[TMVector2DUniform alloc] initWithVector:vector
                                                                       uniform:kTextureDimensions];
  return [multipassBilateralProcessor processTexture:texture withUniforms:@[vectorUniform]];
}

-(void)saveProcessedTexture {
  UIImage *image = [self imageFromTexture:self.processedTexture];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

// Taken from: http://www.bit-101.com/blog/?p=1861
-(UIImage *) imageFromTexture:(TMTexture *)texture {
  
  // Bind and draw to a framebuffer with the given texture.
  TMTextureDisplay *displayer =
      [[TMTextureDisplay alloc] initWithFrameBuffer:[[TMTextureFrameBuffer alloc]
                                                        initWithSize:texture.size]
                                            program:[self.programFactory passThroughWithProjection]
                                           geometry:[self.geometryFactory quadGeometry]];
  [displayer displayTexture:texture scaledPosition:[self.positionFactory defaultPosition] matrixUniforms:@[]];
  
  
  NSInteger myDataLength = texture.size.width * texture.size.height * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, texture.size.width, texture.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
  
  // prep the ingredients
  int bytesPerRow = 4 * texture.size.width;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(texture.size.width, texture.size.height, kBitsPerComponent,
                                          kBitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo,
                                          provider, NULL, NO, renderingIntent);
  
  // then make the uiimage from that
  UIImage *myImage = [UIImage imageWithCGImage:imageRef];
  return myImage;
}

- (NSUInteger)maxTextureSize {
  int maxTextureSize;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  return (NSUInteger)maxTextureSize;
}

@end

NS_ASSUME_NONNULL_END
