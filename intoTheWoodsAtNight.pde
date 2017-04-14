import processing.video.*;
Capture video;

void setup() {
  fullScreen(2);
  video = new Capture(this, width, height);
  video.start();
}

void draw() {
  if (video.available()) {
    video.read();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int lineColor = video.get(x, int(height/2));
        set(width-x, y, lineColor);
      }
    }
    filter(GRAY);
  }
}