PImage img;
PImage copy1;
//defines the kernels used for the different filters
float [][] kernelGaussianBlur = {{0.0625,0.125,0.0625},{0.125,0.25,0.125},{0.0625,0.125,0.0625}};
float [][] kernelGx = {{-1,0,1},{-2,0,2},{-1,0,1}};
float [][] kernelGy = {{-1,-2,-1},{0,0,0},{1,2,1}};

void setup() {
  //loads the original image
  img = loadImage("landscape.jpg");
  //automatically resizes the canvas
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
}

void draw() {
  //creates copy of the original image
  copy1 = createImage(img.width, img.height, ARGB);
  image(img,0,0);
  //defines which filter is applied when keys [1,5] are pressed
  if (key == '0') {
    noFilter(img, copy1);
  } if (key == '1') {
    myGrayscale(img, copy1);
  } if (key == '2') {
    myContrast(img, copy1);
  } if (key == '3') {
    myGaussianBlur(kernelGaussianBlur, img, copy1);
  } if (key == '4') {
    myEdge(kernelGx, kernelGy, img, copy1);
  } if (key == '5') {
    myFilter(img, copy1);
  } 
}

void myFilter(PImage img, PImage copy) {
  colorMode(RGB,255,255,255);
  colorMode(HSB);
  img.loadPixels();
  copy.loadPixels();
  float threshold = 100;
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
      int index = x+img.width*y;
      //finds the original values of the hue, saturation, and brightness
      float hue = hue(img.pixels[index]);
      float saturation = saturation(img.pixels[index]);
      float brightness = brightness(img.pixels[index]);
      //adjusts the values of the hue, saturation, and brightness in relation to 
      //the hue and the threshold value
      if (hue > threshold) {
        hue += 50;
        brightness += 20;
        saturation += 15;
        hue = constrain(abs(hue),0,255);
        saturation = constrain(abs(saturation),0,255);
        brightness = constrain(abs(brightness),0,255);
        color c = color(hue,saturation,brightness);
        copy.pixels[index] = c;
      } else {
        hue -= 50;
        brightness += 10;
        hue = constrain(abs(hue),0,255);
        brightness = constrain(abs(brightness),0,255);
        //defines the new color
        color c = color(hue,saturation,brightness);
        //applies the new color to the corresponding pixel
        copy.pixels[index] = c;
      }
    }
   }
  //updates modifications to pixels
  copy.updatePixels();
  image(copy,0,0);     
}

void myEdge(float [][] Gx, float [][] Gy, PImage img, PImage copy) {
  colorMode(RGB,1.0,1.0,1.0);
  img.loadPixels();
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
      //resets the value of red, green, blue each loop
      float red1 = 0;
      float green1 = 0;
      float blue1 = 0;
      
      float red2 = 0;
      float green2 = 0;
      float blue2 = 0;
      for (int i = 0; i < 3; i++) {
        for(int j = 0; j < 3; j++) {
          int index = (x+i-1) + img.width*(y+j-1);
          //applies the kernel values from Gx
          red1 += red(img.pixels[index])*Gx[i][j];
          green1 += green(img.pixels[index])*Gx[i][j];
          blue1 += blue(img.pixels[index])*Gx[i][j];
          //applies the kernel values from Gy
          red2 += red(img.pixels[index])*Gy[i][j];
          green2 += green(img.pixels[index])*Gy[i][j];
          blue2 += blue(img.pixels[index])*Gy[i][j];
        }
      }
      //constrains all values to be between 0 and 1.0
      red1 = constrain(abs(red1),0,1.0);
      green1 = constrain(abs(green1),0,1.0);
      blue1 = constrain(abs(blue1),0,1.0);
      red2 = constrain(abs(red2),0,1.0);
      green2 = constrain(abs(green2),0,1.0);
      blue2 = constrain(abs(blue2),0,1.0);
      
    //finds the magnitude of each value
    double red = Math.sqrt(red1*red1+red2*red2);
    double green = Math.sqrt(green1*green1+green2*green2);
    double blue = Math.sqrt(blue1*blue1+blue2*blue2);
    copy.loadPixels();
    //defines the new color
    color c = color((float)red,(float)green,(float)blue);
    int index = x+img.width*y;
    //applies the color to the corresponding pixel
    copy.pixels[index] = c;
    }
  }
  //update modifications to pixels
  copy.updatePixels();
  image(copy,0,0);   
}

void noFilter(PImage img, PImage copy) {
  colorMode(RGB);
  img.loadPixels();
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
    copy.loadPixels();
    int index = x+img.width*y;
    //finds the original rgb values from img
    float red = red(img.pixels[index]);
    float green = green(img.pixels[index]);
    float blue = blue(img.pixels[index]);
    
    //constrains the values to be between 0 and 255
    red = constrain(abs(red),0,255);
    green = constrain(abs(green),0,255);
    blue = constrain(abs(blue),0,255);
    //defines the new color
    color c = color(red, green, blue);
    //applies the color the corresponding pixel
    copy.pixels[index] = c;
    }
  }
  //update modifications to pixels
  copy.updatePixels();
  image(copy,0,0);   
}

void myContrast(PImage img, PImage copy) {
  colorMode(RGB,255,255,255);
  colorMode(HSB);
  img.loadPixels();
  copy.loadPixels();
  //defines threshold value that is compared to brightness
  float threshold = 100;
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
      int index = x+img.width*y;
      //finds the original hue, saturation, and brightness values
      float hue = hue(img.pixels[index]);
      float saturation = saturation(img.pixels[index]);
      float brightness = brightness(img.pixels[index]);
      //compares the brightness to the threshold value and adjusts accordingly
      if (brightness > threshold) {
        brightness += 25;
        brightness = constrain(abs(brightness),0,255);
        //defines the new color
        color c = color(hue,saturation,brightness);
        //applies the color the corresponding pixel
        copy.pixels[index] = c;
      } else {
        brightness -= 15;
        brightness = constrain(abs(brightness),0,255);
        //defines the new color
        color c = color(hue,saturation,brightness);
        //applies the color to the corresponding pixel
        copy.pixels[index] = c;
      }
    }
   }
  //update modifications to pixels
  copy.updatePixels();
  image(copy,0,0);     
}

void myGaussianBlur(float [][] matrix, PImage img, PImage copy) {
  colorMode(RGB);
  img.loadPixels();
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
      //resets the value of red, green, blue each loop
      float red = 0;
      float green = 0;
      float blue = 0;
      //applies the kernel values to find the new values of rgb
      for (int i = 0; i < 3; i++) {
        for(int j = 0; j < 3; j++) {
          int index = (x+i-1) + img.width*(y+j-1);
          red += red(img.pixels[index])*matrix[i][j];
          green += green(img.pixels[index])*matrix[i][j];
          blue += blue(img.pixels[index])*matrix[i][j];
        }
      }
      //constrains the values to be between 0 and 255
      red = constrain(abs(red),0,255);
      green = constrain(abs(green),0,255);
      blue = constrain(abs(blue),0,255);
  
    copy.loadPixels();
    //defines the new color
    color c = color(red,green,blue);
    int index = x+img.width*y;
    //applies the color the corresponding pixel
    copy.pixels[index] = c;
    }
  }
  //update modifications to pixels
  copy.updatePixels();
  image(copy,0,0);   
}

void myGrayscale(PImage img, PImage copy) {
  colorMode(RGB);
  img.loadPixels();
  //traverses the pixels in the original image
  for (int x = 1; x<img.width - 1; x++) {
    for (int y = 1; y<img.height - 1; y++) {
      //resets the value of red, green, blue each loop
      int index = x+img.width*y;
      float red = red(img.pixels[index]);
      float green = green(img.pixels[index]);
      float blue = blue(img.pixels[index]);
      //constrains the values to be between 0 and 255
      red = constrain(abs(red),0,255);
      green = constrain(abs(green),0,255);
      blue = constrain(abs(blue),0,255);
      //finds the average of the new rgb values
      float average = (red+green+blue)/3;
  
    copy.loadPixels();
    //defines the new color
    color c = color(average);
    //applies the color to the corresponding pixel
    copy.pixels[index] = c;
    }
  }
  //update modifications to pixels
  copy.updatePixels();
  image(copy,0,0);    
}
