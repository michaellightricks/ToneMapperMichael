// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Buffers.h"
#import "GLObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BufferUsage) {
  BufferUsageStatic = GL_STATIC_DRAW,
  BufferUsageDynamic = GL_DYNAMIC_DRAW,
  BufferUsageStream = GL_STREAM_DRAW
};

/// Opengl buffer wrapper.
@interface GLBuffer : GLObject <Buffer>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithBinding:(GLenum)binding NS_UNAVAILABLE;

/// Initilizes GPU memory buffer name for vertex data for specific usage (static, dynamic, read,
/// write etc. see opengl documentation.
- (instancetype)initArrayWithUsage:(BufferUsage)usage NS_DESIGNATED_INITIALIZER;

/// Initializes GPU memory buffer name for elements data for specific usage (static, dynamic, read,
/// write etc.). See opengl documentation.
- (instancetype)initElementWithUsage:(BufferUsage)usage NS_DESIGNATED_INITIALIZER;

/// Creates buffer by copying \c length bytes from \ptr to GPU memory.
- (void)setBytes:(NSData *)data;

/// Buffers desired usage.
@property (readonly, nonatomic) BufferUsage usage;

@end

NS_ASSUME_NONNULL_END
