// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLObject.h"

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GLObject

- (instancetype)initWithBinding:(GLenum)binding {
  if (self = [super init]) {
    _binding = binding;
  }
  
  return self;
}

- (BOOL)isBound {
  return [self queryBoundValue] == _descriptor;
}

- (GLint)queryBoundValue {
  GLint boundValue;
  GL_ERROR_CHECK(glGetIntegerv(self.binding, &boundValue));
  
  return boundValue;
}

- (UnbindBlockType)bind {
  NSAssert(NO, @"bind method should be implemented by GLObject subclasses.");

  return nil;
}

@end

NS_ASSUME_NONNULL_END
