import processing.video.*;

Capture video;
PImage prevFrame;
int counter = 0;

void setup() {
  frameRate(10);
  //size(640, 480);
  fullScreen(2);

  video = new Capture(this, width, height);
  video.start();

  prevFrame = new PImage(width, height);
}

void draw() {
  if (video.available()) {
    video.read();
    if (counter == 0) {
      println("Start!");
      println("Counter: "+counter);
      counter++;
      image(video, 0, 0);
    } else {
      //video.loadPixels();
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          //int wander = int(map(x, 0, width, 0, height));
          int wander = int(height/2); 
          int currColor = video.get(x, wander); // Vertical Lines
          //int currColor = video.get(x, y); // No Vertical Lines
          int prevColor = get(x, y);
          color avgColor = currColor; // No Blur
          //color avgColor = lerpColor(currColor, prevColor, 0.9); // Blur
          set(width-x, y, avgColor);
        }
      }
      //image(prevFrame, 0, 0);
      //updatePixels();
      counter++;
      println("Counter: "+counter);
    }
    filter(GRAY);
  }
}