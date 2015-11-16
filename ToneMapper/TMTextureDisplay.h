// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>
@class TMGLKViewFrameBuffer, TMScaledPosition, TMTexture, TMTexturedGeometry, TMTextureProgram;
@protocol TMFrameBuffer;

NS_ASSUME_NONNULL_BEGIN

/// Class used to to display projected textures.
@interface TMTextureDisplay : NSObject

/// Initializes with the given \c frameBuffer, \c program, \c geometry.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry;

/// Displays the given \c texture with the given \c scaledPosition.
/// Uniforms are uniform values to be set when displaying the \c texture.
- (void)displayTexture:(TMTexture *)texture scaledPosition:(TMScaledPosition *)scaledPosition
              uniforms:(NSArray *)uniforms;

@end

NS_ASSUME_NONNULL_END
