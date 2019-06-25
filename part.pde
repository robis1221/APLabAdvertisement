class Part {
  ArrayList<Individual> particles;
  ArrayList<PVector> lastPositions0, 
    lastPositions1, 
    lastPositions2; 
  PVector start, 
    trajectory;
  PImage mask;

  int timer=0;

  Part(PImage maskTemp) {
    trajectory = new PVector(0, 0, 0);
    mask = maskTemp;
    particles = new ArrayList<Individual>();
    lastPositions0 = new ArrayList<PVector>();
    lastPositions1 = new ArrayList<PVector>();
    lastPositions2 = new ArrayList<PVector>();
    for (int i=0; i<85; i++) {
      lastPositions0.add(trajectory);
    }
    for (int i=0; i<85; i++) {
      lastPositions1.add(trajectory);
    }
    for (int i=0; i<85; i++) {
      lastPositions2.add(trajectory);
    }
  }


  void make(PVector point) {
    start = new PVector(point.x, point.y, point.z*(-1)-300); //the z depth thing is because z is aparently reversed?????
    if (skeletonId==0) {
      trajectory.set(lastPositions0.get(boneId));
      lastPositions0.set(boneId, start);
    } else if (skeletonId==1) {
      trajectory.set(lastPositions1.get(boneId));
      lastPositions1.set(boneId, start);
    } else if (skeletonId==2) {
      trajectory.set(lastPositions2.get(boneId));
      lastPositions2.set(boneId, start);
    } else 
    trajectory.set(start);
    particles.add(new Individual(start, trajectory));
    boneId++;
  }

  void show() {
    for (int i = particles.size()-1; i>=0; i--) {
      Individual p = particles.get(i);
      p.go(mask);
      if (p.deleteMe()) {
        particles.remove(i);
      }
    }
  }
}




class Individual {
  PVector position, 
    speed, 
    acceleration, 
    force1;
  float   life;

  Individual(PVector origin, PVector trajectory) {
    float accScaler = 0.2;
    acceleration = new PVector(random(-0.001, 0.001), 0.1, random(-0.001, 0.001));
    speed = new PVector(origin.x-trajectory.x, origin.y-trajectory.y, origin.z-trajectory.z);
    speed.mult(accScaler);
    //speed = new PVector(0,0.1,0);
    position = origin.copy();
    int spread = 30;
    position.add(random(-spread, spread), random(-spread, spread), random(-spread, spread));
    life=75;
  }
  void go(PImage mask) {
    update();
    display(mask);
  }

  void update() {
    speed.add(acceleration);
    position.add(speed);
    life -=1;
  }

  void display(PImage mask) {
    noStroke();
    fill(200, 200, 250, 200);
    pushMatrix();
    translate(position.x, position.y, position.z);
    rect(0, 0, life/15, life/15);
    popMatrix();
  }


  boolean deleteMe() {
    if (life<0||position.y>height)
      return true; 
    else
      return false;
  }
}