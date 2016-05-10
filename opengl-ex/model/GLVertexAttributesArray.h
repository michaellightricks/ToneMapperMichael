// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "GLObject.h"
#import "VertexAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that implements VAO.
@interface GLVertexAttributesArray : GLObject <VertexAttributesArray>

- (instancetype)initWithBinding:(GLenum)binding NS_UNAVAILABLE;

/// Initializes the VAO with array of attributes.
- (instancetype)initWithAttributes:(NSArray<id<VertexAttribute>> *)attributes;

@end

NS_ASSUME_NONNULL_END
