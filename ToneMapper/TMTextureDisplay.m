// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexture.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"
#import "TMScaledPosition.h"
#import "TMTextureDisplay.h"
#import "TMProgramFactory.h"
#import "TMProjectionFactory.h"
#import "TMTexturedGeometry.h"
#import "TMQuadTexturedVertices.h"
#import "TMTextureDrawer.h"
#import "TMMatrixUniform.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureDisplay ()

/// The \c TMframeBuffer to which \c TMTextures will be drawn.
@property (strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;

/// The \c TMProgram used to when drawing \c TMTextures.
@property (strong, nonatomic) TMTextureProgram *program;

/// The \c TMGeometry used when drawing.
@property (strong, nonatomic) TMTexturedGeometry *geometry;

/// A factory class used to produce \c GLKMatrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// A \c TMTextureDrawer that is used when drawing \c TMTextures.
@property (strong, nonatomic) TMTextureDrawer *textureDrawer;

@end

@implementation TMTextureDisplay

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    self.program = program;
    self.geometry = geometry;
    self.projectionFactory = [TMProjectionFactory new];
    self.textureDrawer = [TMTextureDrawer new];
  }
  return self;
}

#pragma mark -
#pragma mark Texture Displaying
#pragma mark -

- (void)displayTexture:(TMTexture *)texture
           position:(TMScaledPosition *)displayData {
  
  GLKMatrix4 aspectFixProjection = [self.projectionFactory projectionFitSize:texture.size
                                                                      inSize:self.frameBuffer.size];
  GLKMatrix4 translationProjection = [self.projectionFactory
                                      translationProjectionWithX:displayData.translation.x
                                      y:displayData.translation.y];
  GLKMatrix4 scaleProjection = [self.projectionFactory scaleProjectionWithScale:displayData.scale];
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:aspectFixProjection
                                                               right:scaleProjection];
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:translationProjection
                                                                 right:aspectFixProjection];
  TMMatrixUniform *matrixUniform = [[TMMatrixUniform alloc] initWithMatrix:aspectFixProjection
                                                                   uniform:kProjectionUniform];
  
  [self.textureDrawer drawWithTextureProgram:self.program texturedGeometry:self.geometry
                                    frameBuffer:self.frameBuffer texture:texture
                                     matrixUniforms:@[matrixUniform]];
}

@end

NS_ASSUME_NONNULL_END
