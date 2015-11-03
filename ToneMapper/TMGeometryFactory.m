// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMGeometryFactory.h"
#import "TMQuadTexturedVertices.h"
#import "TMTexturedGeometry.h"

@implementation TMGeometryFactory

- (TMTexturedGeometry *)quadGeometry {
  return [[TMTexturedGeometry alloc]
          initWithTexturedVertices:[[TMQuadTexturedVertices alloc] init]];
}

@end
