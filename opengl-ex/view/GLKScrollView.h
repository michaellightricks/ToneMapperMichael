// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GLKScrollView;

/// Delegate protocol that is used to notify GLKScrollView client on visible rectangle changes as
/// user scrolls and zooms.
@protocol GLKScrollViewDelegate <NSObject>

/// Called each time visible rectangle is changed due to scroll or zoom action.
- (void)glkScrollViewVisibleRectChanged:(CGRect)visibleRect;

/// Called each time view is going to render new frame.
- (void)glkScrollView:(GLKScrollView *)view drawInRect:(CGRect)rect;

@end

/// Scrollable view implementation using opengl renderer. It has \c GLKView as subview to render the
/// image and \c UIScrollView placed under it to track scrolling and zooming actions. As user
/// scrolls or zooms \c glkScrollViewVisibleRectChanged message passed to \c delegate instance with
/// current visible rectangle (of imaginary content view which should be the renderable entity with
/// size specified by \c contentSize).
@interface GLKScrollView : UIView

/// Implementation of the view delegate protocol that responds to viewing rectangle changes.
@property (weak, nonatomic) id<GLKScrollViewDelegate> delegate;

/// The size (in points) of imaginary content that is displayed in scroll view.
@property (nonatomic) CGSize contentSize;

/// EAGL context to use.
@property (strong, nonatomic) EAGLContext *context;

@end

NS_ASSUME_NONNULL_END
