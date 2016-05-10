// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "Defs.h"
#import "GLFramebuffer.h"
#import "GLTexture2D.h"

SpecBegin(GLTexture2D)

describe(@"GLTexture2D", ^{
  __block EAGLContext *glContext;
  
  beforeEach(^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  });

  afterEach(^{
    glContext = nil;
  });
  
  it(@"should initialize correctly from props", ^{
    Texture2DProps *props = [[Texture2DProps alloc] initWithWidth:2 height:2
                                                             type:TEX_TYPE_UNSIGNED_BYTE
                                                           format:TEX_FRMT_RGBA];
    GLTexture2D *texture = [[GLTexture2D alloc] initWithProps:props];
    expect(texture).notTo.beNil();
  });
  
  it(@"should initialize correctly from GLK info", ^{
    NSError *error;
    UIImage *image = [UIImage imageNamed:@"triangle"];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil
                                                              error:&error];
    expect(error).to.beNil();
    expect(textureInfo).notTo.beNil();

    GLTexture2D *texture = [[GLTexture2D alloc] initWithInfo:textureInfo];
    expect(texture).notTo.beNil();
    expect(texture.props.width).to.equal(textureInfo.width);
    expect(texture.props.height).to.equal(textureInfo.width);
    expect(texture.props.type).to.equal(TEX_TYPE_UNSIGNED_BYTE);
    expect(texture.props.format).to.equal(TEX_FRMT_RGBA);
    expect(texture->_descriptor).to.equal(textureInfo.name);
  });


  itShouldBehaveLike(kBindableSharedExample, ^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    UIImage *image = [UIImage imageNamed:@"running"];
    NSError *error;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil
                                                                 error:&error];
    GLTexture2D *texture = [[GLTexture2D alloc] initWithInfo:textureInfo];

    UIImage *image1 = [UIImage imageNamed:@"triangle"];
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:image1.CGImage options:nil
                                                                 error:&error];
    GLTexture2D *texture1 = [[GLTexture2D alloc] initWithInfo:textureInfo1];
    [texture1 bind];
    return @{kBindableSharedExample: texture};
  });
});

SpecEnd
