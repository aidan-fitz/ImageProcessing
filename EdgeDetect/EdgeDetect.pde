import processing.video.*;
Capture cam;

PImage img, edges;

boolean displayEdges = false, runCamera = false;

int fps = 30;

// Create processed image
void setup() {
  img = loadImage("pokemon.jpg");
  img.resize(640, 480);//img.width/2, img.height/2);

  size(img.width, img.height);
  edges = edges(img);

  cam = new Capture(this, img.width, img.height, fps);
  frameRate(fps);
}

void draw() {
  if (runCamera) {
    // use webcam
    if (cam.available()) {
      cam.read();
    }
    background(cam);
    if (displayEdges) {
      image(edges(cam), 1, 1);
    }
  } else {
    //use default image
    background(img);
    if (displayEdges) {
      image(edges, 1, 1);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    displayEdges = !displayEdges;
  }
  if (key == 'w' || key == 'W') {
    runCamera = !runCamera;
    if (runCamera) {
      cam.start();
    } else {
      cam.stop();
    }
  }
}

PImage edges(PImage img) {
  float[][] red = gradient(img, RED), 
  green = gradient(img, GREEN), 
  blue = gradient(img, BLUE);

  return fromChannels(red, green, blue);
}

float[][] gradient(PImage img, int channel) {

  float[][] grayscale = getChannel(img, channel);

  float[][] dx = new float[img.width-2][img.height-2];
  float[][] kernelX = { 
    {
      -1, 0, 1
    }
    , 
    {
      -2, 0, 2
    }
    , 
    {
      -1, 0, 1
    }
  };
  // can parallelize
  for (int x = 0; x < img.width - 2; x++) {
    for (int y = 0; y < img.height - 2; y++) {
      dx[x][y] = kernel(grayscale, x, y, kernelX);
    }
  }

  float[][] dy = new float[img.width-2][img.height-2];
  float[][] kernelY = { 
    {
      -1, -2, -1
    }
    , 
    {
      0, 0, 0
    }
    , 
    {
      1, 2, 1
    }
  };
  for (int x = 0; x < img.width - 2; x++) {
    for (int y = 0; y < img.height - 2; y++) {
      dy[x][y] = kernel(grayscale, x, y, kernelY);
    }
  }

  float dist[][] = new float[dx.length][dx[0].length];
  for (int x = 0; x < dx.length; x++) {
    for (int y = 0; y < dx[0].length; y++) {
      dist[x][y] = mag(dx[x][y], dy[x][y]);
    }
  }

  return dist;
}

float kernel(float[][] image, int x, int y, float[][] kernel) {
  float dotProduct = 0.0;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      dotProduct += image[x+i][y+j] * kernel[i][j];
    }
  }
  return dotProduct;
}

final int RED = 0, GREEN = 1, BLUE = 2, GRAYSCALE = 3;
float[][] getChannel(PImage img, int channel) {
  float[][] px = new float[img.width][img.height];
  // can parallelize
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color c = img.get(x, y);
      switch (channel) {
      case RED:
        px[x][y] = red(c);
        break;
      case GREEN:
        px[x][y] = green(c);
        break;
      case BLUE:
        px[x][y] = blue(c);
        break;
      case GRAYSCALE:
        px[x][y] = (red(c) + green(c) + blue(c))/3.0;
        break;
      }
    }
  }
  return px;
}

PImage grayscale(float[][] colors) {
  PImage yolo = createImage(colors.length, colors[0].length, RGB);
  for (int x = 0; x < yolo.width; x++) {
    for (int y = 0; y < yolo.height; y++) {
      yolo.set(x, y, color(colors[x][y]));
    }
  }
  return yolo;
}

PImage fromChannels(float[][] red, float[][] green, float[][] blue) {
  PImage yolo = createImage(red.length, red[0].length, RGB);
  for (int x = 0; x < yolo.width; x++) {
    for (int y = 0; y < yolo.height; y++) {
      yolo.set(x, y, color(red[x][y], green[x][y], blue[x][y]));
    }
  }
  return yolo;
}

