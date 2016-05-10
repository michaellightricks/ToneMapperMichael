// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLVertexAttribute.h"

#import "Defs.h"
#import "GLObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLVertexAttribute()

/// Opengl enum for attribute type.
@property (readonly, nonatomic) GLenum glType;

@end

@implementation GLVertexAttribute

@synthesize props = _props;



+ (GLenum)glType:(VertexAttributeType)type {
  /// Mapping from VertexAttributeType to GLenum.
  static GLenum _typesMap[6];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _typesMap[ATTR_BYTE] = GL_BYTE;
    _typesMap[ATTR_UNSIGNED_BYTE] = GL_UNSIGNED_BYTE;
    _typesMap[ATTR_SHORT] =  GL_SHORT;
    _typesMap[ATTR_UNSIGNED_SHORT] =  GL_UNSIGNED_SHORT;
    _typesMap[ATTR_FIXED] =  GL_FIXED;
    _typesMap[ATTR_FLOAT] =  GL_FLOAT;
  });

  return _typesMap[type];
}

- (instancetype)initWithProps:(VertexAttributeProps *)props index:(GLuint)index {
  if (self = [super init]) {
    _props = props;
    _index = index;
    _glType = [GLVertexAttribute glType:props.type];
  }
  
  return self;
}

- (UnbindBlockType)bind {
  GLint prevEnabled = [self isBound];
  glGetVertexAttribiv(self.index, GL_VERTEX_ATTRIB_ARRAY_ENABLED, &prevEnabled);

  [Scope bind:self.props.buffer andExecute:^{
    NSUInteger offset = self.props.offset;

    GL_ERROR_CHECK(glEnableVertexAttribArray(self.index));
    GL_ERROR_CHECK(glVertexAttribPointer(self.index, self.props.componentsNumber, self.glType,
                                          self.props.normalized, self.props.stride,
                                         (void *)offset));
  }];

  return ^{
    if (!prevEnabled) {
      GL_ERROR_CHECK(glDisableVertexAttribArray(self.index));
    }
  };
}

- (BOOL)isBound {
  GLint enabled;
  glGetVertexAttribiv(self.index, GL_VERTEX_ATTRIB_ARRAY_ENABLED, &enabled);
  return enabled;
}

@end

NS_ASSUME_NONNULL_END
