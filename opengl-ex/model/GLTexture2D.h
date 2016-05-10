// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Buffers.h"
#import "GLObject.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of opengl 2D texture object wrapper.
@interface GLTexture2D : GLObject <Texture2D>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithBinding:(GLenum)binding NS_UNAVAILABLE;

/// Initilizes the texture object with metadata - \c props.
- (instancetype)initWithProps:(Texture2DProps *)props NS_DESIGNATED_INITIALIZER;

/// Initializes texture from \c GLKit texture \c info of preallocated texture.
- (instancetype)initWithInfo:(GLKTextureInfo *)info NS_DESIGNATED_INITIALIZER;

/// Sets default texture parametes.
- (void)setDefaultParameters;

@end

NS_ASSUME_NONNULL_END
