//----------------------------------------------------------------------------------------#
// 
// Video Installation for a SET Creative event called Into The Woods at Night
// Author: Kit MacAllister
// Copyright 2017 Kit MacAllister
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// 
//----------------------------------------------------------------------------------------#


import processing.video.*;
import codeanticode.syphon.*;

SyphonServer server;
Capture video;

PGraphics canvas;
PImage vid;
float fader =0.9; // Value of the blur between frames

void settings() {
  size(640,480, P3D);
  PJOGL.profile=1;
}

void setup() {
  canvas = createGraphics(640,480, P3D);
  vid = new PImage(width,height);
  video = new Capture(this, width, height);
  server = new SyphonServer(this, "Processing Syphon");
  video.start();
}

void draw() {
  if (video.available()) {
    video.read();
    canvas.beginDraw();
      vid.loadPixels();
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          int prevColor = canvas.get(x,y);
          int currColor = video.get(x,int(height/2));
          color mix = lerpColor(currColor, prevColor, fader);
          mix = color(int(mix));
          vid.set(x, y, mix);
        }
      }
      
      // Update Canvas
      vid.updatePixels();
      canvas.set(0,0, vid);
      image(canvas,0,0);
    canvas.endDraw();
    server.sendImage(canvas);
  }
}