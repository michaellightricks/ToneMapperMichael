// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSValue+GLKMatrix4.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSValue (GLKMatrix4)

- (GLKMatrix4)glkMatrix4Value {
  GLKMatrix4 m;
  [self getValue:&m];

  return m;
}

@end

NS_ASSUME_NONNULL_END
