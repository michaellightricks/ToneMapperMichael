// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <algorithm>
#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "Defs.h"
#import "GLFramebuffer.h"
#import "GLTexture2D.h"
#import "ResourceFactory.h"

SpecBegin(GLFramebuffer)

__block EAGLContext *glContext;

beforeEach(^{
  glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
});

afterEach(^{
  glContext = nil;
});

context(@"Initialization", ^{
  __block GLTexture2D *texture;
  __block GLFramebuffer *frameBuffer;

  beforeEach(^{
    Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:256 height:256
                                                             type:TEX_TYPE_UNSIGNED_BYTE
                                                           format:TEX_FRMT_RGBA];
    texture = [[GLTexture2D alloc] initWithProps:props];

    frameBuffer = [[GLFramebuffer alloc] initWithTexture:texture];
  });

  afterEach(^{
    texture = nil;
    frameBuffer = nil;
  });
  
  it(@"should initialize correctly", ^{
    expect(frameBuffer).notTo.beNil();
    expect(frameBuffer.colorAttachment).to.equal(texture);
  });
  
  it(@"should set viewport", ^{
    [Scope bind:frameBuffer andExecute:^{
      GLint vp [4];
      RectI result;
      GL_ERROR_CHECK(glGetIntegerv (GL_VIEWPORT, vp));
      result.x = vp[0];
      result.y = vp[1];
      result.width = vp[2];
      result.height = vp[3];
      expect(result.x).to.equal(0);
      expect(result.y).to.equal(0);
      expect(result.width).to.equal(texture.props.width);
      expect(result.height).to.equal(texture.props.height);
    }];
  });

  it(@"should set color attachment correctly.", ^{
    [Scope bind:frameBuffer andExecute:^{

      GLint descriptor;
      GL_ERROR_CHECK(glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                                           GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,
                                                           &descriptor));
      expect(descriptor).to.equal(texture.handle);
      
      GLint type;
      GL_ERROR_CHECK(glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                                           GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
                                                           &type));
      expect(type).to.equal(GL_TEXTURE);
    }];
  });
});

it(@"should return correct pixels", ^{
  Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:2 height:2
                                                           type:TEX_TYPE_UNSIGNED_BYTE
                                                         format:TEX_FRMT_RGBA];
  GLTexture2D *texture = [ResourceFactory textureWithProps:props andData:NULL];

  id<Framebuffer> frameBuffer = [ResourceFactory frameBufferWithTexture:texture];

  [Scope bind:frameBuffer andExecute:^{
    GLubyte resultArray[16] = { 0 };
    GLfloat refColor[4] = {0.01f, 0.02f, 0.03f, 0.5f};

    NSMutableData *resultData =
        [NSMutableData dataWithBytesNoCopy:resultArray length:sizeof(resultArray)
                              freeWhenDone:NO];

    NSError *error = [frameBuffer checkStatus];
    expect(error).to.beNil();

    GL_ERROR_CHECK(glClearColor(refColor[0], refColor[1], refColor[2], refColor[3]));
    GL_ERROR_CHECK(glClear(GL_COLOR_BUFFER_BIT));

    [frameBuffer readPixelsFromRect:RectIMake(0, 0, (int32_t)props.width, (int32_t)props.height)
                             toData:resultData];

    GLubyte *resultPtr = (GLubyte *)resultData.mutableBytes;
    int differentValuesCount = 0;
    for (size_t i = 0; i < 16; ++i) {
      float f = std::max(0.0f, std::min(1.0f, refColor[i % 4]));
      int refVal = round(f * 255.0);

      differentValuesCount += (resultPtr[i] - refVal) != 0;
    }

    expect(differentValuesCount).to.equal(0);
  }];
});

itShouldBehaveLike(kBindableSharedExample, ^{
  glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

  Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:256 height:256
                                                           type:TEX_TYPE_UNSIGNED_BYTE
                                                         format:TEX_FRMT_RGBA];
  GLTexture2D *texture = [[GLTexture2D alloc] initWithProps:props];
  GLFramebuffer *frameBuffer = [[GLFramebuffer alloc] initWithTexture:texture];

  return @{kBindableSharedExample: frameBuffer};
});

SpecEnd
