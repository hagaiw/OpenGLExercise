// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMGLKViewFrameBuffer;
@class TMTextureProgram;
@class TMTexturedGeometry;
@class TMScaledPosition;

NS_ASSUME_NONNULL_BEGIN

/// Class used to to display projected textures.
@interface TMTextureDisplay : NSObject

/// Initializes with the given \c TMFrameBuffer, \c TMTextureProgram, \c TMTexturedGeometry.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry;

/// Display the given \c TMTexture with the given \c scaledPosition.
- (void)displayTexture:(TMTexture *)texture scaledPosition:(TMScaledPosition *)scaledPosition
        matrixUniforms:(NSArray *)matrixUniforms;

@end

NS_ASSUME_NONNULL_END
