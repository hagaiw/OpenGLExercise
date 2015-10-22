// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgram.h"

#import "TMScalarUniform.h"
#import "TMMutableHandleDictionary.h"
#import "TMShaderFactory.h"
#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMProgram ()

/// Handle to this program.
@property (readonly, nonatomic) GLuint program;

/// The program's vertex shader.
@property (readonly, strong, nonatomic) TMShader *vertexShader;

/// The program's fragment shader.
@property (readonly, strong, nonatomic) TMShader *fragmentShader;

@end

@implementation TMProgram

/// OpenGL return value when a requested handle doesn't exist;
static const GLuint kOpenGLIncorrectParameterName = -1;

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName {
  if (self = [super init]) {
    TMShaderFactory *shaderFactory = [[TMShaderFactory alloc] init];
    _vertexShader = [shaderFactory shaderForShaderName:vertexShaderName
                                            shaderType:GL_VERTEX_SHADER];
    _fragmentShader = [shaderFactory shaderForShaderName:fragmentShaderName
                                              shaderType:GL_FRAGMENT_SHADER];
    _program = [self programWithVertexShader:self.vertexShader.handle
                              fragmentShader:self.fragmentShader.handle];
    _handlesForAttributes = [self handleDictionaryFromAttributes:attributes
                                                   programHandle:self.program];
    _handlesForUniforms = [self handleDictionaryFromUniforms:uniforms
                                               programHandle:self.program];
  }
  return self;
}

- (GLuint)programWithVertexShader:(GLuint)vertexShader
                         fragmentShader:(GLuint)fragmentShader {
  GLuint program = glCreateProgram();
  glAttachShader(program, vertexShader);
  glAttachShader(program, fragmentShader);
  glLinkProgram(program);
  [self checkLinkageSuccessForProgramHandle:program];
  return program;
}

- (void)checkLinkageSuccessForProgramHandle:(GLuint)programHandle {
  GLint linkSuccess;
  glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"Existing, Program link error: %@", messageString);
    exit(1);
  }
}

- (TMHandleDictionary *)handleDictionaryFromAttributes:(NSArray *)attributes
                                         programHandle:(GLuint)program {
  TMMutableHandleDictionary *mutableHandlesForAttributes = [[TMMutableHandleDictionary alloc] init];
  for (NSString *attribute in attributes) {
    GLuint handle = glGetAttribLocation(program, [attribute UTF8String]);
    if (handle == kOpenGLIncorrectParameterName) {
      NSLog(@"Uniform %@ does not exist.", attribute);
    } else {
      glEnableVertexAttribArray(handle);
    }
    [mutableHandlesForAttributes setHandle:handle forKey:attribute];
  }
  return mutableHandlesForAttributes;
}

- (TMHandleDictionary *)handleDictionaryFromUniforms:(NSArray *)uniforms
                                       programHandle:(GLuint)program {
  TMMutableHandleDictionary *mutableHandlesForUniforms = [[TMMutableHandleDictionary alloc] init];
  for (NSString *uniform in uniforms) {
    GLuint handle = glGetUniformLocation(program, [uniform UTF8String]);
    if (handle == kOpenGLIncorrectParameterName) {
      NSLog(@"Uniform %@ does not exist.", uniform);
    }
    [mutableHandlesForUniforms setHandle:handle forKey:uniform];
  }
  return mutableHandlesForUniforms;
}

#pragma mark -
#pragma mark OpenGL Binding
#pragma mark -

- (void)useProgram {
  glUseProgram(self.program);
  GLint error;
  if (glGetError() != 0) {
    NSLog(@"Error using program: %d", error);
  }
}

- (void)bindScalarUniform:(TMScalarUniform *)scalarUniform {
  glUniform1f([self.handlesForUniforms handleForKey:scalarUniform.name], scalarUniform.value);
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  glDeleteProgram(self.program);
  GLint error;
  if (glGetError() != 0) {
    NSLog(@"Error deleting program: %d", error);
  }
}


@end

NS_ASSUME_NONNULL_END
