import processing.video.*;

Capture cam;

int coolFactor = 3;

void setup() {
  int fps = 30, w = 640, h = 480;
  size(w, h);
  cam = new Capture(this, w, h, fps);
  frameRate(fps);
  cam.start();
  
  // text settings for displaying coolFactor
  fill(#ffffff);
  textAlign(BOTTOM, LEFT);
  
  PFont aerial = loadFont("DroidSans-24.vlw");
  textFont(aerial, 24);
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  for (int i = 0; i < cam.pixels.length; i++) {
    cam.pixels[i] = posterize(cam.pixels[i] * coolFactor);
//    cam.pixels[i] *= 13;
//    float r = blue(cam.pixels[i]);
//    float g = green(cam.pixels[i]);
//    float b = red(cam.pixels[i]);
//    cam.pixels[i] = color(r, g, b);
  }
  image(cam, 0, 0);
  text(str(coolFactor), 3, height - 3);
}

int posterize(color c) {
  float r = red(c), g = green(c), b = blue(c);
  // do the 7 primary colors (RGBCMYW) first
  if (r == g) {
    if (g > b)
      return #FFFF00;
    else if (g == b)
      return #FFFFFF;
    else // g < b, so it's zero
      return #0000FF;
  }
  else if (g == b) {
    if (g > r)
      return #00FFFF;
    else // g < r
      return #FF0000;
  }
  else if (r == b) {
    if (r > g)
      return #FF00FF;
    else // r < g
      return #00FF00;
  }
  else { // none are equal, 3-p-3 = 6 permutations of {0, 127, 255}
    if (r > g && g > b)
      return #FF7F00;
    else if (r > b && b > g)
      return #FF007F;
    else if (g > r && r > b)
      return #7FFF00;
    else if (g > b && b > r)
      return #00FF7F;
    else if (b > r && r > g)
      return #7F00FF;
    else // b > g > r
      return #007FFF;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP)
      coolFactor++;
    else if (keyCode == DOWN)
      coolFactor--;
  }
}
