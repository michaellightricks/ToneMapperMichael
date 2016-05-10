// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Bindable.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that describes GPU memory storage.
@protocol Buffer <Bindable>

/// Updates the buffer data with \c data. \c offset - offset of the destination buffer location to
/// use.
- (void)updateWithData:(NSData *)data destOffset:(NSUInteger)offset;

/// Length of the buffer in bytes.
@property (readonly, nonatomic) NSUInteger length;

@end

/// Enumration for supported texture types.
typedef NS_ENUM(NSUInteger, TextureType) {
  TEX_TYPE_UNSIGNED_BYTE
};

/// Enumration for supported texture formats.
typedef NS_ENUM(NSUInteger, TextureFormat) {
  TEX_FRMT_RGB,
  TEX_FRMT_RGBA
};

/// Pure data interface for 2d texture's metadata.
@interface Texture2DProps : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the texture 2D metadata with \c width, \c height \c type and \c format.
- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height type:(TextureType)type
                       format:(TextureFormat)format NS_DESIGNATED_INITIALIZER;

/// \c Width of the texture.
@property (readonly, nonatomic) NSUInteger width;

/// \c Heigth of the texture.
@property (readonly, nonatomic) NSUInteger height;

/// The \c type of the texture's data.
@property (readonly, nonatomic) TextureType type;

/// The format of texture's data.
@property (readonly, nonatomic) TextureFormat format;

/// Number of bits per pixel component.
@property (readonly, nonatomic) NSUInteger bitsPerComponent;

/// Number of bits per whole pixel.
@property (readonly, nonatomic) NSUInteger bitsPerPixel;

@end

/// Texture2D protocol allows loading texture data, this object can be assigned as program texture
/// parameter.
@protocol Texture2D <Bindable>

/// Updates the texture memory with \c data. If \c data is nil texture memory is only allocated and
/// not initialized.
- (void)updateWithData:(nullable NSData *)data;

/// Texture metadata.
@property (readonly, nonatomic) Texture2DProps *props;

/// Texture handle to reference the texture in OpenGL.
@property (readonly, nonatomic) NSUInteger handle;

@end

NS_ASSUME_NONNULL_END
