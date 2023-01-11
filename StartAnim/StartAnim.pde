//float x = 100;
PImage img;

void setup() {
  size(420,600);
  img = loadImage("img.jpeg");
}

void draw() {
  image(img, 10, 10, 400, 500);
  rect(160, 530, 105, 50, 50);
  fill(255);
  text("START", 183, 564); 
  fill(153);
  textSize(28);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    fill(255);
    launch("../CreaDesPrototype/CreaDesPrototypeSensor/CreaDesPrototypeSensor");
  } else if (mouseButton == RIGHT) {
    fill(166);
  } else {
    fill(0);
  }
}
