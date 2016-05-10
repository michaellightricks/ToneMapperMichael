// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLShader.h"

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GLShader

+ (instancetype)compiledShaderFromSource:(NSString *)source type:(GLenum)type {
  GLShader *shader = [[GLShader alloc] initWithSource:source type:type];
  [shader compile];
  
  return shader;
}

- (instancetype)initWithSource:(NSString *)source type:(GLenum)type {
  if (self = [super init]) {
    _descriptor = glCreateShader(type);

    const char *sourcePtr = source.UTF8String;
    GL_ERROR_CHECK(glShaderSource(_descriptor, 1, &sourcePtr, NULL));
  }
  
  return self;
}

- (void)compile {
  GL_ERROR_CHECK(glCompileShader(self.descriptor));
  
  GLint success = 0;
  GL_ERROR_CHECK(glGetShaderiv(self.descriptor, GL_COMPILE_STATUS, &success));
  
  if (success == GL_FALSE) {
    NSString *message;
    INFO_LOG_EVENT(self.descriptor, glGetShaderInfoLog, message)
    @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:message
                                    userInfo:nil];
  }
}

- (void)dealloc {
  GL_ERROR_CHECK(glDeleteShader(_descriptor));
}

@end

NS_ASSUME_NONNULL_END
