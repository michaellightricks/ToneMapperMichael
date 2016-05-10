// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "Defs.h"
#import "GLBuffer.h"
#import "GLVertexAttribute.h"

SpecBegin(VertexAttributeProps)

it(@"should initialize with correct properties", ^{
  NSString *name = @"name";

  id<Buffer> buffer = OCMClassMock([GLBuffer class]);
  VertexAttributeType type = ATTR_UNSIGNED_BYTE;
  int componentsNum = 3;

  VertexAttributeProps *props = [[VertexAttributeProps alloc] initWithName:name buffer:buffer
                                                                      type:type
                                                          componentsNumber:componentsNum];
  expect(props).toNot.beNil();
  expect(props.buffer).to.equal(buffer);
  expect(props.componentsNumber).to.equal(componentsNum);
  expect(props.name).to.equal(name);
  expect(props.type).to.equal(type);
});

SpecEnd

SpecBegin(GLVertexAttribute)

static NSString * const kName = @"name";
static const VertexAttributeType kType = ATTR_UNSIGNED_BYTE;
static const int kComponentsNum = 3;
static const GLuint kAttrIndex = 1;

__block EAGLContext *glContext;
__block id<Buffer> buffer;
__block VertexAttributeProps *props;
__block GLVertexAttribute *attribute;

OperationBlockType beforeEachBlock = ^{
  buffer = OCMClassMock([GLBuffer class]);;
  glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  props = [[VertexAttributeProps alloc] initWithName:kName buffer:buffer type:kType
                                    componentsNumber:kComponentsNum];

  attribute = [[GLVertexAttribute alloc] initWithProps:props index:kAttrIndex];
};

beforeEach(beforeEachBlock);

afterEach(^{
  buffer = nil;
  glContext = nil;
  props = nil;
  attribute = nil;
});

it(@"should initialize with correct properties", ^{
  expect(attribute).notTo.beNil();
  expect(attribute.props).to.equal(props);
  expect(attribute.index).to.equal(kAttrIndex);
});

itShouldBehaveLike(kBindableSharedExample, ^{
  beforeEachBlock();
  return @{kBindableSharedExample: attribute};
});

SpecEnd
