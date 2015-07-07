PImage img = loadImage("pokemon.jpg");

// it's 1200x1920, let's scale it down
img.resize(img.width/2, img.height/2);

// Display image
size(img.width, img.height);
background(img);

float[][] grayscale = new float[img.width][img.height];
// can parallelize
for (int x = 0; x < img.width; x++) {
  for (int y = 0; y < img.height; y++) {
    color c = img.get(x, y);
    grayscale[x][y] = (red(c) + green(c) + blue(c))/3.0;
  }
}

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

float kernel(int x, int y, float[][] kernel) {
  float dotProduct = 0.0;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      
    }
  }
}

