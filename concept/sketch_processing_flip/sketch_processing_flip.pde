import fisica.*;
 
FWorld world;
FCircle c;

float centerx = 150;

float deport = 6;
float h = 86.2 / 2 + 10;

float circle = 50;


void addElement(float angle) {
    
  FBox b = new FBox(h,5);
  float rangle = angle / 180 * 3.1415927;
  b.setRotation(rangle);
  b.setPosition(centerx , centerx);
  
  world.add(b);
  
  FDistanceJoint spring = new FDistanceJoint(c, b);
  spring.setAnchor1( (circle + 2*deport) * cos(rangle), (circle + 2*deport) * sin(rangle) );
  spring.setAnchor2(-2 * deport,0 );
  spring.setDamping(0.1);
  spring.setFrequency(2000);
  
  world.add(spring);
  
  
}


void setup() {
  
  background(204);
  size(400, 400);
 
  Fisica.init(this);
  
  world = new FWorld();
 /* FBox b = new FBox(30,2);
  b.setPosition(10,10);
  world.add(b);
  */
  
  c= new FCircle(60);
  c.setPosition(centerx,centerx); // center
  world.add(c);
  
  
  FCircle d = new FCircle(1);
  d.setStatic(true);
  d.setPosition(centerx,centerx);
  world.add(d);
  
  FRevoluteJoint r = new FRevoluteJoint(c,d);
  world.add(r);
  
  r.setMotorSpeed(0.5);
  r.setMaxMotorTorque(2000);
  r.setEnableMotor(true);
  
  
  for (int i = 0 ; i < 12 ; i ++) {
    addElement( 360/12 * i);
    
  }
  
  FCircle butee = new FCircle(10);
  butee.setPosition(centerx-65,centerx-50);
  butee.setStatic(true);
  world.add(butee);
  

   world.setEdges();
  world.remove(world.top);
    world.setEdgesFriction(0);
   world.setEdgesRestitution(1);
    world.setGrabbable(true);
    
}




void draw() {
  clear();
  world.step();
  world.draw();
}