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

/// \c TMframeBuffer to which textures will be displayed.
@property (readonly, strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;

/// \c TMProgram used when displaying textures.
@property (readonly, strong, nonatomic) TMTextureProgram *program;

/// \c TMGeometry used when displaying textures.
@property (readonly, strong, nonatomic) TMTexturedGeometry *geometry;

/// Factory object used to produce \c GLKMatrix4 projections.
@property (readonly, strong, nonatomic) TMProjectionFactory *projectionFactory;

/// \c TMTextureDrawer that is used to draw textures.
@property (readonly, strong, nonatomic) TMTextureDrawer *textureDrawer;

@end

@implementation TMTextureDisplay

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry {
  if (self = [super init]) {
    _frameBuffer = frameBuffer;
    _program = program;
    _geometry = geometry;
    _projectionFactory = [TMProjectionFactory new];
    _textureDrawer = [TMTextureDrawer new];
  }
  return self;
}

#pragma mark -
#pragma mark Texture Displaying
#pragma mark -

- (void)displayTexture:(TMTexture *)texture scaledPosition:(TMScaledPosition *)scaledPosition
        matrixUniforms:(NSArray *)matrixUniforms{
  
  GLKMatrix4 aspectFixProjection = [self.projectionFactory projectionFitSize:texture.size
                                                                      inSize:self.frameBuffer.size];
  GLKMatrix4 translationProjection = [self.projectionFactory
                                      translationProjectionWithX:scaledPosition.translation.x
                                      y:scaledPosition.translation.y];
  GLKMatrix4 scaleProjection = [self.projectionFactory scaleProjectionWithScale:scaledPosition.scale];
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:aspectFixProjection
                                                               right:scaleProjection];
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:translationProjection
                                                                 right:aspectFixProjection];
  TMMatrixUniform *matrixUniform = [[TMMatrixUniform alloc] initWithMatrix:aspectFixProjection
                                                                   uniform:kProjectionUniform];
  
  [self.textureDrawer drawWithTextureProgram:self.program texturedGeometry:self.geometry
                                    frameBuffer:self.frameBuffer texture:texture
                                     uniforms:[matrixUniforms arrayByAddingObject:matrixUniform]];
}

@end

NS_ASSUME_NONNULL_END
