// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// Protocol that should be implemented by texture-processing classes.
@protocol TMProcessor <NSObject>

/// Process the given \c texture and return the resulting \c TMTexture.
- (TMTexture *)processTexture:(TMTexture *)texture;

/// Bind the given \c uniforms and process the given \c texture.
- (TMTexture *)processTexture:(TMTexture *)texture withUniforms:(NSArray *)uniforms;

@end

NS_ASSUME_NONNULL_END
