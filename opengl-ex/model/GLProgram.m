// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLProgram.h"

#import <GLKit/GLKit.h>

#import "Defs.h"
#import "GLNamedParametersSet.h"
#import "GLProgramParameter.h"
#import "GLShader.h"
#import "GLVertexAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GLProgram

- (instancetype)initWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment {
  if (self = [super initWithBinding:GL_CURRENT_PROGRAM]) {
    GLShader *vertexShader = [GLShader compiledShaderFromSource:vertex type:GL_VERTEX_SHADER];

    GLShader *fragmentShader = [GLShader compiledShaderFromSource:fragment type:GL_FRAGMENT_SHADER];

    _descriptor = glCreateProgram();
    
    GL_ERROR_CHECK(glAttachShader(_descriptor, vertexShader.descriptor));
    GL_ERROR_CHECK(glAttachShader(_descriptor, fragmentShader.descriptor));
    
    GL_ERROR_CHECK(glLinkProgram(_descriptor));
    
    GLint linkStatus;
    GL_ERROR_CHECK(glGetProgramiv(_descriptor,GL_LINK_STATUS, &linkStatus));
    
    GL_ERROR_CHECK(glDetachShader(_descriptor, fragmentShader.descriptor));
    GL_ERROR_CHECK(glDetachShader(_descriptor, vertexShader.descriptor));
    
    if (linkStatus == GL_FALSE) {
      NSString *message;
      INFO_LOG_EVENT(_descriptor, glGetProgramInfoLog, message)
      @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:message
                                      userInfo:nil];
    }
  }
  
  return self;
}

- (id<VertexAttribute>)vertexAttributeFromProps:(VertexAttributeProps *)props {
  const char *ptr = [props.name cStringUsingEncoding:NSASCIIStringEncoding];
  int index = glGetAttribLocation(_descriptor, ptr);
  if (index < 0) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"Can't find vertex attribute"
                                 userInfo:nil];
  }
  
  GLVertexAttribute *result = [[GLVertexAttribute alloc] initWithProps:props index:index];
  
  return result;
}

- (id<NamedParametersSet>)namedParametersSet {
  GLNamedParametersSet *result = [[GLNamedParametersSet alloc] initWithProgram:self];

  return result;
}

- (NSInteger)parameterIdxByName:(NSString *)name {
  NSInteger result = glGetUniformLocation(_descriptor,
                                          [name cStringUsingEncoding:NSUTF8StringEncoding]);

  return result >= 0 ? result : NSNotFound;
}

- (UnbindBlockType)bind {
  GLint prevProgram = [self queryBoundValue];
  GL_ERROR_CHECK(glUseProgram(_descriptor));
  
  return ^() {
    GL_ERROR_CHECK(glUseProgram(prevProgram));
  };
}

- (void)dealloc {
  GL_ERROR_CHECK(glDeleteProgram(_descriptor));
}

@end

NS_ASSUME_NONNULL_END
