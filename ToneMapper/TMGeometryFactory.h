// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <Foundation/Foundation.h>
@class TMTexturedGeometry;

/// Factory providing \c TMTextureGeometry objects.
@interface TMGeometryFactory : NSObject

/// Returns a simple quad geometry consisting of 4 vertices with the coordinates: (-1,-1), (-1,1),
/// (1,-1) and (1,1).
- (TMTexturedGeometry *)quadGeometry;

@end
