// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMGeometryFactory.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMGLViewController.h"
#import "TMMatrixUniform.h"
#import "TMPositionFactory.h"
#import "TMProgramFactory.h"
#import "TMProjectionFactory.h"
#import "TMScalarUniform.h"
#import "TMScaledPosition.h"
#import "TMTexture.h"
#import "TMTextureDisplay.h"
#import "TMTextureFrameBuffer.h"
#import "TMTextureProcessor.h"
#import "TMTextureProcessorFactory.h"
#import "TMTextureProgram.h"
#import "TMTextureUniform.h"
#import "TMToneAdjustmentGenerator.h"
#import "TMVector2DUniform.h"
#import "TMTextureSaver.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMGLViewController () <GLKViewDelegate>

/// Display that presents the processed texture in a scrollable manner.
@property (strong, nonatomic) TMTextureDisplay *display;

/// Texture to be used as input for texture-processors.
@property (strong, nonatomic) TMTexture *inputTexture;

/// Texture result of applying a texture-processor to \c inputTexture.
@property (strong, nonatomic) TMTexture *processedTexture;

/// Uniform referencing a texture being the result of applying a strong bilateral blur to
/// \c inputTexture.
@property (strong, nonatomic) TMTextureUniform *strongBlurTextureUniform;

/// Uniform referencing a texture being the result of applying a strong bilateral blur to
/// \c inputTexture.
@property (strong, nonatomic) TMTextureUniform *weakBlurTextureUniform;

/// Position and scale of the currently displayed \c TMTexture on screen.
@property (strong, nonatomic) TMScaledPosition *currentTextureScaledPosition;

/// Used to save the original scaledPosition while a transformation (scale or translation) is
/// ongoing.
@property (strong, nonatomic) TMScaledPosition *startingTextureScaledPosition;

/// Factor object used to produce \c TMPrograms.
@property (strong, nonatomic) TMProgramFactory *programFactory;

/// Factory object used to produce \c TMTexturedGeometries.
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

/// Factory object used to produce \c TMTextureProcessors.
@property (strong, nonatomic) TMTextureProcessorFactory *processorFactory;

/// Factory object used to produce \c TMScaledPositions.
@property (strong, nonatomic) TMPositionFactory *positionFactory;

/// Factory object used to produce \c GLKMatrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// GLKView used by this \c UIViewController.
@property (strong, nonatomic) GLKView *glkView;

/// OpenGL context;
@property (strong, nonatomic) EAGLContext *context;

/// Object generating matrix transformations for brightness, contrast, saturation, tint and
/// temperature tone adjustments.
@property (strong, nonatomic) TMToneAdjustmentGenerator *toneAdjustmentGenerator;

/// Processor for local contrast tone adjustments.
@property (strong, nonatomic) id<TMProcessor> localContrastProcessor;

/// Processor for global tone adjustments.
@property (strong, nonatomic) id<TMProcessor> globalTonesProcessor;

/// Processor for global tone adjustments.
@property (strong, nonatomic) id<TMProcessor> bilateralProcessor;

/// Processor to use when processing the next frame.
@property (strong, nonatomic) id<TMProcessor> currentProcessor;

/// Uniform referencing a projection that flips the texture along the y-axis.
@property (strong, nonatomic) TMMatrixUniform *yFlipProjection;

/// Uniforms to use when processing the next frame.
@property (strong, nonatomic) NSArray *currentUniforms;

/// Indicates whether \c currentProcessor needs to be applied to the \c inputTexture.
@property (nonatomic) BOOL textureNeedsProcessing;

/// Object in charge of saving textures to disk.
@property (strong, nonatomic) TMTextureSaver *textureSaver;

@end

@implementation TMGLViewController

/// Number of passes used to create a weakly blured \c inputTexture.
static const int kWeakBlurPassesNumber = 2;

/// Number of passes used to create a strongly blured \c inputTexture.
static const int kStrongBlurPassesNumber = 7;

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initContext];
  [self initProperties];
  [self initProcessors];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self setupGLKView];
  self.display = [[TMTextureDisplay alloc] initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc]
                                                                initWithGLKView:self.glkView]
                  program:[self.programFactory passThroughWithProjection]
                  geometry:[self.geometryFactory quadGeometry]];
}

- (void)setupGLKView {
  if (self.glkView) {
    [self.glkView removeFromSuperview];
  }
  self.glkView = [[GLKView alloc] init];
  self.glkView.delegate = self;
  self.glkView.context = self.context;
  self.glkView.opaque = NO;
  self.glkView.frame = self.view.frame;
  [self.view addSubview:self.glkView];
}

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (void)initContext {
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
}

- (void)initProperties {
  self.programFactory = [[TMProgramFactory alloc] init];
  self.geometryFactory = [[TMGeometryFactory alloc] init];
  self.processorFactory = [[TMTextureProcessorFactory alloc] init];
  self.positionFactory = [[TMPositionFactory alloc] init];
  self.projectionFactory = [[TMProjectionFactory alloc] init];
  self.toneAdjustmentGenerator = [[TMToneAdjustmentGenerator alloc] init];
  self.textureNeedsProcessing = true;
  self.yFlipProjection = [[TMMatrixUniform alloc] initWithMatrix:[self.projectionFactory
                                                               verticalMirrorProjection]
                                                         uniform:kProjectionUniform];
  self.textureSaver = [[TMTextureSaver alloc] init];
}

- (void)initProcessors {
  TMTextureProgram *mixerProgram = [self.programFactory textureMixingProgram];
  self.localContrastProcessor = [self.processorFactory processorWithProgram:mixerProgram];
  TMTextureProgram *horizontalBilateral = [self.programFactory bilateralHorizontalFilterProgram];
  TMTextureProgram *verticalBilateral = [self.programFactory bilateralVerticalFilterProgram];
  self.bilateralProcessor = [self.processorFactory processorWithPrograms:@[horizontalBilateral,
                                                                           verticalBilateral]];
  self.globalTonesProcessor = [[TMTextureProcessor alloc]
                               initWithProgram:[self.programFactory globalToneProgram]];
}

#pragma mark -
#pragma mark GLKViewDelegate
#pragma mark -

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.2, 0.0, 0.2, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  if (self.textureNeedsProcessing) {
    self.processedTexture = [self.currentProcessor processTexture:self.inputTexture
                                                     withUniforms:self.currentUniforms];
    self.textureNeedsProcessing = false;
  }
  
  [self.display displayTexture:self.processedTexture
                scaledPosition:self.currentTextureScaledPosition
                      uniforms:@[self.yFlipProjection]];
}

#pragma mark -
#pragma mark Image Projection
#pragma mark -

- (void)moveTextureWithTranslation:(CGPoint)translation
                      gestureState:(TMGestureState)gestureState {
  TMScaledPosition *positionDelta = [self.positionFactory positionWithTranslation:translation];
  [self updateTexturePositionWithPosition:positionDelta gestureState:gestureState];
}

- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
            gestureState:(TMGestureState)gestureState {
  TMScaledPosition *positionDelta = [self.positionFactory positionWithScale:scale];
  [self updateTexturePositionWithPosition:positionDelta gestureState:gestureState];
}

- (void)updateTexturePositionWithPosition:(TMScaledPosition *)position
                             gestureState:(TMGestureState)gestureState {
  self.currentTextureScaledPosition =
      [self.startingTextureScaledPosition scaledPositionWithDeltaScaledPosition:position];
  if (gestureState == TMGestureStateEnded) {
    self.startingTextureScaledPosition = self.currentTextureScaledPosition;
  }
  [self.glkView setNeedsDisplay];
}

#pragma mark -
#pragma mark Tone Adjustments
#pragma mark -

- (void)setLocalContrastWithMediumWeight:(GLfloat)mediumWeight fineWeight:(GLfloat)fineWeight {
  TMScalarUniform *mediumWeightUniform = [[TMScalarUniform alloc] initWithName:kMediumWeight
                                                                        scalar:mediumWeight];
  TMScalarUniform *fineWeightUniform = [[TMScalarUniform alloc] initWithName:kFineWeight
                                                                      scalar:fineWeight];
  self.currentUniforms = @[mediumWeightUniform, fineWeightUniform, self.strongBlurTextureUniform,
                           self.weakBlurTextureUniform];
  self.currentProcessor = self.localContrastProcessor;
}

- (void)setToneAdjustmentWithBrightness:(GLfloat)brightness contrast:(GLfloat)contrast
                             saturation:(GLfloat)saturation tint:(GLfloat)tint
                            temperature:(GLfloat)temperature {
  GLKMatrix4 toneMatrix = GLKMatrix4Identity;
  toneMatrix = GLKMatrix4Multiply([self.toneAdjustmentGenerator toneMatrixForBrightness:brightness],
                                  toneMatrix);
  toneMatrix = GLKMatrix4Multiply([self.toneAdjustmentGenerator toneMatrixForContrast:contrast],
                                  toneMatrix);
  toneMatrix = GLKMatrix4Multiply([self.toneAdjustmentGenerator toneMatrixForSaturation:saturation],
                                  toneMatrix);
  toneMatrix = GLKMatrix4Multiply([self.toneAdjustmentGenerator toneMatrixForTint:tint],
                                  toneMatrix);
  toneMatrix = GLKMatrix4Multiply([self.toneAdjustmentGenerator
                                   toneMatrixForTemperature:temperature], toneMatrix);
  TMMatrixUniform *toneMatrixUniform = [[TMMatrixUniform alloc] initWithMatrix:toneMatrix
                                                                       uniform:kToneAdjustment];
  self.currentUniforms = @[toneMatrixUniform];
  self.currentProcessor = self.globalTonesProcessor;
}

- (TMTexture *)texture:(TMTexture *)texture
      fromBilateralWithNumberOfPasses:(NSUInteger)numberOfPasses {
  id<TMProcessor> multipassBilateralProcessor =
      [self.processorFactory multipassProcessorFromProcessor:self.bilateralProcessor
                                              numberOfPasses:numberOfPasses];
  GLKVector2 vector = GLKVector2Make(texture.size.width, texture.size.height);
  TMVector2DUniform *vectorUniform = [[TMVector2DUniform alloc] initWithVector:vector
                                                                       uniform:kTextureDimensions];
  return [multipassBilateralProcessor processTexture:texture withUniforms:@[vectorUniform]];
}

- (void)createBilateralBlurredTextures {
  TMTexture *strongBlurTexture = [self texture:self.inputTexture
        fromBilateralWithNumberOfPasses:kStrongBlurPassesNumber];
  TMTexture *weakBlurTexture = [self texture:self.inputTexture
      fromBilateralWithNumberOfPasses:kWeakBlurPassesNumber];
  self.strongBlurTextureUniform = [[TMTextureUniform alloc] initWithTexture:strongBlurTexture
                                                                       name:kStrongBlurTexture
                                                                textureType:TMTextureTypeUniform1];
  self.weakBlurTextureUniform = [[TMTextureUniform alloc] initWithTexture:weakBlurTexture
                                                                     name:kWeakBlurTexture
                                                              textureType:TMTextureTypeUniform2];
}

- (void)setupTextureWorkspace {
  self.currentTextureScaledPosition = [self.positionFactory defaultPosition];
  self.startingTextureScaledPosition = self.currentTextureScaledPosition;
  [self createBilateralBlurredTextures];
  [self.glkView setNeedsDisplay];
}

#pragma mark -
#pragma mark TMGLViewController
#pragma mark -

- (NSUInteger)maxTextureSize {
  GLint maxTextureSize;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  return (NSUInteger)maxTextureSize;
}

- (void)loadTextureFromImage:(UIImage *)image {
  self.inputTexture = [[TMTexture alloc] initWithImage:image];
  self.processedTexture = self.inputTexture;
  [self setupTextureWorkspace];
}

- (void)applyCurrentTextureState {
  self.inputTexture = self.processedTexture;
  [self createBilateralBlurredTextures];
  [self setupTextureWorkspace];
  [self.glkView setNeedsDisplay];
}

- (void)saveProcessedTexture {
  [self.textureSaver saveTexture:self.processedTexture];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setCurrentProcessor:(id<TMProcessor>)currentProcessor {
  _currentProcessor = currentProcessor;
  self.textureNeedsProcessing = true;
  [self.glkView setNeedsDisplay];
}

@end

NS_ASSUME_NONNULL_END
