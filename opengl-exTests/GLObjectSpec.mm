// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "Defs.h"
#import "GLObject.h"

SpecBegin(GLObject)

describe(@"GLObject", ^{
  __block EAGLContext *glContext;
  __block GLObject *obj;
  
  beforeEach(^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    obj = [[GLObject alloc] initWithBinding:GL_ARRAY_BUFFER_BINDING];
  });

  afterEach(^{
    glContext = nil;
    obj = nil;
  });
  
  it(@"should initialize correctly", ^{
    expect(obj).notTo.beNil();
    expect(obj.binding).to.equal(GL_ARRAY_BUFFER_BINDING);
  });
  
  it(@"should be able to query bound value", ^{
    GL_ERROR_CHECK(glBindBuffer(GL_ARRAY_BUFFER, 0));
    GLint value = [obj queryBoundValue];
    expect(value).to.equal(0);
  });
  
  it(@"should check if it is bound", ^{
    GL_ERROR_CHECK(glGenBuffers(1, &(obj->_descriptor)));
    GL_ERROR_CHECK(glBindBuffer(GL_ARRAY_BUFFER, obj->_descriptor));
    BOOL bound = [obj isBound];
    expect(bound).to.beTruthy();
    
    GL_ERROR_CHECK(glBindBuffer(GL_ARRAY_BUFFER, 0));
    bound = [obj isBound];
    expect(bound).to.beFalsy();
  });
});

SpecEnd
