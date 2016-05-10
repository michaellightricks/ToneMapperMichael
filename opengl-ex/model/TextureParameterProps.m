// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "TextureParameterProps.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TextureParameterProps

- (instancetype)initWithTexture:(id<Texture2D>)texture unit:(GLenum)textureUnit {
  if (self = [super init]) {
    _texture = texture;
    _textureUnit = textureUnit;
  }

  return self;
}

@end

NS_ASSUME_NONNULL_END
