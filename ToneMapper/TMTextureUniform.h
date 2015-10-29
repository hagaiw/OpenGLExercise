// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMUniform.h"
@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// \c TMTexture uniform wrapper.
@interface TMTextureUniform : NSObject <TMUniform>

/// Initialize with \c texture, \c name, \c textureUnit.
- (instancetype)initWithTexture:(TMTexture *)texture name:(NSString *)name textureUnit:(GLuint)textureUnit;

/// Name of uniform variable as it appears in the shader.
@property (readonly, strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
