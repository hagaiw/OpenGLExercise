// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@class TMTexture;
@class TMGLKViewFrameBuffer;
@class TMTextureProgram;
@class TMTexturedGeometry;
@class TMScaledPosition;

NS_ASSUME_NONNULL_BEGIN

/// A \c TMTexture displayer, to be used at the end of a \c TMTexture processing pipeline.
@interface TMTextureDisplay : NSObject

/// Initializes with the given \c TMFrameBuffer, \c TMTextureProgram, \c TMTexturedGeometry.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry;

/// Display the given \c TMTexture with translation and scale specified by the given
/// \c TMDisplayData.
- (void)displayTexture:(TMTexture *)texture position:(TMScaledPosition *)displayData;

@end

NS_ASSUME_NONNULL_END
