// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Buffers.h"
#import "Framebuffer.h"
#import "RectRenderer.h"

NS_ASSUME_NONNULL_BEGIN

/// Static interface providing convinience methods for image data manipulation.
@interface UIImageUtils : UIView

/// Returns \c UIImage instance created from \c dataPtr according to size and formats specified with
/// \c props, in case of failure returns \c nil.
+ (nullable UIImage *)imageFromData:(NSData *)dataPtr props:(Texture2DProps *)props;

/// Returns the image data after applying orientation as NSData instance. In case of failure returns
/// \c nil.
+ (nullable NSData *)dataFromImage:(UIImage *)image;

/// Renders sub rectangle to \c UIImage using \c renderer and \c clearColor.
+ (UIImage *)renderRect:(RectI)rect withRenderer:(RectRenderer *)renderer
             clearColor:(UIColor *)clearColor;

/// Creates texture from \c image.
+ (id<Texture2D>)textureFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
