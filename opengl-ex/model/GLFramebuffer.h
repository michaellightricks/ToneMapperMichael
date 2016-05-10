// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "Bindable.h"
#import "Framebuffer.h"
#import "GLObject.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of opengl framebuffer object wrapper.
@interface GLFramebuffer : GLObject <Framebuffer>

/// Initializes the Framebuffer object with given texture as color attachment.
- (instancetype)initWithTexture:(id<Texture2D>)texture NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithBinding:(GLenum)binding NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
