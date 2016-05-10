// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "Bindable.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Scope

+ (void)bind:(id<Bindable>)bindable andExecute:(OperationBlockType)block{
  OperationBlockType unbind = [bindable bind];
  @try {
    block();
  }
  @finally {
    if (unbind) {
      unbind();
    }
  }
}

+ (void)bindCollection:(NSArray<id<Bindable> > *)bindable andExecute:(OperationBlockType)block {
  NSMutableArray *unbindArray = [NSMutableArray array];
  
  @try {
    for (id<Bindable> item in bindable) {
      UnbindBlockType unbind = [item bind];
      if (unbind) {
        [unbindArray addObject:unbind];
      }
    }

    block();
  }
  @finally {
    for (UnbindBlockType unbind in [unbindArray reverseObjectEnumerator]) {
      if (unbind) {
        unbind();
      }
    }
  }
}

@end

@interface BindableWithBlock()

/// Block for bind operation.
@property (copy, nonatomic) OperationBlockType bindBlock;

/// Block for unbind operation.
@property (copy, nonatomic) UnbindBlockType unbindBlock;

@end

@implementation BindableWithBlock

- (instancetype)initWithBindBlock:(OperationBlockType)bind unbindBlock:(UnbindBlockType)unbind {
  if (self = [super init]) {
    _bindBlock = bind;
    _unbindBlock = unbind;
  }

  return self;
}

- (UnbindBlockType)bind {
  self.bindBlock();
  return self.unbindBlock;
}

@end

NS_ASSUME_NONNULL_END
