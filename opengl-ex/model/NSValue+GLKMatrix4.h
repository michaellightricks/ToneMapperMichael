// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

/// \c NSValue category for converting GLKMatrix4.
@interface NSValue (GLKMatrix4)

/// Returns the value of \c NSValue instance as \c GLKMatrix4.
@property (readonly, nonatomic) GLKMatrix4 glkMatrix4Value;

@end

NS_ASSUME_NONNULL_END
