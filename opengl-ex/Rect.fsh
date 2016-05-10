// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

uniform mediump sampler2D t_source;

varying mediump vec2 v_texcoord;

void main() {
  mediump vec4 color = texture2D(t_source, v_texcoord);
  gl_FragColor = color;
}
