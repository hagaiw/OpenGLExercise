// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureSaver.h"
#import "TMTextureFrameBuffer.h"
#import "TMTextureDisplay.h"
#import "TMProgramFactory.h"
#import "TMGeometryFactory.h"
#import "TMPositionFactory.h"

#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureSaver ()

/// Factory object used to produce \c TMPrograms.
@property (strong, nonatomic) TMProgramFactory *programFactory;

/// Geometry to be used when drawing the texture to be saved.
@property (strong, nonatomic) TMTexturedGeometry *geometry;

/// Scaled Position to use when drawing the texture to be saved.
@property (strong, nonatomic) TMScaledPosition *scaledPosition;

@end

@implementation TMTextureSaver

/// Number of bytes per pixel.
static const int kBytesPerPixel = 4;

/// Value of bitsPerComponent to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerComponent = 8;

/// Value of bitsPerPixel to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerPixel = 32;

-(instancetype)init {
  if (self = [super init]) {
    self.programFactory = [[TMProgramFactory alloc] init];
    self.geometry = [[[TMGeometryFactory alloc] init] quadGeometry];
    self.scaledPosition = [[[TMPositionFactory alloc] init] defaultPosition];
  }
  return self;
}

- (void)saveTexture:(TMTexture *)texture {
  UIImage *image = [self imageFromTexture:texture];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

-(UIImage *)imageFromTexture:(TMTexture *)texture {
  TMTextureFrameBuffer *frameBufferForSaving =
      [[TMTextureFrameBuffer alloc] initWithSize:texture.size];
  [self drawTexture:texture toFrameBuffer:frameBufferForSaving];
  return [UIImage imageWithCGImage:[self cgImageFromFrameBuffer:frameBufferForSaving
                                                       withSize:texture.size]];
}

- (void)drawTexture:(TMTexture *)texture toFrameBuffer:(TMTextureFrameBuffer *)framebuffer {
  TMTextureDisplay *displayer =
      [[TMTextureDisplay alloc] initWithFrameBuffer:framebuffer
                                        program:[self.programFactory passThroughWithProjection]
                                       geometry:self.geometry];
  [displayer displayTexture:texture scaledPosition:self.scaledPosition uniforms:@[]];
}

- (CGImageRef)cgImageFromFrameBuffer:(TMTextureFrameBuffer *)frameBuffer withSize:(CGSize)size {
  NSInteger lengthOfData = (NSInteger)(size.width * size.height) * kBytesPerPixel;
  GLubyte *buffer = (GLubyte *) malloc(lengthOfData);
  [frameBuffer bind];
  glReadPixels(0, 0, size.width, size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, lengthOfData, NULL);
  return CGImageCreate(size.width, size.height, kBitsPerComponent, kBitsPerPixel,
                       kBytesPerPixel * size.width, CGColorSpaceCreateDeviceRGB(),
                       kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);
}

@end

NS_ASSUME_NONNULL_END
