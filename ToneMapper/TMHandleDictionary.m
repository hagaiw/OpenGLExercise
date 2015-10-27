// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMHandleDictionary ()

/// Wrapped dictionary used to store the \c TMHandleDictionary's data.
@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation TMHandleDictionary

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    self.dictionary = [dictionary copy];
  }
  return self;
}

#pragma mark -
#pragma mark Dictionary Methods
#pragma mark -

- (GLuint)handleForKey:(NSString *)key {
  NSNumber *value = [self.dictionary objectForKey:key];
  return (GLuint)[value unsignedIntegerValue];
}

@end

NS_ASSUME_NONNULL_END
