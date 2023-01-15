import processing.serial.*;
import processing.sound.*;

SoundFile file1;
SoundFile file2;
SoundFile file3;
SoundFile file4;
SoundFile file5;
SoundFile toPlay;

Serial port;

String remoteKey="null";
String mouseKey="null";
String data="" ;
float rate=1;
Flock flock;
int millisecLastActivity;

int millisecOfActivityHalo = 4000;

boolean readyForMouse = false;
boolean newGame=true;
PImage img;

void setup() {
  size(1600, 800);

  //port = new Serial(this, "/dev/cu.usbmodem14201", 9600);
  port = new Serial(this, "COM10", 9600);

  img = loadImage("hand.jpg");
  file1 = new SoundFile(this,"LofiBeat.wav");
  file2 = new SoundFile(this,"BassGroove.wav");
  file3 = new SoundFile(this,"BeachyGuitar.wav");
  file4 = new SoundFile(this,"SpacyElectronic.wav");
  file5 = new SoundFile(this,"UpbeatBrass.wav");
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 300/*500*/; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  readyForMouse=true;
  millisecLastActivity = millis();
  
  port.bufferUntil('\n');
}

void draw() {
  background(0);
  if(newGame){
    image(img, 500, 0, 600, 800);
    fill(133,218,139);
    circle(600,height-60,100);
    fill(250,71,71);
    circle(710, height-75,100);
    fill(80,94,225);
    circle(820, height-95, 100);
    fill(192,133,218);
    circle(950, height-60, 100);
    fill(238,154,71);
    circle(990, height-160, 100);
    fill(255);
    textSize(24);
    textAlign(CENTER);
    text("Lofi Beat",560,height-90, 85,80);
    text("Groovy Bass",670, height-105,85,80);
    text("Beach Guitar",780, height-125 ,85,80);
    text("Spacey Electric",910, height-94, 85,80);
    text("Upbeat Brass",950, height-190, 85,80);
    textSize(48);
    textAlign(LEFT);
    text("Choose a Music Track", 100, 75); 

  }else{
     if(!toPlay.isPlaying()){
        newGame=true;
        //toPlay=null;
      }
    //fill(255);
    //System.out.println(remoteKey);
    fill(255,255,255);
    rect(width/5-200, 2*height/3-50, 150, 200);
    rect(2*width/5-125, height/3-100, 150, 200);
    rect(3*width/5-75, height/3-100, 150, 200);
    rect(4*width/5, 2*height/3-50, 150, 200);
    
    if(remoteKey.equals("left")){
          fill(0,0,255);
          rect(width/5-200, 2*height/3-50, 150, 200);
    }else if(remoteKey.equals("up")){
          fill(0,0,255);
      rect(2*width/5-125, height/3-100, 150, 200);
    } else if(remoteKey.equals("down")){
          fill(0,0,255);
      rect(3*width/5-75, height/3-100, 150, 200);
    }else if(remoteKey.equals("right")){
          fill(0,0,255);
      rect(4*width/5, 2*height/3-50, 150, 200);
    }
    
    if(data.contains("left")){
      if(!remoteKey.equals("left")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
     rect(width/5-200, 2*height/3-50, 150, 200);
    }else if(data.contains("up")){
      if(!remoteKey.equals("up")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
      rect(2*width/5-125, height/3-100, 150, 200);
    } else if(data.contains("down")){
      if(!remoteKey.equals("down")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
     rect(3*width/5-75, height/3-100, 150, 200);
    }else if(data.contains("right")){
      if(!remoteKey.equals("right")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
      rect(4*width/5, 2*height/3-50, 150, 200);
    }
    
    if(readyForMouse && !data.equals("null") && !remoteKey.equals("null")){
     
      if(data.contains(remoteKey)){
        increaseUniformity();
      }
      else{
        decreaseUniformity();
      }
      
      //readyForMouse = false;
    }
    
    
    int millisecFromActivity = millis() - millisecLastActivity;
    
    flock.coeffActivity = -1 / (1 + exp((millisecOfActivityHalo - millisecFromActivity)/ (millisecOfActivityHalo*0.3)))+1;
    flock.run();
    if(flock.coeffActivity<0.02 && flock.coeffActivity>-0.02) {
      rate=1;
      toPlay.rate(rate);
    }
  }
}



void mousePressed(){
  //if (mouseButton == LEFT) {
  //  fill(255);
  //} else if (mouseButton == RIGHT) {
  //  fill(166);
  //} else {
  //  fill(0);
  //}
  if(newGame){
    if(mouseX>550 && mouseX<650 && mouseY>height-110 && mouseY<height-10){
      toPlay=file1;
    }else if (mouseX>660 && mouseX<760 && mouseY>height-125 &&mouseY<height-25){
      toPlay=file2;
    }else if (mouseX>770 && mouseX<870 && mouseY>height-145 &&mouseY<height-45){
      toPlay=file3;
    }else if (mouseX>900 && mouseX<1000 && mouseY>height-110 &&mouseY<height-10){
      toPlay=file4;
    }else if (mouseX>940 && mouseX<1040 && mouseY>height-210 &&mouseY<height-110){
      toPlay=file5;
    }
    if(toPlay!=null){
      newGame=false;
      toPlay.play();
      redraw();
    }
  }
}



void keyPressed(){
  
  /*
  if(key== '+'){
    increaseUniformity();
  }else   if(key== '-'){
    decreaseUniformity();
  }
  */
  
  /*else*/ if (key==CODED) {
    if(keyCode==LEFT){
      remoteKey="left";
      //System.out.println("in left");
    }else if(keyCode==UP){
      remoteKey="up";
    }else if(keyCode==DOWN){
      remoteKey="down";
    }else if (keyCode==RIGHT){
      remoteKey="right";
    }   
  }
  redraw();
}
void keyReleased(){
  remoteKey="null";
  redraw();
}



void increaseUniformity(){
    flock.setWrite(true);
    flock.coeffUniformity += 0.33;
    
    if(flock.coeffUniformity > 1 || flock.coeffActivity < 0.3){
      flock.coeffUniformity = 1;
    }
    
    millisecLastActivity = millis();
    rate=min(rate*1.05,2);
    toPlay.rate(rate);
}

void decreaseUniformity(){
    flock.setWrite(true);
    flock.coeffUniformity -= 0.33;
    
    if(flock.coeffUniformity < 0 || flock.coeffActivity < 0.3){
      flock.coeffUniformity = 0;
    
    
    millisecLastActivity = millis();
    rate=max(rate*0.95,0.5);
    toPlay.rate(rate);
}
}

void serialEvent(Serial myPort){

  data=myPort.readStringUntil('\n');

}
