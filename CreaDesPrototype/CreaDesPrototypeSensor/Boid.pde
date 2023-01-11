// The Boid class

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  color m_color;
  
  boolean write;
  Boid boidWrite;
  

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    m_color = color(100+ (int)random(150), 100+ (int)random(150), 100+ (int)random(150));

    position = new PVector(x, y);
    r = 4.0;
    maxspeed = 2;
    maxforce = 0.05;
  }

  void run(float coeffUniformity, float coeffActivity, ArrayList<Boid> boids) {
    flock(coeffUniformity, coeffActivity, boids);
    update();
    borders();
    render( coeffUniformity,  coeffActivity );
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(float coeffUniformity, float coeffActivity, ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    
    PVector globalWay = globalWay(boids);
    
    //PVector rand = randForce();
    
    
    // Arbitrarily weight these forces
    sep.mult(1.5 + 0.5*coeffUniformity); //1.5
    
    ali.mult(coeffActivity); // 1
    
    coh.mult(1 - coeffUniformity); // 1
    
    globalWay.mult(0.4* coeffUniformity * coeffActivity);
    
    //rand.mult(1 - coeffUniformity);
    
    
    // Add the force vectors to acceleration

    /*
    if(random(100f) < 1 && coeffActivity > 0.2){
      applyForce(rand);
      
      sep.mult(0.8); 
      ali.mult(0.8);
      coh.mult(0.8);
      rand.mult(0.8);
    }
    */
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(globalWay);
    
    /*
        if(coeffActivity <0.3 && random(100f) < 10) {
          velocity = velocity.mult(2.0/3.0);
        } 
        */
  }
  
  // Method to update position
  void update() {
   
    
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render(float coeffUniformity, float coeffActivity) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    //fill(200, 100);
   
    
    float coeffOfColor = coeffActivity*(1 -coeffUniformity)/2;
    
    if(write == true){
      if(boidWrite == this){
        print("Activ: "+coeffActivity+", Unif: "+coeffUniformity+", colorCoeff: "+coeffOfColor+"\n");
      }
    write = false;  
  }
    
    float intensitySwitchParam = ((int)((velocity.x*velocity.y+acceleration.x*acceleration.y)*72)%100)/ 100;
    int plusR = -50;
    int plusG = -50;
    int plusB = -50;
    if(intensitySwitchParam <0.333){
      plusR = 0;
    }else if( intensitySwitchParam <0.666){
      plusG = 0;
    }
    else{
      plusB = 0;
    }
    
    m_color = color(
      150+  (100 + coeffOfColor*(plusR+ ((int)((velocity.x*velocity.y+acceleration.x*acceleration.y)*72))%100) )/(1+coeffOfColor) , 
      150+ (100 + coeffOfColor*(plusG+ ((int)((velocity.x+ acceleration.x)*72))%100) )/(1+coeffOfColor),
      150+ (100 + coeffOfColor*(plusB+ ((int)((velocity.y+acceleration.y)*72))%100) )/(1+coeffOfColor)
    );
    
    stroke(m_color);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    fill(m_color);
        
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
  
    endShape();
    
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  PVector globalWay(ArrayList<Boid> boids){
    
    PVector sum = new PVector(0,0);
    
    for (Boid other : boids) {
      
      sum = sum.add(other.velocity);
    }
    
    return seek(sum);
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
