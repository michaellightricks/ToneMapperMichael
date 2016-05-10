// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "BindableSpec.h"
#import "GLProgram.h"
#import "TestUtils.h"

SpecBegin(GLProgram)

describe(@"GLProgram", ^{
  __block EAGLContext *glContext;
  __block GLProgram *program;

  OperationBlockType beforeEachBlock = ^{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    program = [[GLProgram alloc] initWithVertexShader:[ShadersSource vertexSource]
                                       fragmentShader:[ShadersSource fragmentSource]];
  };

  beforeEach(beforeEachBlock);

  afterEach(^{
    glContext = nil;
    program = nil;
  });

  it(@"should initialize and compile", ^{
    expect(program).notTo.beNil();
  });
  
  it(@"should be able to create parameter set", ^{
    id<NamedParametersSet> paramSet = [program namedParametersSet];
    expect(paramSet).notTo.beNil();
  });
  
  it(@"should be able to find index for uniform", ^{
    NSInteger idx = [program parameterIdxByName:@"projectionViewModel"];
    expect(idx).to.beGreaterThanOrEqualTo(0);
    
    NSInteger idx1 = [program parameterIdxByName:@"t_source"];
    expect(idx1).to.beGreaterThanOrEqualTo(0);
    expect(idx1).notTo.equal(idx);
  });
  
  it(@"should be able to find vertex attributes", ^{
    id<Buffer> buffer = nil;
    VertexAttributeProps *props =
        [[VertexAttributeProps alloc] initWithName:@"pos" buffer:buffer type:ATTR_FLOAT
                                  componentsNumber:3];
    id<VertexAttribute> attr = [program vertexAttributeFromProps:props];
    expect(attr).notTo.beNil();
  });
  
  it(@"should fail on unavailable vertex attribute name", ^{
    id<Buffer> buffer = nil;
    VertexAttributeProps *props =
        [[VertexAttributeProps alloc] initWithName:@"possss" buffer:buffer type:ATTR_FLOAT
                                  componentsNumber:3];
    __block id<VertexAttribute> attr;
    expect(^{
      attr = [program vertexAttributeFromProps:props];
    }).to.raise(NSInvalidArgumentException);
  });

  itShouldBehaveLike(kBindableSharedExample, ^{
    beforeEachBlock();
    return @{kBindableSharedExample: program};
  });
});

SpecEnd
