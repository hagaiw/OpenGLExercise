// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexture.h"
#import "TMTextureProgram.h"
#import "TMTextureProcessor.h"
#import "TMProgramFactory.h"
#import "TMTextureFrameBuffer.h"
#import "TMTextureDrawer.h"
#import "TMProjectionFactory.h"
#import "TMGeometryFactory.h"
#import "TMMatrixUniform.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureProcessor ()

/// Program used when processing textures given to this processor.
@property (strong, nonatomic) TMTextureProgram *program;

/// Geometry used to draw and process the given \c TMTexture.
@property (strong, nonatomic) TMTexturedGeometry *geometry;

/// Factory object used to create \c GLKMAtrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// Factory object used to create \c TMTextureGeometry.
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

/// \c TMFrameBuffer to which the given \c TMTexture is drawn while processing.
/// Will be reinitialized whenever the given \c TMTexture's size does not equal that of
/// \c frameBuffer's.
@property (strong, nonatomic) TMTextureFrameBuffer *frameBuffer;

@end

@implementation TMTextureProcessor

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)init {
  return nil;
}

- (instancetype)initWithProgram:(TMTextureProgram *)program {
  if (self = [super init]) {
    self.projectionFactory = [TMProjectionFactory new];
    self.geometryFactory = [TMGeometryFactory new];
    self.program = program;
    self.geometry = [self.geometryFactory quadGeometry];
  }
  return self;
}

#pragma mark -
#pragma mark Processing
#pragma mark -

- (TMTexture *)processTexture:(TMTexture *)texture {
  TMMatrixUniform *matrixUniform =
      [[TMMatrixUniform alloc] initWithMatrix:[self.projectionFactory identityProjection]
                                      uniform:kProjectionUniform];
  return [self processTexture:texture withUniforms:@[matrixUniform]];
}

- (TMTexture *)processTexture:(TMTexture *)texture withUniforms:(NSArray *)uniforms {
  self.frameBuffer = [self frameBufferWithSize:texture.size];
  [[TMTextureDrawer new] drawWithTextureProgram:self.program
                               texturedGeometry:self.geometry
                                    frameBuffer:self.frameBuffer
                                        texture:texture
                                       uniforms:uniforms];
  return self.frameBuffer.texture;
}

#pragma mark -
#pragma mark Frame Buffer Handling
#pragma mark -

- (TMTextureFrameBuffer *)frameBufferWithSize:(CGSize)size {
  if (self.frameBuffer.size.height == size.height && self.frameBuffer.size.width == size.width) {
    return self.frameBuffer;
  }
  return [[TMTextureFrameBuffer alloc] initWithSize:size];
}

@end

NS_ASSUME_NONNULL_END
