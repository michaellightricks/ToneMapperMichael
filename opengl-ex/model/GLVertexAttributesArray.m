// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLVertexAttributesArray.h"

#import <OpenGLES/ES2/glext.h>

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLVertexAttributesArray()

/// Internal mutable array for attributes.
@property (readonly, nonatomic) NSMutableArray<id<VertexAttribute>> *attributesMutable;

@end

@implementation GLVertexAttributesArray

- (instancetype)initWithAttributes:(NSArray<id<VertexAttribute>> *)attributes {
  if (self = [super initWithBinding:(GL_VERTEX_ARRAY_BINDING_OES)]) {
    GL_ERROR_CHECK(glGenVertexArraysOES(1, &_descriptor));
    _attributesMutable = [NSMutableArray arrayWithArray:attributes];
    
    UnbindBlockType unbind = [self bind];
    [Scope bindCollection:_attributesMutable andExecute:^{
      unbind();
    }];
  }
  
  return self;
}

- (UnbindBlockType)bind {
  GLint prevVAO = [self queryBoundValue];
  GL_ERROR_CHECK(glBindVertexArrayOES(_descriptor));
  
  return ^ {
    GL_ERROR_CHECK(glBindVertexArrayOES(prevVAO));
  };
}

- (void)dealloc {
  GL_ERROR_CHECK(glDeleteVertexArraysOES(1, &_descriptor));
}

- (NSArray<id<VertexAttribute>> *)attributes {
  return [_attributesMutable copy];
}

@end

NS_ASSUME_NONNULL_END
