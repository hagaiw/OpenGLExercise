// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureProgram.h"
#import "TMHandleDictionary.h"
#import "TMProgram.h"

@interface TMTextureProgram ()

/// The \TMProgram wrapped by this class.
@property (strong, nonatomic) TMProgram *program;

@end

@implementation TMTextureProgram

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithProgram:(TMProgram *)program {
  if (self = [super init]) {
    self.program = program;
    _textureUniform = [program.handlesForUniforms handleForKey:kTextureUniform];
    _projectionUniform = [program.handlesForUniforms handleForKey:kProjectionUniform];
    _textureCoordAttribute = [program.handlesForAttributes handleForKey:kTextureCoordinateAttribute];
    _positionAttribute = [program.handlesForAttributes handleForKey:kPositionAttribute];
  }
  return self;
}

#pragma mark -
#pragma mark OpenGL Binding
#pragma mark -

- (void)use {
  [self.program useProgram];
}

- (void)bindScalarUniform:(TMScalarUniform *)scalarUniform {
  [self.program bindScalarUniform:scalarUniform];
}

- (void)bindMatrix:(GLKMatrix4)matrix toUniform:(NSString *)uniform {
  [self.program bindMatrix:matrix toUniform:uniform];
}

- (void)bindVector:(GLKVector2)vector toUniform:(NSString *)uniform {
  [self.program bindVector:vector toUniform:uniform];
}

- (TMHandleDictionary *)handlesForUniforms {
  return self.program.handlesForUniforms;
}

@end
