// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>
@class TMTexturedGeometry;

/// Produces \c TMTextureGeometry objects.
@interface TMGeometryFactory : NSObject

/// Simple 4 vertices quad geometry.
- (TMTexturedGeometry *)quadGeometry;

@end
