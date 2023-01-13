import processing.serial.*;

Serial port;

String remoteKey="null";
String mouseKey="null";
String data="" ;

Flock flock;
int millisecLastActivity;

int millisecOfActivityHalo = 4000;

boolean readyForMouse = false;
boolean newGame=true;
PImage img;

void setup() {
  size(1600, 800);
  //fill(255);
  //port = new Serial(this, "/dev/cu.usbmodem14201", 9600);
  port = new Serial(this, "COM10", 9600);
  //rect(width/5-200, 2*height/3, 200, 300);
  //rect(2*width/5-100, height/3-50, 200, 300);
  //rect(3*width/5-100, height/3-50, 200, 300);
  //rect(4*width/5, 2*height/3, 200, 300);
  ////noLoop();
  img = loadImage("img.jpeg");
 
  
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
  if(newGame){
      image(img, 500, 0, 600, 800);
    fill(255);
    triangle(850,height-125, 850, height-25,1000,height-75);
    fill(20,225,120);
    text("START", 862, height-63); 
    textSize(32);
  }else{
    //fill(255);
    background(0);
    //System.out.println(remoteKey);
    fill(255,255,255);
    rect(width/5-200, 2*height/3-50, 200, 300);
    rect(2*width/5-125, height/3-100, 200, 300);
    rect(3*width/5-75, height/3-100, 200, 300);
    rect(4*width/5, 2*height/3-50, 200, 300);
    
    if(remoteKey.equals("left")){
          fill(0,0,255);
          rect(width/5-200, 2*height/3-50, 200, 300);
    }else if(remoteKey.equals("up")){
          fill(0,0,255);
      rect(2*width/5-125, height/3-100, 200, 300);
    } else if(remoteKey.equals("down")){
          fill(0,0,255);
      rect(3*width/5-75, height/3-100, 200, 300);
    }else if(remoteKey.equals("right")){
          fill(0,0,255);
      rect(4*width/5, 2*height/3-50, 200, 300);
    }
    
    if(data.contains("left")){
      if(!remoteKey.equals("left")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
     rect(width/5-200, 2*height/3-50, 200, 300);
    }else if(data.contains("up")){
      if(!remoteKey.equals("up")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
      rect(2*width/5-125, height/3-100, 200, 300);
    } else if(data.contains("down")){
      if(!remoteKey.equals("down")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
     rect(3*width/5-75, height/3-100, 200, 300);
    }else if(data.contains("right")){
      if(!remoteKey.equals("right")){
        fill(0,255,0);   
      }
      else{
        fill(255,0,0);   
      }
      rect(4*width/5, 2*height/3-50, 200, 300);
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
  }
}



//void mousePressed(){
 
//    if(mouseX<290 && mouseX>110 && mouseY>260 && mouseY<340){
//      mouseKey="left";
//    }else if (mouseX<530 && mouseX>410 && mouseY>260 &&mouseY<340){
//      mouseKey="right";
//    }else if (mouseX<340 && mouseX>260 && mouseY>160 &&mouseY<240){
//      mouseKey="up";
//    }else if (mouseX<340 && mouseX>260 && mouseY>360 &&mouseY<440){
//      mouseKey="down";
//    }
//    redraw();
  
//    isMouseActivityToBeConsiderYet = true;
//}

//void mouseReleased(){
//  mouseKey="null";
//  redraw();
  
//  isMouseActivityToBeConsiderYet = false;
//}

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

void mousePressed() {
  if (mouseButton == LEFT) {
    fill(255);
    newGame=false;
  } else if (mouseButton == RIGHT) {
    fill(166);
  } else {
    fill(0);
  }
}

void increaseUniformity(){
    flock.setWrite(true);
    flock.coeffUniformity += 0.33;
    
    if(flock.coeffUniformity > 1 || flock.coeffActivity < 0.3){
      flock.coeffUniformity = 1;
    }
    
    millisecLastActivity = millis();
}

void decreaseUniformity(){
    flock.setWrite(true);
    flock.coeffUniformity -= 0.33;
    
    if(flock.coeffUniformity < 0 || flock.coeffActivity < 0.3){
      flock.coeffUniformity = 0;
    
    
    millisecLastActivity = millis();
}
}

void serialEvent(Serial myPort){

  data=myPort.readStringUntil('\n');

}
