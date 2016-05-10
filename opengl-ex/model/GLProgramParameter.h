// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Bindable.h"

NS_ASSUME_NONNULL_BEGIN

/// Internal interface to hold the program parameter value and action to apply it.
@interface GLProgramParameter : NSObject <Bindable>

/// Returns the string for float parameter encoding identifier.
+ (NSString *)floatEncoding;

/// Returns the string for matrix 4x4 (GLKMatrix4) parameter encoding identifier.
+ (NSString *)matrix4Encoding;

/// Returns the string for texture parameter encoding identifier.
+ (NSString *)textureEncoding;

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the parameter with boxed \c value \c encoding (@encode(Type)) and program \c index.
- (instancetype)initWithValue:(id)value encoding:(NSString *)encoding index:(GLuint)index
    NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
