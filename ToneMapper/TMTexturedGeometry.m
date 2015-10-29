// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMTexturedGeometry.h"
#import "TMVertices.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTexturedGeometry ()

/// The \c GLuint handle of the generated vertex buffer.
@property (nonatomic) GLuint vertexBuffer;

/// The \c GLuint handle of the generated index buffer.
@property (nonatomic) GLuint indexBuffer;

/// The \TMTexturedVertices object to use for this geometry.
@property (nonatomic) id<TMVertices> vertices;

@end

@implementation TMTexturedGeometry

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithTexturedVertices:(id<TMVertices>)texturedVertices {
  if (self = [super init]) {
    self.vertices = texturedVertices;
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
    [self bind];
    glBufferData(GL_ARRAY_BUFFER, [self.vertices verticesArraySize],
                 [self.vertices vertices], GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.vertices indicesArraySize],
                 [self.vertices indices], GL_STATIC_DRAW);
  }
  return self;
}

#pragma mark -
#pragma mark OpenGL Methods
#pragma mark -

- (void)bind {
  glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indexBuffer);
}

- (void)linkPositionArrayToAttribute:(GLuint)positionHandle {
  glVertexAttribPointer(positionHandle, [self.vertices numOfPositionCoordinates],
                        [self.vertices positionType], GL_FALSE, [self.vertices vertexSize],
                        [self.vertices positionPointer]);
}

- (void)linkTextureArrayToAttribute:(GLuint)textureHandle {
  glVertexAttribPointer(textureHandle, [self.vertices numOfTextureCoordinates],
                        [self.vertices textureType], GL_FALSE, [self.vertices vertexSize],
                        [self.vertices texturePointer]);
}

- (GLuint)numberOfIndices {
  return [self.vertices numOfIndices];
}

@end

NS_ASSUME_NONNULL_END
