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
  
  
  
  for (TMMatrixUniform *uniform in matrixUniforms) {
    glUniformMatrix4fv([program.handlesForUniforms handleForKey:uniform.uniform], 1, 0,
                          uniform.matrix.m);
  }
  
  
  
  glViewport(0, 0, frameBuffer.size.width, frameBuffer.size.height);
  glDrawElements(GL_TRIANGLES, [texturedGeometry numberOfIndices], GL_UNSIGNED_BYTE, 0);
}


@end

NS_ASSUME_NONNULL_END
