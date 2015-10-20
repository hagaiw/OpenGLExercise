//
//  TMProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

#import "TMHandleDictionary.h"
#import "TMScalarAttribute.h"

NS_ASSUME_NONNULL_BEGIN

/// An openGL program wrapper object.
@interface TMProgram : NSObject

/// Initialize with attribute names \c attributes, uniform names \c uniforms, \c vertexShaderName
/// and \c fragmentShader name.
- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName;

/// A \c TMHandleDictionary that maps attribute names to \GLuint handles.
@property (readonly, strong, nonatomic) TMHandleDictionary *handlesForAttributes;

/// A \c TMHandleDictionary that maps uniform names to \GLuint handles.
@property (readonly, strong, nonatomic) TMHandleDictionary *handlesForUniforms;

/// Binds the given \c TMScalarProgramPArameter with the program.
- (void)bindScalarParameter:(TMScalarAttribute *)scalarParameter;

/// Calls glUseProgram for the program.
- (void)useProgram;

@end

NS_ASSUME_NONNULL_END
