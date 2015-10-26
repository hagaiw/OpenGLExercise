// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureProcessorFactory.h"
#import "TMTextureProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTextureProcessorFactory

- (TMTextureProcessor *)processorWithProgram:(TMTextureProgram *)program {
  return [[TMTextureProcessor alloc] initWithProgram:program];
}

@end

NS_ASSUME_NONNULL_END
