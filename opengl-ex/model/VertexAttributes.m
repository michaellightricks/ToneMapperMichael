// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "VertexAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@implementation VertexAttributeProps

- (instancetype)initWithName:(NSString *)name buffer:(id<Buffer>)buffer
                        type:(enum VertexAttributeType)type
            componentsNumber:(int)componentsNumber stride:(int)stride
                      offset:(int)offset normalized:(BOOL)normalized {
  if (self = [super init]) {
    [self setupName:name buffer:buffer type:type componentsNumber:componentsNumber stride:stride
             offset:offset normalized:normalized];
  }
  
  return self;
}

- (instancetype)initWithName:(NSString *)name buffer:(id<Buffer>)buffer
                        type:(enum VertexAttributeType)type
            componentsNumber:(int)componentsNumber {
  if (self = [super init]) {
    [self setupName:name buffer:buffer type:type componentsNumber:componentsNumber stride:0 offset:0
         normalized:NO];
  }
  
  return self;
}

- (void)setupName:(NSString *)name buffer:(id<Buffer>)buffer type:(enum VertexAttributeType)type
 componentsNumber:(int)componentsNumber stride:(int)stride
           offset:(int)offset normalized:(BOOL)normalized {
  _name = name;
  _buffer = buffer;
  _type = type;
  _componentsNumber = componentsNumber;
  _stride = stride;
  _offset = offset;
  _normalized = normalized;
}

@end

NS_ASSUME_NONNULL_END
