/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

PFont mono;

void setup() 
{
  size(600, 400);
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = "COM11";
  myPort = new Serial(this, portName , 115200);
  
  myPort.write("S006IAM--1\n");
  
    mono = createFont("Georgia",64);
}

// Test 0 : Sequentiel
// Test 1 : Random 

int test = 1;
int no = 0;
int no1 = 0;
int nbtests = 0;
int delay = 1500;



void draw() {
  
  delay(delay);
  
  background(255);
  
  test = (int)Math.pow((Math.random() * 2),2);
  
  switch(test) {
     case 0:
       no = (no + 1) % 12;
       no1 = (no1+1) %12;
       delay = 1500;
       break;
     case 1:
       no = (int)(Math.random() * 12);
       no1 = (int)(Math.random() * 12);
       delay = 7000;
     break;
    
  }
  nbtests ++;
  String displayedChars = "" + (char)('0' + no) + (char)('0' + no1);
  

  background(0);
  textSize(250);
  text(displayedChars, 12, 250);

  String command =String.format("S010DISPLAY-%s%s\n",(char)('0' + no),(char)('0' + no1));
  println("" + nbtests + "->"  + command);
    
    myPort.write(command);
    
  
}
