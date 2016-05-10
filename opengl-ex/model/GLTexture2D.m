// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLTexture2D.h"

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Texture2DProps

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height
                         type:(enum TextureType)type format:(enum TextureFormat)format {
  if (self = [super init]) {
    _width = width;
    _height = height;
    _type = type;
    _format = format;
  }
  
  return self;
}

- (NSUInteger)bitsPerComponent {
  return 8;
}

- (NSUInteger)bitsPerPixel {
  NSUInteger componentsNumber = 0;
  switch (self.format) {
    case TEX_FRMT_RGB:
      componentsNumber = 3;
      break;
    case TEX_FRMT_RGBA:
      componentsNumber = 4;
      break;
    default:
      NSAssert(NO, @"Unsupported format type: %lu", (unsigned long)self.format);
      break;
  }
  
  return componentsNumber * self.bitsPerComponent;
}

@end

@implementation GLTexture2D

@synthesize props = _props;

- (instancetype)initWithProps:(Texture2DProps *)props {
  if (self = [super initWithBinding:GL_TEXTURE_BINDING_2D]) {
    GL_ERROR_CHECK(glGenTextures(1, &_descriptor));
    _props = props;
  }
  
  return self;
}

- (instancetype)initWithInfo:(GLKTextureInfo *)info {
  if (self = [super initWithBinding:GL_TEXTURE_BINDING_2D]) {
    _descriptor = info.name;
    _props = [[Texture2DProps alloc] initWithWidth:info.width height:info.height
                                              type:TEX_TYPE_UNSIGNED_BYTE format:TEX_FRMT_RGBA];
  }
  
  return self;
}

- (UnbindBlockType)bind {
  GLint prevTexture = [self queryBoundValue];
  GL_ERROR_CHECK(glBindTexture(GL_TEXTURE_2D, _descriptor));
  
  return ^{
    GL_ERROR_CHECK(glBindTexture(GL_TEXTURE_2D, prevTexture));
  };
}

- (void)updateWithData:(nullable NSData *)data {
  [Scope bind:self andExecute:^{
    GL_ERROR_CHECK(glTexImage2D(GL_TEXTURE_2D, 0, glFormats[self.props.format], (GLsizei)self.props.width,
                                (GLsizei)self.props.height, 0, glFormats[self.props.format],
                                glTypes[self.props.type], data ? data.bytes : NULL));
  }];
}

- (void)setDefaultParameters {
  [Scope bind:self andExecute:^{
    GL_ERROR_CHECK(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE));
    GL_ERROR_CHECK(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE));
    GL_ERROR_CHECK(glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR));
    GL_ERROR_CHECK(glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR));
  }];
}

- (NSUInteger)handle {
  return _descriptor;
}

- (void)dealloc {
  glDeleteTextures(1, &_descriptor);
}

@end

NS_ASSUME_NONNULL_END
