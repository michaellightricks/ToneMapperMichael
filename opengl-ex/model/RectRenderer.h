// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Buffers.h"
#import "Program.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that renders part of texture using viewing rectangle. Texture is rendered as unit square
/// that mapped with orthographic projection to view space.
@interface RectRenderer : NSObject

/// Clears entire bound framebuffer with specified \c color.
+ (void)clearWithColor:(UIColor *)color;

/// Returns \c Bindable that enables or disables blending.
+ (id<Bindable>)blendingBindableEnabled:(BOOL)enabled;

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the renderer with \c texture to render from and \c program. Program must declare
/// modelViewProjection uniform matrix4, vec2 pos vertex attribute for unit square vertex positions,
/// sampler2D t_source uniform sampler for source texture sampling.
- (instancetype)initWithTexture:(id<Texture2D>)texture program:(id<Program>)program
    NS_DESIGNATED_INITIALIZER;

/// Draws rectangular part \c rect of the \c sourceTexture onto bounded Framebuffer. c\ rect should
/// be given in \c sourceTexture pixel coordinate system.
- (void)drawRect:(CGRect)rect;

/// Renderer's source texture.
@property (readonly, nonatomic) id<Texture2D> sourceTexture;

/// Renderer's associated program.
@property (readonly, nonatomic) id<Program> program;

@end

NS_ASSUME_NONNULL_END
