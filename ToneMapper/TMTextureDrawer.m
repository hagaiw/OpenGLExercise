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
                      uniforms:(NSArray *)uniforms {
  [program use];
  [frameBuffer bind];
  
  [texture bindAndlinkToHandle:program.textureUniform];
  [texturedGeometry bind];
  [texturedGeometry linkPositionArrayToAttribute:program.positionAttribute];
  [texturedGeometry linkTextureArrayToAttribute:program.textureCoordAttribute];
  
  TMMatrixUniform *projection = [[TMMatrixUniform alloc] initWithMatrix:GLKMatrix4Identity
                                                                uniform:kProjectionUniform];
  for (id<TMUniform> uniform in uniforms) {
    if ([uniform.name isEqualToString:kProjectionUniform]) {
      TMMatrixUniform *matrixUniform = uniform;
      projection = [[TMMatrixUniform alloc] initWithMatrix:GLKMatrix4Multiply(matrixUniform.matrix,
                                                                              projection.matrix)
                                                   uniform:kProjectionUniform];
    } else {
      [uniform linkToProgramWithHandleDictionary:program.handlesForUniforms];
    }
  }
  
  [projection linkToProgramWithHandleDictionary:program.handlesForUniforms];

  
  glViewport(0, 0, frameBuffer.size.width, frameBuffer.size.height);
  glDrawElements(GL_TRIANGLES, [texturedGeometry numberOfIndices], GL_UNSIGNED_BYTE, 0);
}


@end

NS_ASSUME_NONNULL_END
