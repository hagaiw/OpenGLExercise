// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Hagai Weinfeld.

#import "TMProgram.h"

#import "TMScalarUniform.h"
#import "TMHandleDictionary.h"
#import "TMShaderFactory.h"
#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMProgram ()

/// Handle to this program.
@property (nonatomic) GLuint program;

/// This program's vertex shader.
@property (strong, nonatomic) TMShader *vertexShader;

/// This program's fragment shader.
@property (strong, nonatomic) TMShader *fragmentShader;

@end

@implementation TMProgram

typedef NS_ENUM(NSInteger, ProgramParameter) {
  ProgramParameterAttribute,
  ProgramParameterUniform
};

/// Code returns from OpenGL when handle is requested for non existing parameter;
static const GLuint kOpenGLIncorrectParameterName = -1;

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName {
  if (self = [super init]) {
    TMShaderFactory *shaderFactory = [[TMShaderFactory alloc] init];
    self.vertexShader = [shaderFactory shaderForShaderName:vertexShaderName
                                                shaderType:GL_VERTEX_SHADER];
    self.fragmentShader = [shaderFactory shaderForShaderName:fragmentShaderName
                                                  shaderType:GL_FRAGMENT_SHADER];
    self.program = [self programWithVertexShader:self.vertexShader.handle
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
  return [self handleDictionaryForParameters:attributes programHandle:program
                               parameterType:ProgramParameterAttribute];
}

- (TMHandleDictionary *)handleDictionaryFromUniforms:(NSArray *)uniforms
                                       programHandle:(GLuint)program {
  return [self handleDictionaryForParameters:uniforms programHandle:program parameterType:ProgramParameterUniform];
}

- (TMHandleDictionary *)handleDictionaryForParameters:(NSArray *)parameters
                                        programHandle:(GLuint)program
                                        parameterType:(ProgramParameter)type {
  NSMutableDictionary *handlesForParameters = [[NSMutableDictionary alloc] init];
  for (NSString *parameter in parameters) {
    GLuint handle;
    switch (type) {
      case ProgramParameterUniform:
        handle = glGetUniformLocation(program, [parameter UTF8String]);
        if (handle == kOpenGLIncorrectParameterName) {
          NSLog(@"Uniform: %@ does not exist.", parameter);
        }
        break;
      case ProgramParameterAttribute:
        handle = glGetAttribLocation(program, [parameter UTF8String]);
        if (handle == kOpenGLIncorrectParameterName) {
          NSLog(@"Attribute: %@ does not exist.", parameter);
        } else {
          glEnableVertexAttribArray(handle);
        }
        break;
      default:
        break;
    }
    [handlesForParameters setObject:[NSNumber numberWithUnsignedInteger:handle] forKey:parameter];
  }
  return [[TMHandleDictionary alloc] initWithDictionary:handlesForParameters];
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

- (void)bindMatrix:(GLKMatrix4)matrix toUniform:(NSString *)uniform {
  glUniformMatrix4fv([self.handlesForUniforms handleForKey:uniform], 1, GL_FALSE, matrix.m);
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
