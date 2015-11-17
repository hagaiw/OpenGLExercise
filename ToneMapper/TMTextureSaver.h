// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import <UIKit/UIKit.h>

@class TMTexture;

NS_ASSUME_NONNULL_BEGIN

/// Object in charge of saving \c TMTexture objects to disk.
@interface TMTextureSaver : NSObject

/// Saves the given \c texture to photo album.
- (void)saveTexture:(TMTexture *)texture;

@end

NS_ASSUME_NONNULL_END
