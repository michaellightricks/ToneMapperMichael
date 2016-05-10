// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "GLProgram.h"
#import "NamedParametersSet.h"

NS_ASSUME_NONNULL_BEGIN

/// Implements the NamedParametersSet the set of global shader program parameters.
@interface GLNamedParametersSet : NSObject <NamedParametersSet>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the set with \c program (held weakly) to which the set will be assigned (program to
/// look for parameter locations).
- (instancetype)initWithProgram:(GLProgram *)program NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
