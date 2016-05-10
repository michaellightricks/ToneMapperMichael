// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLProgramParameter.h"

#import "Defs.h"
#import "NSValue+GLKMatrix4.h"
#import "TextureParameterProps.h"

NS_ASSUME_NONNULL_BEGIN

/// Block for parameter application action.
typedef UnbindBlockType(^ApplyParameterBlockType)(id value, GLuint index);

@interface ParameterTypes : NSObject

/// Dictionary of all actions for each parameter stored by its name.
@property (strong, nonatomic) NSDictionary<NSString *, ApplyParameterBlockType> *typeHandlers;

@end

@implementation ParameterTypes

- (instancetype)init {
  if (self = [super init]) {
    ApplyParameterBlockType floatBlock = ^UnbindBlockType(id value, GLuint index) {
      GL_ERROR_CHECK(glUniform1f(index, ((NSNumber *)value).floatValue));
      return nil;
    };
    
    
    ApplyParameterBlockType glkMatrix4Block = ^UnbindBlockType(id value, GLuint index) {
      GLKMatrix4 m = [(NSValue *)value glkMatrix4Value];
            GL_ERROR_CHECK(glUniformMatrix4fv(index, 1, false, &m.m[0]));
      return nil;
    };

    ApplyParameterBlockType textureBlock = ^UnbindBlockType(id value, GLuint index) {
      TextureParameterProps *props = (TextureParameterProps *)value;
      
      GL_ERROR_CHECK(glActiveTexture(props.textureUnit));
      UnbindBlockType unbindTex = [props.texture bind];
      GL_ERROR_CHECK(glUniform1i(index, props.textureUnit - GL_TEXTURE0));
      return unbindTex;
    };

    self.typeHandlers = @{[GLProgramParameter floatEncoding]: floatBlock,
                          [GLProgramParameter matrix4Encoding]: glkMatrix4Block,
                          [GLProgramParameter textureEncoding]: textureBlock};
  }
  
  return self;
}

- (UnbindBlockType)applyType:(NSString *)encoding value:(id)value index:(GLuint)index {
  ApplyParameterBlockType handler = self.typeHandlers[encoding];
  NSAssert(handler, @"Handler for encoding %@ not found.", encoding);
  return handler(value, index);
}

@end

@interface GLProgramParameter()

/// Value of the parameter stored as boxed \c value.
@property (readonly, nonatomic) id value;

/// String of parameter type \c encoding (@encode(type)).
@property (readonly, nonatomic) NSString *encoding;

/// \c Index of the parameter assigned by program.
@property (readonly, nonatomic) GLuint index;

@end

@implementation GLProgramParameter

+ (NSString *)floatEncoding {
  return [NSString stringWithCString:@encode(float) encoding:NSUTF8StringEncoding];
}

+ (NSString *)matrix4Encoding {
  return [NSString stringWithCString:@encode(GLKMatrix4) encoding:NSUTF8StringEncoding];
}

+ (NSString *)textureEncoding {
  return @"TextureParameterProps";
}

- (instancetype)initWithValue:(id)value encoding:(NSString *)encoding index:(GLuint)index {
  if (self = [super init]) {
    _value = value;
    _encoding = encoding;
    _index = index;
  }
  
  return self;
}

- (UnbindBlockType)bind {
  ParameterTypes *types = [self parameterTypes];
  
  return [types applyType:self.encoding value:self.value index:self.index];
}

- (ParameterTypes *)parameterTypes {
  static ParameterTypes *s_types = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    s_types = [[ParameterTypes alloc] init];
  });

  return s_types;
}

@end

NS_ASSUME_NONNULL_END
