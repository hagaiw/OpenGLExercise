// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

@import GLKit;

@class TMHandleDictionary;

NS_ASSUME_NONNULL_BEGIN

/// Protocol for OpenGL uniform variable wrappers.
@protocol TMUniform <NSObject>

/// Links the uniform to the handle as it appears in the given \c handleDictionary.
- (void)linkToProgramWithHandleDictionary:(TMHandleDictionary *)handleDictionary;

/// Name of the uniform variable as it appears in the shader.
@property (readonly, strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
