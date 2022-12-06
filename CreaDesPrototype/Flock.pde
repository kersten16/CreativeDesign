// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  
  float coeffUniformity;
  float coeffActivity;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    
    coeffActivity = 0;
    coeffUniformity = 1;
  }



  void run() {
    for (Boid b : boids) {
      b.run(coeffUniformity, coeffActivity, boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}
