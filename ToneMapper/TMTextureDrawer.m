// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTextureDrawer.h"
#import "TMTexture.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"
#import "TMMatrixUniform.h"
#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTextureDrawer

- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                matrixUniforms:(NSArray *)matrixUniforms {
  [program use];
  [frameBuffer bind];
  [texture bind];
  [texturedGeometry bind];
  
  [texturedGeometry linkPositionArrayToAttribute:program.positionAttribute];
  [texturedGeometry linkTextureArrayToAttribute:program.textureCoordAttribute];
  
  glUniform1i(program.textureUniform, 0);
  
  TMMatrixUniform *projection = [[TMMatrixUniform alloc] initWithMatrix:GLKMatrix4Identity
                                                                uniform:kProjectionUniform];
  GLKMatrix4 projectionMatrix = GLKMatrix4Identity;
  
  for (TMMatrixUniform *uniform in matrixUniforms) {
    if ([uniform.name isEqualToString:kProjectionUniform]) {
      projectionMatrix = GLKMatrix4Multiply(uniform.matrix, projectionMatrix);
      projection = [[TMMatrixUniform alloc] initWithMatrix:GLKMatrix4Multiply(uniform.matrix,
                                                                              projection.matrix)
                                                   uniform:kProjectionUniform];
    } else {
//      glUniformMatrix4fv([program.handlesForUniforms handleForKey:uniform.name], 1, 0,
//                            uniform.matrix.m);
      [uniform linkToHandle:[program.handlesForUniforms handleForKey:uniform.name]];
    }
  }
  
  [projection linkToHandle:[program.handlesForUniforms handleForKey:projection.name]];

  
  glViewport(0, 0, frameBuffer.size.width, frameBuffer.size.height);
  glDrawElements(GL_TRIANGLES, [texturedGeometry numberOfIndices], GL_UNSIGNED_BYTE, 0);
}


@end

NS_ASSUME_NONNULL_END
