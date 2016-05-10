// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ImagePicker.h"

#import <MobileCoreServices/MobileCoreServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePicker() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/// View controller that displays UI for picking the image.
@property (readonly, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ImagePicker

- (instancetype)initWithDelegate:(id<ImagePickerDelegate>)delegate {
  if (self = [super init]) {
    _imagePickerController = [[UIImagePickerController alloc] init];
    
    _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    _imagePickerController.delegate = self;

    _delegate = delegate;
  }
  
  return self;
}

- (void)presentPickerWithParentController:(UIViewController *)controller {
  [controller presentViewController:self.imagePickerController animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
  UIImage *originalImage, *editedImage, *imageToUse;
  
  if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0)
      == kCFCompareEqualTo) {
    
    editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
    originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];

    imageToUse = editedImage ?: originalImage;
  }
  
  [self.delegate imagePicker:self didFinishPickingImage:imageToUse];
}

@end

NS_ASSUME_NONNULL_END
