// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureDisplay.h"

#import "TMGLKViewFrameBuffer.h"
#import "TMMatrixUniform.h"
#import "TMProjectionFactory.h"
#import "TMProgramFactory.h"
#import "TMQuadTexturedVertices.h"
#import "TMScaledPosition.h"
#import "TMTexture.h"
#import "TMTexturedGeometry.h"
#import "TMTextureDrawer.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureDisplay ()

/// Framebuffer into which geometry is rendered.
@property (readonly, strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;

/// Program used to render geometry.
@property (readonly, strong, nonatomic) TMTextureProgram *program;

/// Rendered geometry.
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
    _projectionFactory = [[TMProjectionFactory alloc] init];
    _textureDrawer = [[TMTextureDrawer alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Texture Displaying
#pragma mark -

- (void)displayTexture:(TMTexture *)texture scaledPosition:(TMScaledPosition *)scaledPosition
        uniforms:(NSArray *)uniforms {
  GLKMatrix4 aspectFixProjection = [self.projectionFactory projectionFitSize:texture.size
                                                                      inSize:self.frameBuffer.size];
  GLKMatrix4 translationProjection =
      [self.projectionFactory translationProjectionWithX:scaledPosition.translation.x
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
                                    uniforms:[uniforms arrayByAddingObject:matrixUniform]];
}

@end

NS_ASSUME_NONNULL_END
