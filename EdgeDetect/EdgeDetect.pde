PImage img, edges;

boolean displayEdges = false;

// Display image
void setup() {
  img = loadImage("pokemon.jpg");
//  img.resize(img.width/2, img.height/2);

  size(img.width, img.height);

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

  edges = grayscale(dist);
}

void draw() {
  background(img);
  if (displayEdges) {
    image(edges, 1, 1);
  }
}

void keyPressed() {
  displayEdges = !displayEdges;
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

PImage grayscale(float[][] colors) {
  PImage yolo = createImage(colors.length, colors[0].length, RGB);
  for (int x = 0; x < yolo.width; x++) {
    for (int y = 0; y < yolo.height; y++) {
      yolo.set(x, y, color(colors[x][y]));
    }
  }
  return yolo;
}

