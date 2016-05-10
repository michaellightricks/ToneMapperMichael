// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "RectRenderer.h"

#import <GLKit/GLKit.h>

#import "Defs.h"
#import "ResourceFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface RectRenderer()

/// Set of parameters for shader program.
@property (strong, nonatomic) id<NamedParametersSet> paramSet;

/// Array of vertex attributes containing the rectangle corner positions.
@property (strong, nonatomic) id<VertexAttributesArray> attributesArray;

@end

@implementation RectRenderer

/// Rectangle vertices 2d positions specified in single array as x, y, x, y...
static float verticesData[] = {0.0f, 0.0f,
                               0.0f, 1.0f,
                               1.0f, 1.0f,
                               1.0f, 0.0f};

static GLushort indicesData[] = {0, 1, 2, 2, 3, 0};

+ (void)clearWithColor:(UIColor *)color {
  CGFloat r, g, b, a;
  BOOL success = [color getRed:&r green:&g blue:&b alpha:&a];
  NSAssert(success, @"UIColor instance should support RGBA format.");

  GL_ERROR_CHECK(glClearColor(r, g, b, a));
  GL_ERROR_CHECK(glClear(GL_COLOR_BUFFER_BIT));
}

+ (void)enableBlending {
  GL_ERROR_CHECK(glEnable(GL_BLEND));
  GL_ERROR_CHECK(glBlendEquation(GL_FUNC_ADD));
  GL_ERROR_CHECK(glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA));
}

+ (void)disableBlending {
  GL_ERROR_CHECK(glDisable(GL_BLEND));
}

+ (id<Bindable>)blendingBindableEnabled:(BOOL)enabled {
  GLboolean oldEnabled;
  glGetBooleanv(GL_BLEND, &oldEnabled);
  GLint oldBlendEquation;
  glGetIntegerv(GL_BLEND_EQUATION, &oldBlendEquation);
  GLint oldBlendSrc;
  glGetIntegerv(GL_BLEND_SRC_ALPHA, &oldBlendSrc);
  GLint oldBlendDst;
  glGetIntegerv(GL_BLEND_DST_ALPHA, &oldBlendDst);

  UnbindBlockType unbind = ^{
    if (oldEnabled) {
      GL_ERROR_CHECK(glEnable(GL_BLEND));
    } else {
      GL_ERROR_CHECK(glDisable(GL_BLEND));
    }

    GL_ERROR_CHECK(glBlendEquation(oldBlendEquation));
    GL_ERROR_CHECK(glBlendFunc(oldBlendSrc, oldBlendDst));
  };

  if (enabled) {
    return [[BindableWithBlock alloc] initWithBindBlock:^{
      [RectRenderer enableBlending];
    } unbindBlock:unbind];
  } else {
    return [[BindableWithBlock alloc] initWithBindBlock:^{
      [RectRenderer disableBlending];
    } unbindBlock:unbind];
  }
}

static NSString * const kPositionsAttributeName = @"pos";
static NSString * const kTextureAttributeName = @"t_source";

- (instancetype)initWithTexture:(id<Texture2D>)texture program:(id<Program>)program;{
  if (self = [super init]) {
    _sourceTexture = texture;
    _program = program;

    NSData *data = [NSData dataWithBytesNoCopy:&verticesData[0] length:sizeof(verticesData)
                                  freeWhenDone:NO];

    id<Buffer> verticesBuffer = [ResourceFactory staticBufferWithBytes:data];
   
    VertexAttributeProps *attrProps =
        [[VertexAttributeProps alloc] initWithName:kPositionsAttributeName buffer:verticesBuffer
                                              type:ATTR_FLOAT componentsNumber:2];
    
    id<VertexAttribute> attr = [program vertexAttributeFromProps:attrProps];
    _attributesArray = [ResourceFactory vertexAttributesArray:@[attr]];
    
    _paramSet = [program namedParametersSet];
    
    [self.paramSet setTextureParameterByName:kTextureAttributeName value:_sourceTexture];
  }
  
  return self;
}

static NSString * const kMatrixAttributeName = @"modelViewProjection";

- (void)drawRect:(CGRect)rect {
  float offsetFromLeft = rect.origin.x / self.sourceTexture.props.width;
  float offsetFromTop = rect.origin.y / self.sourceTexture.props.height;
  float width = rect.size.width / self.sourceTexture.props.width;
  float height = rect.size.height / self.sourceTexture.props.height;
  
  GLKMatrix4 projectionMat =
    GLKMatrix4MakeOrtho(offsetFromLeft, offsetFromLeft + width, height + offsetFromTop,
                        offsetFromTop, -1, 1);
  
  [self.paramSet setMatrixParameterByName:kMatrixAttributeName value:&(projectionMat.m[0])];
  
  [Scope bind:self.program andExecute:^{
    [Scope bind:self.attributesArray andExecute:^{
      [Scope bind:self.paramSet andExecute:^{
        GL_ERROR_CHECK(glDrawElements(GL_TRIANGLES, sizeof(indicesData)/sizeof(indicesData[0]),
                                      GL_UNSIGNED_SHORT, &indicesData[0]));
      }];
    }];
  }];
}

@end

NS_ASSUME_NONNULL_END
