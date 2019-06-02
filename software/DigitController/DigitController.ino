
// Real Time Kernel
#include <Arduino_FreeRTOS.h>

// Library for controling the stepper
#include "CheapStepper.h"

#include "DigitCommandParser.h"


void TaskSerialProtocol(void *parameters);


void setup() {
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);
  
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
  }

  // Now set up two tasks to run independently.
  xTaskCreate(
    TaskSerialProtocol
    ,  (const portCHAR *)"Serial"   // A name just for humans
    ,  512  // This stack size can be checked & adjusted by reading the Stack Highwater
    ,  NULL
    ,  2  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );

     // Now set up two tasks to run independently.
  xTaskCreate(
    TaskMotor
    ,  (const portCHAR *)"Motor Report"   // A name just for humans
    ,  128  // This stack size can be checked & adjusted by reading the Stack Highwater
    ,  NULL
    ,  2  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );

   initMotor();
    
   vTaskStartScheduler();
}



static int objectifStep = -1; // no objectives


// Protocol handling
//    0 - Wait for Assigned Number
//    1 - Wait for Commands
//    

boolean startsWith(char *str, char *pattern) {
  unsigned int i = 0;
  for (;;) {
    if (str[i] == 0) {
      // end of string
      return false;
    }
    if (pattern[i] == 0) {
      // end of pattern
      return true; 
    }
    if (str[i] != pattern[i]) {
      return false;
    }
    i++;
  }
}


void processCommand(const char *command) {
  
  Serial.print("Command Executed :");
  Serial.println(command);

  if (startsWith(command,"MOVE-")) { // use char * to avoid String usage
    int steps = atoi((char *)(command + 5));
    objectifStep = steps;
    Serial.println(objectifStep);
  } else 
  {
    Serial.println("unknown command");
  }
  
}

void commandCanceled() {
  Serial.println("commandCanceled");
}

int readUpstream() {
  return Serial.read();
}

int readDownStream() {
  
}

static parser_t frontParser;

// Serial State automaton
void TaskSerialProtocol(void *parameters) {
    init(&frontParser);
    for(;;) {
       handleSerialReceive(&frontParser, &processCommand, &readUpstream, &commandCanceled);
    }
}


////////////////////////////////////////////////////////////////
// Motor Controlling
// 
//  Motor is handled on interrupts to avoid the 15ms watch dog timer of 
//  FreeRT Os
//  This also smooth the move

// Pins
const int IN1 = 10;
const int IN2 = 16;
const int IN3 = 14;
const int IN4 = 15;

// Homing
const int SWITCH = 18;

// managing the stepper steps
static const CheapStepper cs = CheapStepper(IN1,IN2,IN3,IN4);

void initMotor() {
  
    // Motor interrupt handling

    pinMode(IN1,OUTPUT);
    pinMode(IN2,OUTPUT);
    pinMode(IN3,OUTPUT);
    pinMode(IN4,OUTPUT);
  
    pinMode(SWITCH,INPUT);

    DDRC |= 0x80;
    cli();          // disable global interrupts
    TCCR1A = 0;     // set entire TCCR1A register to 0
    TCCR1B = 0;     // same for TCCR1B
    // set compare match register to desired timer count
    // 13 -> too fast
    OCR1A = 20;
    // turn on CTC mode:
    TCCR1B |= (1 << WGM12);
    // Set CS10 and CS12 bits for 1024 prescaler
    TCCR1B |= (1 << CS10);
    TCCR1B |= (1 << CS12);
    
    // enable timer compare interrupt
    TIMSK1 |= (1 << OCIE1A);
    // enable global interrupts
    
    sei();
}


// global positionning
static int currentStep = -1;
static int totalSteps = -1;

static bool isIn = false;
static int nbIn = 0;


const int T_THRESHOLD = 100;

ISR(TIMER1_COMPA_vect) {
    
    if (totalSteps < 4060 || 
          (objectifStep != currentStep && objectifStep > 0) ) {
    
          cs.move(true,1);
          if (currentStep >=0) {
            currentStep ++;
          }
          
            // watch the homing state
        
            int value = analogRead(SWITCH);
            
            // measure threshold
            if (value > 10) {
              // floating value
               if (!isIn) {
                  nbIn ++;
                  nbIn = nbIn > T_THRESHOLD ? T_THRESHOLD : nbIn;
               }
            } else {
              nbIn--;
              nbIn = nbIn <= 0 ? 0 : nbIn - 1; 
            }
        
            if (nbIn >= T_THRESHOLD) {
              isIn = true;
            }
        
            if (nbIn <= 0 && isIn) {
              // homing point
              if (currentStep < 0) {
                currentStep = 0;
              } else {
                // adjust the stepnumber
                totalSteps = currentStep;
                currentStep = 0;
              }
               isIn = false;
            } 

    }
}



void TaskMotor(void *parameters) {
  
  Serial.println("Motor initialized");
  for(;;) {
      vTaskDelay(10);
      Serial.println(analogRead(SWITCH));
      Serial.print(currentStep);
      Serial.print("/");
      Serial.println(totalSteps);
      
  }
}

void loop() {
  //nothing to do, tasks are running
}



