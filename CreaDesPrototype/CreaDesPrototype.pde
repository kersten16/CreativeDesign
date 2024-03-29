String remoteKey="null";
String mouseKey="null";

Flock flock;
int millisecLastActivity;

int millisecOfActivityHalo = 4000;

boolean isMouseActivityToBeConsiderYet = false;


void setup() {
  size(1600, 1000);
  //fill(255);

  //System.out.println(remoteKey);
  
  rect(100, 500, 210, 300);
  rect(650, 100, 300, 210);
  rect(650, 750, 300, 210);
  rect(1250, 500, 210, 300);
  //noLoop();
  
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
  millisecLastActivity = millis();
}

void draw() {
  //fill(255);
  background(0);
  //System.out.println(remoteKey);
  fill(255,255,255);
  rect(100, 500, 210, 300);
  rect(650, 100, 300, 210);
  rect(650, 750, 300, 210);
  rect(1250, 500, 210, 300);
  
  
  if(remoteKey.equals("left")){
        fill(0,0,255);
    rect(100, 500, 210, 300);
  }else if(remoteKey.equals("up")){
        fill(0,0,255);
    rect(650, 100, 300, 210);
  } else if(remoteKey.equals("down")){
        fill(0,0,255);
    rect(650, 750, 300, 210);
  }else if(remoteKey.equals("right")){
        fill(0,0,255);
    rect(1250, 500, 210, 300);
  }
  
  if(mouseKey.equals("left")){
    if(!remoteKey.equals("left")){
      fill(255,0,0);   
    }
    else{
      fill(0,255,0);   
    }
    rect(100, 500, 210, 300);
  }else if(mouseKey.equals("up")){
    if(!remoteKey.equals("up")){
      fill(255,0,0);   
    }
    else{
      fill(0,255,0);   
    }
    rect(650, 100, 300, 210);
  } else if(mouseKey.equals("down")){
    if(!remoteKey.equals("down")){
      fill(255,0,0);   
    }
    else{
      fill(0,255,0);   
    }
    rect(650, 750, 300, 210);
  }else if(mouseKey.equals("right")){
    if(!remoteKey.equals("right")){
      fill(255,0,0);   
    }
    else{
      fill(0,255,0);   
    }
    rect(1250, 500, 210, 300);
  }
  
  if(isMouseActivityToBeConsiderYet && !mouseKey.equals("null") && !remoteKey.equals("null")){
   
    if(mouseKey.equals(remoteKey)){
      increaseUniformity();
    }
    else{
      decreaseUniformity();
    }
    
    isMouseActivityToBeConsiderYet = false;
  }
  
  
  int millisecFromActivity = millis() - millisecLastActivity;
  
  flock.coeffActivity = -1 / (1 + exp((millisecOfActivityHalo - millisecFromActivity)/ (millisecOfActivityHalo*0.3)))+1;
  
  flock.run();
}



void mousePressed(){
 
    if(mouseX<290 && mouseX>110 && mouseY>260 && mouseY<340){
      mouseKey="left";
    }else if (mouseX<530 && mouseX>410 && mouseY>260 &&mouseY<340){
      mouseKey="right";
    }else if (mouseX<340 && mouseX>260 && mouseY>160 &&mouseY<240){
      mouseKey="up";
    }else if (mouseX<340 && mouseX>260 && mouseY>360 &&mouseY<440){
      mouseKey="down";
    }
    redraw();
  
    isMouseActivityToBeConsiderYet = true;
}

void mouseReleased(){
  mouseKey="null";
  redraw();
  
  isMouseActivityToBeConsiderYet = false;
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
}

void decreaseUniformity(){
    flock.setWrite(true);
    flock.coeffUniformity -= 0.33;
    
    if(flock.coeffUniformity < 0 || flock.coeffActivity < 0.3){
      flock.coeffUniformity = 0;
    }
    
    millisecLastActivity = millis();
}
