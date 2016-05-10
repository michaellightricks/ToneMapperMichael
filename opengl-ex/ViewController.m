// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ViewController.h"

#import <GLKit/GLKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <OpenGLES/ES2/glext.h>

#import "GLKScrollView.h"
#import "ImagePicker.h"
#import "RectRenderer.h"
#import "ResourceFactory.h"
#import "UIImageUtils.h"

@interface ViewController () <GLKScrollViewDelegate, ImagePickerDelegate>

/// Renders the part of the image via viewing rectangle.
@property (strong, nonatomic) RectRenderer *renderer;

/// Program to use with renderer.
@property (strong, nonatomic) id<Program> program;

/// Rectangle that defines viewed region of showed image.
@property (nonatomic) CGRect viewingRect;

/// Displays the currently loaded image.
@property (weak, nonatomic) IBOutlet GLKScrollView *glkScrollView;

/// Save bar item.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;

/// Used for picking images from the photo library.
@property (strong, nonatomic) ImagePicker *imagePicker;

@end

@implementation ViewController

static NSString * const kProgramName = @"Rect";

static NSString * const kTriangleImageName = @"triangle";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupGLKScrollView];
  
  self.imagePicker = [[ImagePicker alloc] initWithDelegate:self];
  
  [EAGLContext setCurrentContext:self.glkScrollView.context];
  
  self.program = [ResourceFactory programFromBundleWithResourceName:kProgramName];

  UIImage *image = [UIImage imageNamed:kTriangleImageName];
  [self presentImage:image];
}

- (void)setupGLKScrollView {
  self.glkScrollView.delegate = self;
  self.glkScrollView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}

- (IBAction)loadPressed:(id)sender {
  [self.imagePicker presentPickerWithParentController:self];
}

- (void)imagePicker:(ImagePicker *)picker didFinishPickingImage:(UIImage *)image {
  [self dismissViewControllerAnimated:YES completion:^{
    if (!image) {
      NSLog(@"Error while picking the image.");
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self presentImage:image];
    });
  }];
}

- (void)presentImage:(UIImage *)image {
  id<Texture2D> sourceTexture = [UIImageUtils textureFromImage:image];

  self.renderer = [[RectRenderer alloc] initWithTexture:sourceTexture program:self.program];

  self.glkScrollView.contentSize = CGSizeMake(self.renderer.sourceTexture.props.width,
                                              self.renderer.sourceTexture.props.height);
}

- (IBAction)savePressed:(id)sender {
  RectI viewportRect = RectIMake(0, 0, (int32_t)(self.renderer.sourceTexture.props.width / 2),
                                 (int32_t)(self.renderer.sourceTexture.props.height / 2));
  
  UIImage *image = [UIImageUtils renderRect:viewportRect withRenderer:self.renderer
                                 clearColor:self.glkScrollView.backgroundColor];
  UIImageWriteToSavedPhotosAlbum(image, self,
                                 @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
  if (error) {
    NSLog(@"%@", error);
  }
}

- (void)viewDidLayoutSubviews {
  self.glkScrollView.contentSize = self.renderer ?
      CGSizeMake(self.renderer.sourceTexture.props.width,
                 self.renderer.sourceTexture.props.height) : self.glkScrollView.frame.size;
}

- (void)glkScrollView:(GLKView *)view drawInRect:(CGRect)rect {
  [Scope bind:[RectRenderer blendingBindableEnabled:YES] andExecute:^{
    [RectRenderer clearWithColor:self.glkScrollView.backgroundColor];
    [self.renderer drawRect:self.viewingRect];
  }];

  GLenum discards[] = {GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT};
  glDiscardFramebufferEXT(GL_FRAMEBUFFER, 2, discards);
}

- (void)glkScrollViewVisibleRectChanged:(CGRect)visibleRect {
  self.viewingRect = visibleRect;
}

@end
