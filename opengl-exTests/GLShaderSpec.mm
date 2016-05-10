// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "GLShader.h"
#import "ResourceFactory.h"
#import "TestUtils.h"
#import "UIImageUtils.h"

SpecBegin(GLShader)

__block EAGLContext *glContext;

beforeEach(^{
  glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
});

afterEach(^{
  glContext = nil;
});

it(@"should initialize and compile vertex shader from source", ^{
  GLShader *shader =
      [[GLShader alloc] initWithSource:[ShadersSource vertexSource] type:GL_VERTEX_SHADER];
  expect(shader).notTo.beNil();

  expect(^{
    [shader compile];
  }).notTo.raiseAny();
});

it(@"should initialize and compile vertex shader from source", ^{
  GLShader *shader =
      [[GLShader alloc] initWithSource:[ShadersSource fragmentSource] type:GL_FRAGMENT_SHADER];
  expect(shader).notTo.beNil();

  expect(^{
    [shader compile];
  }).notTo.raiseAny();
});

it(@"should fail fragment shader compilation with vertex shader source.", ^{
  GLShader *shader =
      [[GLShader alloc] initWithSource:[ShadersSource vertexSource] type:GL_FRAGMENT_SHADER];
  expect(shader).notTo.beNil();

  expect(^{
    [shader compile];
  }).to.raise(NSInvalidArgumentException);
});

it(@"should fail vertex shader compilation with fragment shader source.", ^{
  GLShader *shader =
      [[GLShader alloc] initWithSource:[ShadersSource fragmentSource] type:GL_VERTEX_SHADER];
  expect(shader).notTo.beNil();

  expect(^{
    [shader compile];
  }).to.raise(NSInvalidArgumentException);
});

SpecEnd
