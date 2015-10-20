//
//  TMQuadVertices.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMQuadTexturedVertices.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMQuadTexturedVertices

static const GLsizei kQuadNumOfPositionCoordinates = 3;
static const GLsizei kQuadNumOfTextureCoordinates = 4;

/// A Quad-Vertex memory representation.
typedef struct {
  float Position[3];
  float TexCoord[2];
} QuadVertex;

/// The quad vertices coordinates.
static const QuadVertex kQuadVertices[] = {
  {{1, -1, 0}, {1, 0}},
  {{1, 1, 0}, {1, 1}},
  {{-1, 1, 0}, {0, 1}},
  {{-1, -1, 0}, {0, 0}}
};

/// The quad vertices indices.
static const GLubyte kQuadIndices[] = {
  0, 1, 2,
  2, 3, 0
};

- (void *)vertices {
  return (void *)kQuadVertices;
}

- (GLubyte *)indices {
  return (GLubyte *)kQuadIndices;
}

- (GLsizei)numOfVertices {
  return sizeof(kQuadVertices)/sizeof(QuadVertex);
}

- (GLsizei)numOfPositionCoordinates {
  return kQuadNumOfPositionCoordinates;
}

- (GLsizei)numOfTextureCoordinates {
  return kQuadNumOfTextureCoordinates;
}

- (GLsizei)numOfIndices {
  return sizeof(kQuadIndices)/sizeof(GLubyte);
}

- (GLenum)positionType {
  return GL_FLOAT;
}

- (GLenum)textureType {
  return GL_FLOAT;
}

- (GLuint)indexSize {
  return sizeof(GLubyte);
}

- (GLuint)verticesArraySize {
  return sizeof(kQuadVertices);
}

- (GLuint)indicesArraySize {
  return sizeof(kQuadIndices);
}

- (GLuint)vertexSize {
  return sizeof(QuadVertex);
}

- (GLvoid *)positionPointer {
  return 0;
}

- (GLvoid *)texturePointer {
  return (GLvoid *)(sizeof(float) * kQuadNumOfPositionCoordinates);
}

@end

NS_ASSUME_NONNULL_END
