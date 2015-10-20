//
//  handleDictionary.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// An \c NSDictionary wrapper to be used with \c GLuint openGL handlers.
@interface TMHandleDictionary : NSObject

/// Returns the handle associated with the given key.
- (GLuint)handleForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
