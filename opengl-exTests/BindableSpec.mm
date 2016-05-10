// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "BindableSpec.h"

#import <Expecta/Expecta.h>
#import <GLKit/GLKit.h>
#import <Specta/Specta.h>

#import "Bindable.h"
#import "RectRenderer.h"
#import "ResourceFactory.h"
#import "UIImageUtils.h"

SharedExamplesBegin(Bindable)

sharedExamplesFor(kBindableSharedExample, ^(NSDictionary<NSString *, id> *data) {
  __block id<Bindable> bindable;

  beforeEach(^{
    bindable = data[kBindableSharedExample];
  });

  afterEach(^{
    bindable = nil;
  });

  it(@"should be bound and unbound succesfuly.", ^{
    UnbindBlockType unbind = [bindable bind];
    expect([bindable isBound]).to.beTruthy();
    unbind();
    expect([bindable isBound]).to.beFalsy();
  });
  
  it(@"can be bound by scope", ^{
    [Scope bind:bindable andExecute:^{
      expect([bindable isBound]).to.beTruthy();
    }];
    expect([bindable isBound]).to.beFalsy();
  });
  
  it(@"can be bound by scope as collection", ^{
    NSArray<id<Bindable> > *bindableArray = @[bindable];
    
    [Scope bindCollection:bindableArray andExecute:^{
      expect([bindable isBound]).to.beTruthy();
    }];
    expect([bindable isBound]).to.beFalsy();
  });
});

SharedExamplesEnd

