// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "RectRenderer.h"
#import "ResourceFactory.h"
#import "TestUtils.h"
#import "UIImageUtils.h"

SpecBegin(RectRenderer)

__block EAGLContext *glContext;
__block id<Program> program;
__block id<Texture2D> texture;
__block RectRenderer *renderer;

__block uint8_t sourceData[16]; /*= {0, 1, 2, 3,
  4, 5, 6, 7,
  8, 9, 10, 11,
  12, 13, 14, 15};*/

__block uint8_t *sourceDataPtr = &sourceData[0];

beforeEach(^{
  for (size_t i = 0; i < 16; ++i) {
    sourceDataPtr[i] = i;
  }

  NSData *data = [NSData dataWithBytesNoCopy:sourceDataPtr length:sizeof(uint8_t) * 16
                                freeWhenDone:NO];

  glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  program = [ResourceFactory programFromBundleWithResourceName:@"Rect"];

  Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:2 height:2
                                                           type:TEX_TYPE_UNSIGNED_BYTE
                                                         format:TEX_FRMT_RGBA];
  texture = [ResourceFactory textureWithProps:props andData:data];
  renderer = [[RectRenderer alloc] initWithTexture:texture program:program];
});

afterEach(^{
  glContext = nil;
  program = nil;
  texture = nil;
  renderer = nil;
});
  
it(@"should not be nil and have properties set", ^{
  expect(renderer).notTo.beNil();
  expect(renderer.sourceTexture).to.beIdenticalTo(texture);
  expect(renderer.program).to.beIdenticalTo(program);
});

SpecEnd
