// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Buffers.h"

NS_ASSUME_NONNULL_BEGIN

/// Interface that holds the data needed to apply texture parameter.
@interface TextureParameterProps : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the parameter properties with \c texture and \c textureUnit.
- (instancetype)initWithTexture:(id<Texture2D>)texture unit:(GLenum)textureUnit
    NS_DESIGNATED_INITIALIZER;

/// Texture unit to associate with parameter.
@property (readonly, nonatomic) GLenum textureUnit;

/// Texture to associtate with parameter.
@property (readonly, nonatomic) id<Texture2D> texture;

@end

NS_ASSUME_NONNULL_END
