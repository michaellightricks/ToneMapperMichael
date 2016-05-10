// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "ResourceFactory.h"
#import "TestUtils.h"
#import "UIImageUtils.h"

SpecBegin(UIImageUtils)

describe(@"UIImageUtils", ^{
  __block EAGLContext *glContext;
  
  beforeEach(^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  });

  afterEach(^{
    glContext = nil;
  });

  it(@"should get image from data", ^{
    uint8_t dataPtr[] = {0, 1, 2, 3,
      4, 5, 6, 7,
      8, 9, 10, 11,
      12, 13, 14, 15};
    NSMutableData *data = [NSMutableData dataWithBytes:&dataPtr length:16];
    Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:2 height:2
                                                             type:TEX_TYPE_UNSIGNED_BYTE
                                                           format:TEX_FRMT_RGBA];
    UIImage *image = [UIImageUtils imageFromData:data props:props];
    expect(image).notTo.beNil();

    NSData *resultData = [UIImageUtils dataFromImage:image];

    BOOL equals = [resultData isEqualToData:data];

    expect(equals).to.beTruthy();
  });
  
  it(@"should render to texture with RectRenderer", ^{
    UIImage *sourceImage = [UIImage imageNamed:@"triangle"];
    id<Texture2D> texture = [UIImageUtils textureFromImage:sourceImage];
    
    id<Program> program = [ResourceFactory programFromBundleWithResourceName:@"Rect"];
    
    RectRenderer *renderer = [[RectRenderer alloc] initWithTexture:texture program:program];

    UIColor *clearColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    __block UIImage *resultImage;

    [Scope bind:[RectRenderer blendingBindableEnabled:NO] andExecute:^{
      resultImage = [UIImageUtils renderRect:RectIMake(0, 0, (int32_t)texture.props.width,
                                                       (int32_t)texture.props.height)
                                withRenderer:renderer clearColor:clearColor];
    }];

    BOOL equal = areImagesEqual(sourceImage, resultImage);
    expect(equal).to.beTruthy();
  });
});

SpecEnd
