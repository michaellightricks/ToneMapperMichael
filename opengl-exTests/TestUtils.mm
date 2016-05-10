// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "TestUtils.h"

#import <UIKit/UIKit.h>

#import "UIImageUtils.h"

NS_ASSUME_NONNULL_BEGIN

BOOL areImagesEqual(UIImage *image1, UIImage *image2) {
  NSData *image1Data = [UIImageUtils dataFromImage:image1];
  NSData *image2Data = [UIImageUtils dataFromImage:image2];

  BOOL equals = [image1Data isEqualToData:image2Data];

  return equals;
}

@implementation ShadersSource

+ (NSString *)vertexSource {
  return @"precision mediump float;"
  "uniform mat4 projectionViewModel;"
  "attribute vec2 pos;"
  "varying vec2 v_texcoord;"
  "void main() {"
  "v_texcoord = pos;"
  "gl_Position = projectionViewModel * vec4(pos, 0.0, 1.0);"
  "}";
}

+ (NSString *)fragmentSource {
  return @"precision mediump float;"
  "uniform sampler2D t_source;"
  "varying vec2 v_texcoord;"
  "void main() {"
  "vec4 color = texture2D(t_source, v_texcoord);"
  "gl_FragColor = color;"
  "}";
}

@end

NS_ASSUME_NONNULL_END
