// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMQuadTexturedVertices.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMQuadTexturedVertices

/// Number of position coordinates.
static const GLsizei kQuadNumOfPositionCoordinates = 3;

/// Number of texture coordinates.
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

+ (void *)vertices {
  return (void *)kQuadVertices;
}

+ (GLubyte *)indices {
  return (GLubyte *)kQuadIndices;
}

+ (GLsizei)numOfVertices {
  return sizeof(kQuadVertices)/sizeof(QuadVertex);
}

+ (GLsizei)numOfPositionCoordinates {
  return kQuadNumOfPositionCoordinates;
}

+ (GLsizei)numOfTextureCoordinates {
  return kQuadNumOfTextureCoordinates;
}

+ (GLsizei)numOfIndices {
  return sizeof(kQuadIndices)/sizeof(kQuadIndices[0]);
}

+ (GLenum)positionType {
  return GL_FLOAT;
}

+ (GLenum)textureType {
  return GL_FLOAT;
}

+ (GLuint)indexSize {
  return sizeof(kQuadIndices[0]);
}

+ (GLuint)verticesArraySize {
  return sizeof(kQuadVertices);
}

+ (GLuint)indicesArraySize {
  return sizeof(kQuadIndices);
}

+ (GLuint)vertexSize {
  return sizeof(QuadVertex);
}

+ (GLvoid *)positionPointer {
  return 0;
}

+ (GLvoid *)texturePointer {
  return (GLvoid *)(sizeof(kQuadVertices[0].Position[0]) * [TMQuadTexturedVertices numOfPositionCoordinates]);
}

@end

NS_ASSUME_NONNULL_END
