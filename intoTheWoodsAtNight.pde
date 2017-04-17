import processing.video.*;
import codeanticode.syphon.*;

SyphonServer server;
Capture video;

PGraphics canvas;
PImage vid;
PImage coyote;
int t; // Timer
int transition = 20000; // Time interval for the transition
int alt; // Alternating Timer

void settings() {
  size(640,480, P3D);
  PJOGL.profile=1;
}

void setup() {
  canvas = createGraphics(640,480, P3D);
  vid = new PImage(width,height);
  video = new Capture(this, width, height);
  server = new SyphonServer(this, "Processing Syphon");
  coyote = loadImage("coyote.png");
  int cw = coyote.width;
  int ch = coyote.height;
  int ratio = height/width;
  coyote.resize(cw*ratio, height);
  video.start();
  t = transition;
  alt = 0;
}

void draw() {
  if (video.available()) {
    video.read();
    canvas.beginDraw();
      vid.loadPixels();
      
      // Alternate Video effects on a Timer
      if(t < millis()){
        t = millis() + transition;
        alt++;
      }
      if(alt % 9 == 0 ){ // 1 in 9 chance of Coyote encounter...
        vid.set(0, 0, coyote);
        alt++;
      }else if(alt % 2 == 0){ // Effect Number 1
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            int prevColor = canvas.get(width-x,y);
            int currColor = video.get(x,int(height/2));
            color mix = lerpColor(currColor, prevColor,0.9);
            mix = color(int(brightness(mix)));
            vid.set(width-x, y, mix);
          }
        }
      } else {  // Effect Number 2
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            int prevColor = canvas.get(width-x,y);
            int currColor = video.get(x,y);
            color mix = lerpColor(currColor, prevColor,0.99);
            mix = color(int(brightness(mix)));
            vid.set(width-x, y, mix);
          }
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