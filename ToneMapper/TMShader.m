// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.
#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMShader

/// Expected file extension for the given shader name.
static NSString * const kShaderFileExtension = @"glsl";

/// Error message to present in the case of a compilation error.
static NSString * const kShaderCompileErrorMessage = @"Error loading shader: %@";

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)initWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType {
  if (self = [super init]) {
    _handle = [self compileShader:shaderName withType:shaderType];
  }
  return self;
}

#pragma mark -
#pragma mark Compilation
#pragma mark -

/// Taken from: http://www.raywenderlich.com/3664/opengl-tutorial-for-ios-opengl-es-2-0
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
  NSString* shaderString = [self shaderTextForShader:shaderName];
  GLuint shaderHandle = [self compileShaderWithContents:shaderString type:shaderType];
  return shaderHandle;
}

- (NSString *)shaderTextForShader:(NSString *)shaderName {
  NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                         ofType:kShaderFileExtension];
  NSError *error;
  NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                     encoding:NSUTF8StringEncoding error:&error];
  if (!shaderString) {
    NSLog(kShaderCompileErrorMessage, error.localizedDescription);
    exit(1);
  }
  return shaderString;
}

- (GLuint)compileShaderWithContents:(NSString *)shaderContents type:(GLenum)shaderType {
  GLuint shaderHandle = glCreateShader(shaderType);
  const char * shaderStringUTF8 = [shaderContents UTF8String];
  int shaderStringLength = (int)[shaderContents length];
  glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
  glCompileShader(shaderHandle);
  [self compilationSuccessForShaderHandle:shaderHandle];
  return shaderHandle;
}

- (void)compilationSuccessForShaderHandle:(GLuint)handle {
  GLint compileSuccess;
  glGetShaderiv(handle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetShaderInfoLog(handle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  glDeleteShader(self.handle);
}

@end

NS_ASSUME_NONNULL_END
