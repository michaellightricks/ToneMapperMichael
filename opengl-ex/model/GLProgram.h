// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "GLObject.h"
#import "Program.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that manages program with vertex and fragment shaders.
@interface GLProgram : GLObject <Program>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithBinding:(GLenum)binding NS_UNAVAILABLE;

/// Initializes the program with source code of \c vertex and \c fragment shaders. If returned
/// object is not \c nil it is compiled, linked and ready to use.
- (instancetype)initWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment
    NS_DESIGNATED_INITIALIZER;

/// Returns parameter index (location) associated with given \c name. If \c name is not found
/// returns \c NSNotFound.
- (NSInteger)parameterIdxByName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
