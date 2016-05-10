// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "Defs.h"
#import "GLBuffer.h"

SpecBegin(GLBuffer)

context(@"GLBuffer", ^{
  __block EAGLContext *glContext;
  
  beforeEach(^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  });

  afterEach(^{
    glContext = nil;
  });
  
  it(@"should initialize as element buffer with usage", ^{
    GLenum binding = GL_ELEMENT_ARRAY_BUFFER_BINDING;
    
    GLBuffer *buffer = [[GLBuffer alloc] initElementWithUsage:BufferUsageStatic];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageStatic);
    
    buffer = [[GLBuffer alloc] initElementWithUsage:BufferUsageDynamic];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageDynamic);

    buffer = [[GLBuffer alloc] initElementWithUsage:BufferUsageStream];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageStream);
  });
  
  it(@"should initialize as array buffer with usage", ^{
    GLenum binding = GL_ARRAY_BUFFER_BINDING;
    
    GLBuffer *buffer = [[GLBuffer alloc] initArrayWithUsage:BufferUsageStatic];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageStatic);
    
    buffer = [[GLBuffer alloc] initArrayWithUsage:BufferUsageDynamic];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageDynamic);
    
    buffer = [[GLBuffer alloc] initArrayWithUsage:BufferUsageStream];
    expect(buffer).notTo.beNil();
    expect(buffer.binding).to.equal(binding);
    expect(buffer.usage).to.equal(BufferUsageStream);
  });
  
  it(@"should store data with correct size", ^{
    GLBuffer *buffer = [[GLBuffer alloc] initArrayWithUsage:BufferUsageStatic];

    [Scope bind:buffer andExecute:^{
      float f[2] = {0, 0};
      NSData *data = [NSData dataWithBytesNoCopy:&f[0] length:sizeof(f) freeWhenDone:NO];
      [buffer setBytes:data];

      GLint size;
      GL_ERROR_CHECK(glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size));
      expect(size).to.equal(sizeof(f));
    }];
  });

  itShouldBehaveLike(kBindableSharedExample, ^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    return  @{kBindableSharedExample:[[GLBuffer alloc] initArrayWithUsage:BufferUsageStatic]};
  });
});

SpecEnd
