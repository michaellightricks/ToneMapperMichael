// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#ifndef opengl_ex_Header_h
#define opengl_ex_Header_h

#import <GLKit/GLKit.h>

/// Mapping of the internal opengl enums to \c TextureType.
static GLenum glTypes[] = {GL_UNSIGNED_BYTE};

/// Mapping of the internal opengl enums to \c TextureFormat.
static GLenum glFormats[] = {GL_RGB, GL_RGBA};

/// Macro for opengl error handling.
#if (DEBUG)
  #define GL_ERROR_CHECK(funcCall) do {\
    funcCall; \
    GLenum err = glGetError(); \
    if (err != GL_NO_ERROR) { \
      NSLog(@"ERROR: Opengl failed in call %@ %d", (NSString *)CFSTR(#funcCall), err); \
      exit(1); \
    } \
  } while (0)
#else
  #define GL_ERROR_CHECK(funcCall) funcCall
#endif
#endif
