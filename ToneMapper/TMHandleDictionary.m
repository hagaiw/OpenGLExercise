//
//  handleDictionary.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMHandleDictionary ()

/// The wrapped dictionary used to store the \c TMHandleDictionary's data.
@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation TMHandleDictionary

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.dictionary = [NSMutableDictionary new];
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
