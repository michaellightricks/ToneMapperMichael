// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GLObject.h"
#import "VertexAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of opengl vertex attribute bindable object wrapper.
@interface GLVertexAttribute : NSObject <VertexAttribute>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the attribute with layout \c props and \c index associated by program.
- (instancetype)initWithProps:(VertexAttributeProps *)props index:(GLuint)index
    NS_DESIGNATED_INITIALIZER;

/// Index of attribute that was associated to its name by program.
@property (readonly, nonatomic) GLuint index;

@end

NS_ASSUME_NONNULL_END
