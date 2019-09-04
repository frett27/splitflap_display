/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup() 
{
  size(200, 200);
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = "COM12";
  myPort = new Serial(this, portName , 115200);
}

// Test 0 : Sequentiel
// Test 1 : Random 

int test = 1;
int no = 0;
int nbtests = 0;
int delay = 1500;



void draw() {
  background(255);
  
  test = (int)Math.pow((Math.random() * 2),2);
  
  switch(test) {
     case 0:
       no = (no + 1) % 12;
       delay = 1500;
       break;
     case 1:
       no = (int)(Math.random() * 12);
       delay = 5000;
     break;
    
  }
  nbtests ++;
  
  String command =String.format("S008DIGIT-%02d\n",no);
  println("" + nbtests + "->"  + command);
    
    myPort.write(command);
    delay(delay);
  
}
