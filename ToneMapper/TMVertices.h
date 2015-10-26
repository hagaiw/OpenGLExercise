// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import GLKit;

/// A protocol for vertex buffer data wrapper objects.
@protocol TMVertices <NSObject>

/// A pointer to an array of vertices.
+ (void *)vertices;

/// A pointer to an array of vertex indices.
+ (GLubyte *) indices;

/// The number of vertices in the \c vertices array.
+ (GLsizei) numOfVertices;

/// The number of position coordinates each vertex has.
+ (GLsizei) numOfPositionCoordinates;

/// The number of texture coordinates each vertex has.
+ (GLsizei) numOfTextureCoordinates;

/// The number of indices in the \c indices array.
+ (GLsizei) numOfIndices;

/// The type of each position coordinate.
+ (GLenum) positionType;

/// The type of each texture coordinate.
+ (GLenum) textureType;

/// The size of each index.
+ (GLuint) indexSize;

/// The size of each vertex.
+ (GLuint) vertexSize;

/// The size of the \c vertices array.
+ (GLuint) verticesArraySize;

/// The size pf the \c indices array.
+ (GLuint) indicesArraySize;

/// A pointer to the first position coordinate.
+ (GLvoid *) positionPointer;

// A pointer to the first texture coordinate.
+ (GLvoid *) texturePointer;

@end

NS_ASSUME_NONNULL_END
