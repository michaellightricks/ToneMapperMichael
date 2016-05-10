// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "Bindable.h"

NS_ASSUME_NONNULL_BEGIN

/// Set of program uniform named parameters.
@protocol NamedParametersSet <Bindable>

/// Sets uniform float parameter by specifying its \c name and \c value.
- (void)setFloatParameterByName:(NSString *)name value:(float)value;

/// Sets uniform float 4x4 matrix parameter by specifying its \c name and \c value.
- (void)setMatrixParameterByName:(NSString *)name value:(float[16])value;

/// Sets uniform texture parameter by specifying its \c name and \c texture value.
- (void)setTextureParameterByName:(NSString *)name value:(id<Texture2D>)texture;

@end

NS_ASSUME_NONNULL_END
