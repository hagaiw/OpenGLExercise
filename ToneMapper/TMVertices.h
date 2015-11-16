// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import GLKit;

/// Protocol for vertex buffer data wrapper objects.
@protocol TMVertices <NSObject>

/// Pointer to an array of vertices.
- (void *)vertices;

/// Pointer to an array of vertex indices.
- (GLubyte *)indices;

/// Number of vertices in the \c vertices array.
- (GLsizei)numOfVertices;

/// Number of position coordinates each vertex has.
- (GLsizei)numOfPositionCoordinates;

/// Number of texture coordinates each vertex has.
- (GLsizei)numOfTextureCoordinates;

/// Number of indices in the \c indices array.
- (GLsizei)numOfIndices;

/// Type of each position coordinate.
- (GLenum)positionType;

/// Type of each texture coordinate.
- (GLenum)textureType;

/// Size of each index.
- (GLuint)indexSize;

/// Size of each vertex.
- (GLuint)vertexSize;

/// Size of the \c vertices array.
- (GLuint)verticesArraySize;

/// Size pf the \c indices array.
- (GLuint)indicesArraySize;

/// Pointer to the first position coordinate.
- (GLvoid *)positionPointer;

/// Pointer to the first texture coordinate.
- (GLvoid *)texturePointer;

@end

NS_ASSUME_NONNULL_END
