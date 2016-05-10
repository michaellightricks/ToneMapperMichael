// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ResourceFactory.h"

#import <GLKit/GLKit.h>

#import "Defs.h"
#import "GLBuffer.h"
#import "GLFramebuffer.h"
#import "GLProgram.h"
#import "GLTexture2D.h"
#import "GLVertexAttributesArray.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ResourceFactory

+ (id<Buffer>)bufferWithBytes:(NSData *)data usage:(GLenum)usage {
  GLBuffer *buffer = [[GLBuffer alloc] initArrayWithUsage:usage];
  
  [ResourceFactory setupBuffer:buffer data:data];
  
  return buffer;
}

+ (void)setupBuffer:(GLBuffer *)buffer data:(NSData *)data {
  [buffer setBytes:data];
}

+ (id<Buffer>)dynamicBufferWithBytes:(NSData *)data {
  return [ResourceFactory bufferWithBytes:data usage:BufferUsageDynamic];
}

+ (id<Buffer>)staticBufferWithBytes:(NSData *)data {
  return [ResourceFactory bufferWithBytes:data usage:BufferUsageStatic];
}

+ (id<Buffer>)elementBufferWithBytes:(NSData *)data {
  GLBuffer *buffer = [[GLBuffer alloc] initElementWithUsage:BufferUsageStatic];
  [ResourceFactory setupBuffer:buffer data:data];
  return buffer;
}

+ (id<VertexAttributesArray>)vertexAttributesArray:(NSArray<id<VertexAttribute>> *)attributes {
  return [[GLVertexAttributesArray alloc] initWithAttributes:attributes];
}

+ (id<Program>)programWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment {
  return [[GLProgram alloc] initWithVertexShader:vertex fragmentShader:fragment];
}

+ (nullable id<Program>)programFromBundleWithResourceName:(NSString *)resourceName {
  NSBundle* main = [NSBundle mainBundle];
  
  NSString *vshPath = [main pathForResource:resourceName ofType:@"vsh"];
  NSString *fshPath = [main pathForResource:resourceName ofType:@"fsh"];
  
  NSError *error = nil;
  NSString *vsh = [NSString stringWithContentsOfFile:vshPath encoding:NSUTF8StringEncoding
                                               error:&error];
  if (error) {
    NSLog(@"%@", error);
    return nil;
  }
  
  NSString *fsh = [NSString stringWithContentsOfFile:fshPath encoding:NSUTF8StringEncoding
                                               error:&error];
  if (error) {
    NSLog(@"%@", error);
    return nil;
  }
  
  return [self programWithVertexShader:vsh fragmentShader:fsh];
}

+ (id<Texture2D>)textureWithProps:(Texture2DProps *)props andData:(nullable NSData *)data {
  GLTexture2D *result = [[GLTexture2D alloc] initWithProps:props];
  
  [Scope bind:result andExecute:^{
    [result setDefaultParameters];
    [result updateWithData:data];
  }];
  
  return result;
}

+ (id<Texture2D>)textureFromData:(NSData *)data {
  NSError *error;
  
  // GLKTextureLoader binds the loaded texture which ruins previous state, lets save it.
  GLint prevTexture;
  GL_ERROR_CHECK(glGetIntegerv(GL_TEXTURE_BINDING_2D, &prevTexture));
  GLKTextureInfo *info =
      [GLKTextureLoader textureWithContentsOfData:data
                                          options:@{GLKTextureLoaderOriginBottomLeft: @YES}
                                            error:&error];
  GL_ERROR_CHECK(glBindTexture(GL_TEXTURE_2D, prevTexture));
  
  return [[GLTexture2D alloc] initWithInfo:info];
}

+ (id<Framebuffer>)frameBufferWithTexture:(id<Texture2D>)texture {
  return [[GLFramebuffer alloc] initWithTexture:texture];
}

@end

NS_ASSUME_NONNULL_END
