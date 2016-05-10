// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "UIImageUtils.h"

#import "Buffers.h"
#import "ResourceFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIImageUtils

+ (UIImage *)renderRect:(RectI)viewportRect withRenderer:(RectRenderer *)renderer
             clearColor:(UIColor *)clearColor {
  Texture2DProps *texProps =
      [[Texture2DProps alloc] initWithWidth:viewportRect.width
                                     height:viewportRect.height
                                       type:TEX_TYPE_UNSIGNED_BYTE format:TEX_FRMT_RGBA];
  
  id<Texture2D> targetTexture = [ResourceFactory textureWithProps:texProps andData:NULL];
  
  id<Framebuffer> frameBuffer = [ResourceFactory frameBufferWithTexture:targetTexture];

  size_t bytesCount = texProps.width * texProps.height * (texProps.bitsPerPixel / 8);

  NSMutableData *data = [NSMutableData dataWithLength:bytesCount];

  [Scope bind:frameBuffer andExecute:^{
    NSError *error = [frameBuffer checkStatus];
    if (error) {
      NSLog(@"%@", [error.userInfo valueForKey:@"message"]);
      @throw [NSException exceptionWithName:NSInvalidArgumentException
                                     reason:@"Framebuffer checkStatus" userInfo:nil];
    }

    [RectRenderer clearWithColor:clearColor];

    // we want to render upside down since opengl texture memory layout is origin at left bottom.
    CGRect rect = CGRectMake(0, viewportRect.height,
                             viewportRect.width, -(float)viewportRect.height);
    [renderer drawRect:rect];
    
    [frameBuffer readPixelsFromRect:viewportRect toData:data];
  }];

  return [UIImageUtils imageFromData:data props:texProps];
}

+ (id<Texture2D>)textureFromImage:(UIImage *)image {
  NSData *data = [UIImageUtils dataFromImage:image];

  Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:image.size.width * image.scale
                                                         height:image.size.height * image.scale
                                                           type:TEX_TYPE_UNSIGNED_BYTE
                                                         format:TEX_FRMT_RGBA];
  
  id<Texture2D> texture = [ResourceFactory textureWithProps:props andData:data];


  return texture;
}

+ (nullable UIImage *)imageFromData:(NSData *)data props:(Texture2DProps *)props {
  size_t bytesPerRow = (props.bitsPerPixel / 8) * props.width;

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

  CGDataProviderRef dataProviderRef = CGDataProviderCreateWithCFData((CFDataRef)data);

  CGImageRef cgImage =
      CGImageCreate(props.width, props.height, props.bitsPerComponent, props.bitsPerPixel,
                    bytesPerRow, colorSpace,
                    kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast, dataProviderRef,
                    NULL, false, kCGRenderingIntentDefault);

  if (!cgImage) {
    CGDataProviderRelease(dataProviderRef);
    return nil;
  }

  UIImage *result = [UIImage imageWithCGImage:cgImage];

  CGImageRelease(cgImage);
  CGDataProviderRelease(dataProviderRef);

  return result;
}

+ (nullable NSData *)dataFromImage:(UIImage *)image {
  CGSize size = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);

  size_t bytesLength = size.width * size.height * 4 * sizeof(unsigned char);

  NSMutableData *data = [NSMutableData dataWithLength:bytesLength];
  if (!data) {
    return nil;
  }

  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  if (!colorSpaceRef) {
    return nil;
  }

  CGContextRef spriteContext = CGBitmapContextCreate(data.mutableBytes, size.width, size.height, 8,
                                                     size.width * 4, colorSpaceRef,
                                                     kCGImageAlphaPremultipliedLast |
                                                     kCGBitmapByteOrderDefault);
  CGColorSpaceRelease(colorSpaceRef);

  if (!spriteContext) {
    return nil;
  }

  UIGraphicsPushContext(spriteContext);

  CGContextTranslateCTM(spriteContext, 0.0, size.height);
  CGContextScaleCTM(spriteContext, 1.0, -1.0);

  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  
  UIGraphicsPopContext();
  
  CGContextRelease(spriteContext);
  
  return data;
}

@end

NS_ASSUME_NONNULL_END
