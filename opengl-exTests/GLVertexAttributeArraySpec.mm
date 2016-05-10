// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "GLBuffer.h"
#import "GLVertexAttribute.h"
#import "GLVertexAttributesArray.h"

SpecBegin(GLVertexAttributesArray)

describe(@"GLVertexAttributesArray", ^{
  __block EAGLContext *glContext;
  __block NSArray<GLVertexAttribute *> *attributes;
  
  beforeEach(^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    id<Buffer> buffer = [[GLBuffer alloc] initElementWithUsage:BufferUsageStatic];
    VertexAttributeProps *attrProps =
        [[VertexAttributeProps alloc] initWithName:@"pos" buffer:buffer type:ATTR_FLOAT
                                  componentsNumber:2];
    GLVertexAttribute *attr = [[GLVertexAttribute alloc] initWithProps:attrProps index:0];
    
    attributes = @[attr];
  });

  afterEach(^{
    glContext = nil;
    attributes = nil;
  });
  
  it(@"should initialize with attributes", ^{
    id<VertexAttributesArray> array =
        [[GLVertexAttributesArray alloc] initWithAttributes:attributes];
    
    expect(array).notTo.beNil();
    expect(array.attributes).to.equal(attributes);
  });
});

SpecEnd
