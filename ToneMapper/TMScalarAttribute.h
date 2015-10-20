//
//  TMTextureParameter.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/14/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A value class composed of a name-value pair representing a scalar program attribute.
@interface TMScalarAttribute : NSObject

/// Initialize with \c name, \c value.
- (instancetype)initWithName:(NSString *)name value:(GLfloat)value;

/// The name of the attribute in the shader.
@property (readonly, strong, nonatomic) NSString *name;

/// The value of the attribute.
@property (readonly, nonatomic) GLfloat value;

@end

NS_ASSUME_NONNULL_END
