//
//  TMProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgram.h"

#import "TMMutableHandleDictionary.h"
#import "TMShaderFactory.h"
#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMProgram ()

/// The handle for the program.
@property (nonatomic) GLuint program;

/// A \c TMHandleDictionary that maps attribute names to \GLuint handles.
@property (readwrite, strong, nonatomic) TMHandleDictionary *handlesForAttributes;

/// A \c TMHandleDictionary that maps uniform names to \GLuint handles.
@property (readwrite, strong, nonatomic) TMHandleDictionary *handlesForUniforms;

/// The program's vertex shader.
@property (strong, nonatomic) TMShader *vertexShader;

/// The program's fragment shader.
@property (strong, nonatomic) TMShader *fragmentShader;

@end

@implementation TMProgram

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
    self.handlesForAttributes = [self handleDictionaryFromAttributes:attributes
                                                       programHandle:self.program];
    self.handlesForUniforms = [self handleDictionaryFromUniforms:uniforms
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
  
  // Check linkage success.
  GLint linkSuccess;
  glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"Existing, Program link error: %@", messageString);
    exit(1);
  }
  return program;
}

- (TMHandleDictionary *)handleDictionaryFromAttributes:(NSArray *)attributes
                                         programHandle:(GLuint)program {
  TMMutableHandleDictionary *mutableHandlesForAttributes = [[TMMutableHandleDictionary alloc] init];
  for (NSString *attribute in attributes) {
    GLuint handle = glGetAttribLocation(program, [attribute UTF8String]);
    glEnableVertexAttribArray(handle);
    [mutableHandlesForAttributes setHandle:handle forKey:attribute];
  }
  return mutableHandlesForAttributes;
}

- (TMHandleDictionary *)handleDictionaryFromUniforms:(NSArray *)uniforms
                                       programHandle:(GLuint)program {
  TMMutableHandleDictionary *mutableHandlesForUniforms = [[TMMutableHandleDictionary alloc] init];
  for (NSString *uniform in uniforms) {
    GLuint handle = glGetUniformLocation(program, [uniform UTF8String]);
    [mutableHandlesForUniforms setHandle:handle forKey:uniform];
  }
  return mutableHandlesForUniforms;
}

#pragma mark -
#pragma mark OpenGL Binding
#pragma mark -

- (void)useProgram {
  glUseProgram(self.program);
}

- (void)bindScalarParameter:(TMScalarAttribute *)scalarParameter {
  glUniform1f([self.handlesForUniforms handleForKey:scalarParameter.name], scalarParameter.value);
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  glDeleteProgram(self.program);
}


@end

NS_ASSUME_NONNULL_END
