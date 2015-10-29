// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMConcatProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMConcatProcessor ()

/// Processors to be applied in order.
@property (readonly, strong, nonatomic) NSArray *processors;

@end

@implementation TMConcatProcessor

- (instancetype)initWithProcsessors:(NSArray *)processors {
  if (self = [super init]) {
    _processors = processors;
  }
  return self;
}

- (TMTexture *)processTexture:(TMTexture *)texture {
  return [self processTexture:texture withUniforms:@[]];
}

- (TMTexture *)processTexture:(TMTexture *)texture withUniforms:(NSArray *)uniforms {
  for (id<TMProcessor> processor in self.processors) {
    texture = [processor processTexture:texture withUniforms:uniforms];
  }
  return texture;
}

@end

NS_ASSUME_NONNULL_END
