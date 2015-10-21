// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMHandleDictionary.h"
#import "TMMutableHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMMutableHandleDictionary ()

/// The wrapped mutable dictionary used to store the \c TMMutableHandleDictionary's data.
@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation TMMutableHandleDictionary

#pragma mark -
#pragma mark Dictionary Methods
#pragma mark -

- (void)setHandle:(GLuint)handle forKey:(NSString *)key {
  [self.dictionary setObject:[NSNumber numberWithUnsignedInteger:handle] forKey:key];
}

@end

NS_ASSUME_NONNULL_END
