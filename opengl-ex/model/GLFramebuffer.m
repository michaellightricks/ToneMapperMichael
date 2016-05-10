// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLFramebuffer.h"

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GLFramebuffer

@synthesize colorAttachment = _colorAttachment;

- (instancetype)initWithTexture:(id<Texture2D>)texture {
  if (self = [super initWithBinding:GL_FRAMEBUFFER_BINDING]) {
    GL_ERROR_CHECK(glGenFramebuffers(1, &_descriptor));
    _colorAttachment = texture;

    [Scope bind:self andExecute:^{
      [Scope bind:self.colorAttachment andExecute:^{
        GL_ERROR_CHECK(glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                              GL_TEXTURE_2D, (GLuint)self.colorAttachment.handle,
                                              0));
      }];
    }];
  }
  
  return self;
}

- (UnbindBlockType)bind {
  GLint prevFramebuffer = [self queryBoundValue];
  RectI prevViewPort;
  GL_ERROR_CHECK(glGetIntegerv(GL_VIEWPORT, (GLint *)&prevViewPort));

  GL_ERROR_CHECK(glBindFramebuffer(GL_FRAMEBUFFER, _descriptor));

  GL_ERROR_CHECK(glViewport(0, 0, (GLsizei)self.colorAttachment.props.width,
                            (GLsizei)self.colorAttachment.props.height));
  return ^{
    GL_ERROR_CHECK(glBindFramebuffer(GL_FRAMEBUFFER, prevFramebuffer));
    GL_ERROR_CHECK(glViewport(prevViewPort.x, prevViewPort.y, (GLsizei)prevViewPort.width,
                              (GLsizei)prevViewPort.height));
  };
}

- (void)readPixelsFromRect:(RectI)rect toData:(NSMutableData *)data {
  NSAssert(_colorAttachment != nil, @"Color attachment should be set to nonnil.");

  GL_ERROR_CHECK(glReadPixels(rect.x, rect.y, rect.width, rect.height,
                              glFormats[self.colorAttachment.props.format],
                              glTypes[self.colorAttachment.props.type], data.mutableBytes));
}

- (nullable NSError *)checkStatus {
  NSError *result = nil;
  
  GLenum err = glCheckFramebufferStatus(GL_FRAMEBUFFER);
  if (err != GL_FRAMEBUFFER_COMPLETE) {
    NSString *message = [NSString stringWithFormat:@"FramebufferStatus %d", err];
    result = [NSError errorWithDomain:@"" code:err userInfo:@{@"message": message}];
  }

  return result;
}

- (void)dealloc {
  glDeleteFramebuffers(1, &_descriptor);
}

@end

RectI RectIMake(int32_t x, int32_t y, int32_t width, int32_t heigth) {
  RectI result;
  
  result.x = x;
  result.y = y;
  result.width = width;
  result.height = heigth;
  
  return result;
}

NS_ASSUME_NONNULL_END
