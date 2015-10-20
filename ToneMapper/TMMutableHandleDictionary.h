//
//  TMMutableHandleDictionary.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMHandleDictionary.h"

NS_ASSUME_NONNULL_BEGIN

/// A Mutable version of \c TMHandleDictioanry.
@interface TMMutableHandleDictionary : TMHandleDictionary

/// Add the given \c key - \c handle pair to the dictionary.
- (void)setHandle:(GLuint)handle forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
