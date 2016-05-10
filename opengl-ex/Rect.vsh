// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

uniform mediump mat4 modelViewProjection;

attribute mediump vec2 pos;

varying mediump vec2 v_texcoord;

void main() {
  v_texcoord = pos;
  gl_Position = modelViewProjection * vec4(pos, 0.0, 1.0);
}
