//
//  TMDisplayData.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Value class holding translation and scale parameters.
@interface TMPosition : NSObject

/// Initialize with \c translation, \c scale.
- (instancetype)initWithTranslation:(CGPoint)translation scale:(CGFloat)scale;

- (TMPosition *)poistionByAddingPosition:(TMPosition *)position;

/// Translation values.
@property (readonly, nonatomic) CGPoint tranlsation;

/// Scale value.
@property (readonly, nonatomic) CGFloat scale;

@end

NS_ASSUME_NONNULL_END
