// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ImagePicker;

/// Object that want to be notified about image that was picked by \c ImagePicker.
@protocol ImagePickerDelegate <NSObject>

/// Called when \c picker finishes picking the \c image. This method is not called in case user
/// cancells the action.
- (void)imagePicker:(ImagePicker *)picker didFinishPickingImage:(UIImage *)image;

@end

/// Object that shows image picker and notifies about picked image.
@interface ImagePicker : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the picker with \c delegate.
- (instancetype)initWithDelegate:(id<ImagePickerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// Presents picker using \c controller.
- (void)presentPickerWithParentController:(UIViewController *)controller;

/// Delegate to be notified about picked image.
@property (weak, readonly, nonatomic) id<ImagePickerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
