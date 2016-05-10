// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Block for simple operations with no parameters nor return value.
typedef void(^OperationBlockType)(void);

/// Block for unbind operation.
typedef void(^UnbindBlockType)(void);

/// Generic bindable object with option to restore the state before binding by returning unbind
/// block from \c bind. Note that typically all other functions will assume that resource is bound,
/// so it is client responsibility to actually call \c bind before using the object. You can use
/// Scope object for single call use.
@protocol Bindable <NSObject>

/// Binds the bindable object and providing block for restoring the state as it was before binding.
- (UnbindBlockType)bind;

@optional

/// Returns \c YES if the object is bound to current context.
- (BOOL)isBound;

@end

/// Block with no parameters, return value used for execution inside bind scope.
typedef void(^OperationBlockType)(void);

/// Simple class that performs given blocks in bindable manner.
@interface BindableWithBlock : NSObject <Bindable>

/// Initializes the instance with \c bind and \c unbind operations blocks.
- (instancetype)initWithBindBlock:(OperationBlockType)bind unbindBlock:(UnbindBlockType)unbind;

@end

/// Static class for execution in the scope of Bindable object binding.
@interface Scope : NSObject

/// Binds \c bindable executes \c block and then unbinds the bindable.
+ (void)bind:(id<Bindable>)bindable andExecute:(OperationBlockType)block;

/// Binds \c bindable collection executes \c block and unbinds the collection in reverse order.
+ (void)bindCollection:(NSArray<id<Bindable> > *)bindable andExecute:(OperationBlockType)block;

@end

NS_ASSUME_NONNULL_END
