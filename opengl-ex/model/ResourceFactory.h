// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Buffers.h"
#import "Framebuffer.h"
#import "Program.h"
#import "VertexAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/// Static interface that provides method for graphics objects and resources creation.
@interface ResourceFactory : NSObject

/// Creates new element buffer (indices) with bytes from \c data.
+ (id<Buffer>)elementBufferWithBytes:(NSData *)data;

/// Creates new dynamic array buffer (indices) with bytes from \c data. Dynamic buffer is a buffer
/// with data modified repeatedly and used many times.
+ (id<Buffer>)dynamicBufferWithBytes:(NSData *)data;

/// Creates new static array buffer (indices) with bytes at \c ptr and \c length. Static buffer is a
/// buffer with data that is not modified and used many times.
+ (id<Buffer>)staticBufferWithBytes:(NSData *)data;

/// Creates new VertexAttributesArray with given list of \c attributes. \c VertexAttributesArray is
/// convinience object that may be bound once instead off binding all its \c attributes.
+ (id<VertexAttributesArray>)vertexAttributesArray:(NSArray<id<VertexAttribute>> *)attributes;

/// Creates new compiled and linked shader program from provided souces.
+ (id<Program>)programWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment;

/// Creates new compiled and linked shader program by loading sources from default bundle using
/// provided \c resourceName. File extensions assumed to be .vsh for vertex shader and .fsh for
/// fragment shader.
+ (nullable id<Program>)programFromBundleWithResourceName:(NSString *)resourceName;

/// Creates new texture from provided \c props and data stored at \c data. If data is nil texture is
/// allocated to accomodate the size specified by props but memory is not initalized.
+ (id<Texture2D>)textureWithProps:(Texture2DProps *)props andData:(nullable NSData *)data;

/// Creates new texture from \c NSData instance.
+ (id<Texture2D>)textureFromData:(NSData *)data;

/// Creates new Framebuffer with associated \c texture.
+ (id<Framebuffer>)frameBufferWithTexture:(id<Texture2D>)texture;

@end

NS_ASSUME_NONNULL_END
