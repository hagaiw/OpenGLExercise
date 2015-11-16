// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureProgram.h"
#import "TMHandleDictionary.h"
#import "TMProgram.h"

@interface TMTextureProgram ()

/// The \TMProgram wrapped by this class.
@property (readonly, strong, nonatomic) TMProgram *program;

@end

@implementation TMTextureProgram

/// The name of the position attribute in the vertex shader.
NSString * const kPositionAttribute = @"position";

/// The name of the texture coordinate attribute in the fragment shader.
NSString * const kTextureCoordinateAttribute = @"texCoordIn";

/// The name of the texture uniform in the fragment shader.
NSString * const kTextureUniform = @"texture";

/// The name of the projection uniform in the vertex shader.
NSString * const kProjectionUniform = @"projection";

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithProgram:(TMProgram *)program {
  if (self = [super init]) {
    _program = program;
    _textureUniform = [program.handlesForUniforms handleForKey:kTextureUniform];
    _projectionUniform = [program.handlesForUniforms handleForKey:kProjectionUniform];
    _textureCoordAttribute = [program.handlesForAttributes handleForKey:kTextureCoordinateAttribute];
    _positionAttribute = [program.handlesForAttributes handleForKey:kPositionAttribute];
  }
  return self;
}

#pragma mark -
#pragma mark OpenGL
#pragma mark -

- (void)use {
  [self.program useProgram];
}

- (TMHandleDictionary *)handlesForUniforms {
  return self.program.handlesForUniforms;
}

- (void)useProgramWithUniforms:(NSArray *)uniforms {
  [self.program useProgramWithUniforms:uniforms];
}

@end
