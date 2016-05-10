// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLKScrollView.h"

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLKScrollView () <UIScrollViewDelegate, GLKViewDelegate>

/// Internal \c UIScrollView to handle viewing rectangle and user gestures with.
@property (strong, nonatomic) UIScrollView *scrollView;

/// Dummy content that is pushed to ScrollView as a placeholder to viewed content (actually rendered
/// by the delegate).
@property (strong, nonatomic) UIView *contentView;

/// GLKView to render to.
@property (readonly, nonatomic) GLKView *glkView;

@end

@implementation GLKScrollView

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup:self.frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup:frame];
  }
  
  return self;
}

static CGFloat kMinZoomScale = 0.1;
static CGFloat kMaxZoomScale = 4.0;
static CGFloat kMinZoomFactor = 3.0;

- (void)setup:(CGRect)frame {
  _scrollView = [[UIScrollView alloc] initWithFrame:frame];
  _scrollView.delegate = self;
  _scrollView.scrollEnabled = YES;
  _scrollView.minimumZoomScale = kMinZoomScale;
  _scrollView.maximumZoomScale = kMaxZoomScale;

  _glkView = [[GLKView alloc] initWithFrame:frame];
  _glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
  _glkView.drawableDepthFormat = GLKViewDrawableDepthFormatNone;
  _glkView.drawableStencilFormat = GLKViewDrawableStencilFormatNone;
  _glkView.drawableMultisample = GLKViewDrawableMultisampleNone;
  _glkView.delegate = self;

  [_glkView addGestureRecognizer:_scrollView.panGestureRecognizer];
  _glkView.backgroundColor = _scrollView.backgroundColor;
  
  [self addSubview:_scrollView];
  [self addSubview:_glkView];

  _contentView = [[UIView alloc] initWithFrame:frame];
  [_scrollView addSubview:_contentView];
}

- (void)setContentSize:(CGSize)contentSize {
  self.scrollView.zoomScale = 1.0;
  
  self.contentView.transform = CGAffineTransformIdentity;
  self.contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
  self.contentView.bounds = self.contentView.frame;

  self.glkView.frame = self.frame;
  self.glkView.bounds = self.bounds;

  self.scrollView.frame = self.frame;
  self.scrollView.bounds = self.bounds;
  self.scrollView.contentSize = contentSize;
  
  [self updateZoomBoundsForContentView:self.contentView];
  [self zoomToFit:self.contentView];

  if (![self.glkView.gestureRecognizers containsObject:_scrollView.pinchGestureRecognizer]) {
    [self.glkView addGestureRecognizer:_scrollView.pinchGestureRecognizer];
  }

  [self.delegate glkScrollViewVisibleRectChanged:[self visibleContentRect]];
  [self.glkView setNeedsDisplay];
}

- (void)updateZoomBoundsForContentView:(UIView *)view {
  self.scrollView.minimumZoomScale = [self minZoomScaleForView:view];
  self.scrollView.maximumZoomScale = MAX(kMaxZoomScale,
                                         MAX(kMinZoomFactor * self.scrollView.minimumZoomScale,
                                             [self aspectFitZoomScaleForImageView:view]));
}

- (CGFloat)minZoomScaleForView:(UIView *)view {
  if (view.bounds.size.width == 0 || view.bounds.size.height == 0) {
    return 1.0;
  }
  
  CGFloat widthScale = self.scrollView.bounds.size.width / view.bounds.size.width;
  CGFloat heightScale = self.scrollView.bounds.size.height / view.bounds.size.height;
  
  return MIN(1, MIN(widthScale, heightScale));
}

- (void)zoomToFit:(UIView *)view {
  self.scrollView.zoomScale = [self aspectFitZoomScaleForImageView:view];
}

- (CGFloat)aspectFitZoomScaleForImageView:(UIView *)view {
  if (view.bounds.size.width == 0 || view.bounds.size.height == 0) {
    return 1.0;
  }

  CGFloat widthScale = self.scrollView.bounds.size.width / view.bounds.size.width;
  CGFloat heightScale = self.scrollView.bounds.size.height / view.bounds.size.height;
  
  return MAX(widthScale, heightScale);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self.delegate glkScrollViewVisibleRectChanged:[self visibleContentRect]];
  [self.glkView setNeedsDisplay];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self.delegate glkScrollViewVisibleRectChanged:[self visibleContentRect]];
  [self.glkView setNeedsDisplay];
}

- (CGRect)visibleContentRect {
  return [self.scrollView convertRect:self.scrollView.bounds toView:self.contentView];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.contentView;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self.delegate glkScrollView:self drawInRect:rect];
}

- (EAGLContext *)context {
  return self.glkView.context;
}

-(void)setContext:(EAGLContext *)context {
  self.glkView.context = context;
}

@end

NS_ASSUME_NONNULL_END
