// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Buffers.h"

NS_ASSUME_NONNULL_BEGIN

/// Enum for attribute element data type.

typedef NS_ENUM(NSUInteger, VertexAttributeType) {
  ATTR_BYTE,
  ATTR_UNSIGNED_BYTE,
  ATTR_SHORT,
  ATTR_UNSIGNED_SHORT,
  ATTR_FIXED,
  ATTR_FLOAT
};

/// Pure data object that describes the properties of the vertex attribute.
@interface VertexAttributeProps : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the properties of the attribute with \c name (specified in program) \c buffer
/// \c type (see VertexAttributeType values) \c componentsNumber (can be 1,2,3,4) \c stride \c offset
/// and \c normalize.
- (instancetype)initWithName:(NSString *)name buffer:(id<Buffer>)buffer
                        type:(VertexAttributeType)type
            componentsNumber:(int)componentsNumber stride:(int)stride
                      offset:(int)offset normalized:(BOOL)normalized NS_DESIGNATED_INITIALIZER;

/// Initializes the properties of the attribute with \c name (specified in program) \c buffer
/// \c type (see VertexAttributeType values) \ componentsNumber (can be \c 1, \c 2, c\ 3, c\ 4).
- (instancetype)initWithName:(NSString *)name buffer:(id<Buffer>)buffer
                        type:(VertexAttributeType)type
            componentsNumber:(int)componentsNumber NS_DESIGNATED_INITIALIZER;

/// Name of the attribute as specified in shader program.
@property (readonly, nonatomic) NSString *name;

/// Buffer that serves as storage for attribute.
@property (readonly, nonatomic) id<Buffer> buffer;

/// Type of each attribute component.
@property (readonly, nonatomic) VertexAttributeType type;

/// Number of attribute components can be \c 1, \c 2, \c 3, \c 4 (default).
@property (readonly, nonatomic) int componentsNumber;

/// Offset between consecutive attributes. If \c 0 treated as tightly packed otherwise interleaved.
@property (readonly, nonatomic) int stride;

/// Offset from the beginning of single vertex data (default is \c 0).
@property (readonly, nonatomic) int offset;

/// When set to \c YES, the vertex data should be normalized before passing it to the shader.
@property (readonly, nonatomic) BOOL normalized;

@end

/// Object that describes association of named vertex attribute to buffer storage.
@protocol VertexAttribute <Bindable>

/// Vertex attributes pure data properties structure.
@property (readonly, nonatomic) VertexAttributeProps *props;

@end

/// Object that describes list of \c VertexAttributes and its association to buffers as storage.
@protocol VertexAttributesArray <Bindable>

/// List of associated attributes.
@property (readonly, nonatomic) NSArray<id<VertexAttribute>> *attributes;

@end

NS_ASSUME_NONNULL_END
