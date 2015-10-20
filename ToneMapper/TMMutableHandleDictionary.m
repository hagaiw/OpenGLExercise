//
//  TMMutableHandleDictionary.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

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
