// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Bindable.h"

NS_ASSUME_NONNULL_BEGIN

/// An abstract interface that contains opengl \c descriptor and \c binding.
@interface GLObject : NSObject <Bindable> {
  /// OpenGL's object descriptor.
  @public GLuint _descriptor;
}

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the object with \c binding.
- (instancetype)initWithBinding:(GLenum)binding NS_DESIGNATED_INITIALIZER;

/// Returns currently bound value for its \c binding.
- (GLint)queryBoundValue;

/// OpenGL \c binding enumeration value that is associated with this object.
@property (readonly, nonatomic) GLenum binding;

@end

NS_ASSUME_NONNULL_END
