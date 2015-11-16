// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMUniform.h"
#import "TMTexture.h"

NS_ASSUME_NONNULL_BEGIN

/// \c TMTexture uniform wrapper.
@interface TMTextureUniform : NSObject <TMUniform>

/// Initialize with \c texture, \c name, \c textureType.
- (instancetype)initWithTexture:(TMTexture *)texture name:(NSString *)name
                    textureType:(TMTextureType)textureType;

/// Name of uniform variable as it appears in the shader.
@property (readonly, strong, nonatomic) NSString *name;

/// \c Texture to use when setting this uniform's value.
@property (readonly, strong, nonatomic) TMTexture *texture;

/// The type of this texture.
@property (readonly, nonatomic) TMTextureType textureType;

@end

NS_ASSUME_NONNULL_END
