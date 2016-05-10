// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Returns \c YES if the two images are equal.
BOOL areImagesEqual(UIImage *image1, UIImage *image2);

/// Static interface that provides default shader source codes.
@interface ShadersSource : NSObject 

/// Passthrough vertex shader source code.
+ (NSString *)vertexSource;

/// Default fragment shader source.
+ (NSString *)fragmentSource;

@end

NS_ASSUME_NONNULL_END
