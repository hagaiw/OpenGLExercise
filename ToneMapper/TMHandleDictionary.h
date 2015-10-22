// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// An \c NSDictionary wrapper to be used with \c GLuint openGL handlers.
@interface TMHandleDictionary : NSObject

/// Initialize with a \c dictionary of \c NSString name keys and \c NSNumber handle values.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

/// Returns the handle associated with the given key.
- (GLuint)handleForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
