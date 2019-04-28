import fisica.*;
 
FWorld world;
void setup() {
  size(400, 400);
 
  Fisica.init(this);
  
  world = new FWorld();
  
    FBox b = new FBox(30, 70);
  b.setPosition(width/2, height/2);
  world.add(b);
  b.setDensity(10);
  
  
  FBox b1 = new FBox(70, 30);
b1.setPosition(100, 100);
world.add(b1);
FBox b2 = new FBox(20, 50);
b2.setDensity(10);

b2.setPosition(300, 100);
world.add(b2);
FDistanceJoint spring = new FDistanceJoint(b1, b2);
   spring.setFrequency(1.0);
   spring.setDamping(0.3);
   println(b2.getMass());
   
world.add(spring);

    world.setEdges();
  world.remove(world.top);
    world.setEdgesFriction(0);
   world.setEdgesRestitution(1);
    world.setGrabbable(true);
    
}

void draw() {
    background(204);
  clear();
  world.step();
  world.draw();
}