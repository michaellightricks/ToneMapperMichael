// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>

#import "Bindable.h"
#import "GLObject.h"

SpecBegin(Scope)

it(@"Should bind/unbind the bindable", ^{
  id bindableMock = OCMClassMock([GLObject class]);
  __block BOOL unbindCalled = NO;
  __block BOOL blockCalled = NO;
  OCMStub([bindableMock bind]).andReturn(^{
    unbindCalled = YES;
  });

  [Scope bind:bindableMock andExecute:^{
    blockCalled = YES;
  }];

  OCMVerify([bindableMock bind]);
  expect(blockCalled).to.beTruthy();
  expect(unbindCalled).to.beTruthy();
});

it(@"Should bind/unbind the bindable collection", ^{
  id bindableMock = OCMClassMock([GLObject class]);
  id bindableMock1 = OCMClassMock([GLObject class]);
  __block BOOL unbindCalled = NO;
  __block BOOL unbindCalled1 = NO;
  __block BOOL blockCalled = NO;
  OCMStub([bindableMock bind]).andReturn(^{
    unbindCalled = YES;
  });

  OCMStub([bindableMock1 bind]).andReturn(^{
    unbindCalled1 = YES;
  });

  [Scope bindCollection:@[bindableMock, bindableMock1] andExecute:^{
    blockCalled = YES;
  }];

  OCMVerify([bindableMock bind]);
  OCMVerify([bindableMock1 bind]);
  expect(blockCalled).to.beTruthy();
  expect(unbindCalled).to.beTruthy();
  expect(unbindCalled1).to.beTruthy();
});
SpecEnd
