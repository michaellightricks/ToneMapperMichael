// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "Bindable.h"
#import "Buffers.h"

NS_ASSUME_NONNULL_BEGIN

/// struct for 32 bit integer rectangle.
typedef struct RectIType {
  int32_t x;
  int32_t y;
  int32_t width;
  int32_t height;
} RectI;

#if defined __cplusplus
extern "C" {
#endif
  /// Creation utility function for integer rectanlge.
  RectI RectIMake(int32_t x, int32_t y, int32_t width, int32_t heigth);
#if defined __cplusplus
};
#endif

/// Framebuffer protocol allows to bind texture color attachment and read its pixels.
@protocol Framebuffer <Bindable>

/// Texture attached to framebuffer as color attachment.
@property (readonly, nonatomic) id<Texture2D> colorAttachment;

/// Reads pixels of specified \c rect to given cpu memory \c data. Format and type are taken from
/// \c colorAttachment. Note that framebuffer size (viewport rectangle) is set to (0, 0,
/// colorAttachment.width, color.Attachment.height).
- (void)readPixelsFromRect:(RectI)rect toData:(NSMutableData *)data;

/// Checks if the framebuffer is ready to render.
- (nullable NSError *)checkStatus;

@end

NS_ASSUME_NONNULL_END
