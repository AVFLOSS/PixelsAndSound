import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer in;  // uncomment to use audio file
//AudioInput in; // uncomment to use mic
FFT fft;

float theta = 0;  //angle
float r;  // radius


void setup() {
  size(1280, 720);
  //fullScreen();
  minim = new Minim(this);
  //in = minim.getLineIn(Minim.STEREO, 1024); // uncomment to use mic
  
  //in = minim.loadFile("trepador_azul.mp3", 1024); // uncomment only one to use audio file
  //in = minim.loadFile("herrerillo_capuchino.mp3", 1024); // uncomment only one to use audio file
  in = minim.loadFile("improvisacion.mp3", 1024); // uncomment only one to use audio file
  in.loop(); // uncomment  to use audio file
  fft = new FFT(in.bufferSize(), in.sampleRate());
 
  //set the radius to 45% of the heigth of the sketch
  r = height * 0.45;

  colorMode(HSB, 360, 100, 100, 100);
  background(240, 100, 100);
  
  // avoid anti aliasing
  smooth();
}

void draw() {
  
  fft.forward(in.mix);
  
  loadPixels();
  // loop 5 times for each draw loop
  for (int j = 0; j < 5; j++) {
    // for each point of the radius size 'r'
    for (int i = 0; i < r; i++) {
      // get the cartesian coordinates x y
      int x = int(i * cos(theta));
      int y = int(i * sin(theta));
      //  get the pure color depending on the value returned by fft.getBand()
      float hue = 240 - fft.getBand(int(r) - 1 - i) * 50; //*30;
      
      // delete previous pixels before are drawn again
      int prevX = int(i * cos(theta+PI));
      int prevY = int(i * sin(theta+PI));
      int prevLoc = (prevX+width/2) +  (prevY+height/2) * width;
      
      // reference: https://processing.org/reference/leftshift.html 
      pixels[prevLoc] = 255 << 24 | 3 << 16 | 0 << 8 | 255;
      
      // want to keep the hue between 0 y 240 
      if (hue > 240) hue = 240;
      if (hue < 0) hue = 0;
      
      // create the processing color
      color col = color(hue, 100, 100);
      
      // get the pixel from the center
      int loc = (x+width/2) +  (y+height/2) * width;
      
      // add the color to the pixel
      pixels[loc] = col;
    }
    
    // increase the angle
    theta += 0.001;

    //// clear all pixels for each full circle
    //if (theta > TWO_PI) {
    //  theta = 0;
    //  for (int i = 0; i < pixels.length; i++) {
    //    pixels[i] = 255 << 24 | 3 << 16 | 0 << 8 | 255;
    //  }
    //}
  }
  updatePixels();
}
// stop minim when exiting
void stop() {
  in.close();
  minim.stop();
  super.stop();
}
