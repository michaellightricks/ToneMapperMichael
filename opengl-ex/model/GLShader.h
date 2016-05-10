// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Macro that gets the message of info log according to specific function gl*InfoLog function.
#define INFO_LOG_EVENT(descriptor, infoLogFunc, message) \
  GLint logSize = 0; \
  glGetShaderiv(descriptor, GL_INFO_LOG_LENGTH, &logSize); \
  char *msgStorage = malloc(sizeof(char) * logSize); \
  infoLogFunc(descriptor, logSize, &logSize, msgStorage); \
  message = [NSString stringWithUTF8String:msgStorage]; \
  free(msgStorage); \

/// Opengl shader representation - binds and compiles the shader source.
@interface GLShader : NSObject

/// Allocates and intializes compiled shader given its \c source text and \c type. If there were
/// some compilation errors the compiler message is contained in \c NSException \c reason property
/// raised by method.
+ (instancetype)compiledShaderFromSource:(NSString *)source type:(GLenum)type;

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the shader with \c source and \type.
- (instancetype)initWithSource:(NSString *)source type:(GLenum)type NS_DESIGNATED_INITIALIZER;

/// Performs shader compilation. If there were some compilation errors the compiler message is
/// contained in \c NSException \c reason property rised by method.
- (void)compile;

/// Shaders opengl \c descriptor.
@property (readonly, nonatomic) GLuint descriptor;

@end

NS_ASSUME_NONNULL_END
