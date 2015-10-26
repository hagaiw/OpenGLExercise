// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMShaderFactory.h"
#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMShaderFactory

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (TMShader *)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType {
  return [[TMShader alloc] initWithShaderName:shaderName shaderType:shaderType];
}

@end

NS_ASSUME_NONNULL_END
