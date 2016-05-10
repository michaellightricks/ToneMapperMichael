// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLBuffer.h"

#import "Defs.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBuffer()

/// Buffer type (element or simple array).
@property (readonly, nonatomic) GLenum type;

@end

@implementation GLBuffer

@synthesize length = _length;

- (instancetype)initElementWithUsage:(BufferUsage)usage {
  if (self = [super initWithBinding:GL_ELEMENT_ARRAY_BUFFER_BINDING]) {
    [self setup:usage];
    _type = GL_ELEMENT_ARRAY_BUFFER;
  }
  
  return self;
}

- (instancetype)initArrayWithUsage:(BufferUsage)usage {
  if (self = [super initWithBinding:GL_ARRAY_BUFFER_BINDING]) {
    [self setup:usage];
    _type = GL_ARRAY_BUFFER;
  }
  
  return self;
}

- (void)setup:(BufferUsage)usage {
  GL_ERROR_CHECK(glGenBuffers(1, &_descriptor));
  _usage = usage;
}

- (void)setBytes:(NSData *)data {
  _length = data.length;
  [Scope bind:self andExecute:^{
    GL_ERROR_CHECK(glBufferData(self.type, data.length, data.bytes, self.usage));
  }];
}

- (void)updateWithData:(NSData *)data destOffset:(NSUInteger)offset {
  [Scope bind:self andExecute:^{
    _length = MAX(data.length, _length);
    GL_ERROR_CHECK(glBufferSubData(self.type, offset, data.length, data.bytes));
  }];
}

- (UnbindBlockType )bind {
  GLint prevBuffer = [self queryBoundValue];
  GL_ERROR_CHECK(glBindBuffer(self.type, _descriptor));
  
  return ^{
    GL_ERROR_CHECK(glBindBuffer(self.type, prevBuffer));
  };
}

- (void)dealloc {
  GL_ERROR_CHECK(glDeleteBuffers(1, &_descriptor));
}

@end

NS_ASSUME_NONNULL_END
