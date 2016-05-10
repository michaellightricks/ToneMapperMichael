// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "GLNamedParametersSet.h"

#import "GLProgram.h"
#import "GLProgramParameter.h"
#import "TextureParameterProps.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLNamedParametersSet()

/// Program that is associated with this parameter set.
@property (weak, readonly, nonatomic) GLProgram *program;

/// Dictionary that holds uniform values by name.
@property (readonly, nonatomic) NSMutableDictionary<NSString *, GLProgramParameter *> *uniforms;

/// Dictionary that maps parameter name to texture units. This way texture units handled internally
/// and not exposed to user, so we have texture unit per named parameter (uniform).
@property (readonly, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *textureUnits;

@end

@implementation GLNamedParametersSet

- (instancetype)initWithProgram:(GLProgram *)program {
  if (self = [super init]) {
    _program = program;
    
    _uniforms = [NSMutableDictionary dictionary];
    _textureUnits = [NSMutableDictionary dictionary];
  }

  return self;
}

- (void)setFloatParameterByName:(NSString *)name value:(float)value {
  [self setParameterByName:name value:@(value) encoding:[GLProgramParameter floatEncoding]];
}

- (void)setMatrixParameterByName:(NSString *)name value:(float[16])value {
  GLKMatrix4 mat = GLKMatrix4MakeWithArray(value);
  NSValue *nsVal = [NSValue valueWithBytes:&mat objCType:@encode(GLKMatrix4)];
  [self setParameterByName:name value:nsVal encoding:[GLProgramParameter matrix4Encoding]];
}

- (void)setTextureParameterByName:(NSString *)name value:(id<Texture2D>)texture {
  GLenum textureUnit = [self textureUnitByName:name];
  
  TextureParameterProps *props = [[TextureParameterProps alloc] initWithTexture:texture
                                                                           unit:textureUnit];
  
  [self setParameterByName:name value:props encoding:[GLProgramParameter textureEncoding]];
}

- (void)setParameterByName:(NSString *)name value:(id)value encoding:(NSString *)encoding {
  NSInteger idx = [self.program parameterIdxByName:name];
  
  if (idx == NSNotFound) {
    NSString *reason = [NSString stringWithFormat:@"Can't find uniform name %@ at program %@", name,
                       self.program];
    
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:reason
                                 userInfo:nil];
  }
  
  GLProgramParameter *p = [[GLProgramParameter alloc] initWithValue:value encoding:encoding
                                                              index:(int)idx];
  [self.uniforms setValue:p forKey:name];
}

- (GLenum)textureUnitByName:(NSString *)name {
  NSNumber *val = [self.textureUnits valueForKey:name];
  if (!val) {
    val = @(GL_TEXTURE0 + self.textureUnits.count);
    self.textureUnits[name] = val;
  }
  
  return val.unsignedIntValue;
}

- (UnbindBlockType)bind {
  NSMutableArray<UnbindBlockType> *unbindBlocks = [NSMutableArray array];
  
  for (GLProgramParameter *p in [self.uniforms allValues]) {
    UnbindBlockType unbind = [p bind];
    if (unbind) {
      [unbindBlocks addObject:unbind];
    }
  }
  
  return ^{
    for (UnbindBlockType unbind in [unbindBlocks reverseObjectEnumerator]) {
      unbind();
    }
  };
}

@end

NS_ASSUME_NONNULL_END
