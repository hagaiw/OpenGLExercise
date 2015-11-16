// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

#import "TMFrameBuffer.h"

@class TMTexture;
@class TMTextureProgram;
@class TMTexturedGeometry;

NS_ASSUME_NONNULL_BEGIN

/// Class for performing OpenGL drawing.
@interface TMTextureDrawer : NSObject

/// Draws the scene defined by the given \c program, \c textureGeometry, \c texture and
/// \c projection to the given \c frameBuffer and binds \c uniforms.
- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                      uniforms:(NSArray *)uniforms;

@end

NS_ASSUME_NONNULL_END
