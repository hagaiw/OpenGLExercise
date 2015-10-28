// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureProcessorFactory.h"
#import "TMTextureProcessor.h"
#import "TMConcatProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTextureProcessorFactory

- (id<TMProcessor>)processorWithProgram:(TMTextureProgram *)program {
  return [[TMTextureProcessor alloc] initWithProgram:program];
}

- (id<TMProcessor>)processorWithPrograms:(NSArray *)programs {
  NSMutableArray *processors = [[NSMutableArray alloc] init];
  for (TMTextureProgram *program in programs) {
    [processors addObject:[self processorWithProgram:program]];
  }
  return [[TMConcatProcessor alloc] initWithProcsessors:processors];
}

- (id<TMProcessor>)multipassProcessorFromProcessor:(TMTextureProcessor *)processor
                                    numberOfPasses:(NSUInteger)numberOfPasses {
  NSMutableArray *processors = [[NSMutableArray alloc] init];
  for (NSUInteger i = 0; i <numberOfPasses ; ++i) {
    [processors addObject:processor];
  }
  return [[TMConcatProcessor alloc] initWithProcsessors:processors];
}

@end

NS_ASSUME_NONNULL_END
