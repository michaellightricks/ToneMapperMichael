// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "Bindable.h"
#import "Buffers.h"
#import "NamedParametersSet.h"
#import "VertexAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/// Shader program protocol.
@protocol Program <Bindable>

/// Returns instance of \c VertexAttribute created according the \c props data. If no attribute
/// exists with specified name (\c props.name) returns nil.
- (id<VertexAttribute>)vertexAttributeFromProps:(VertexAttributeProps *)props;

/// Creates new set of named parameters.
- (id<NamedParametersSet>)namedParametersSet;

@end

NS_ASSUME_NONNULL_END
