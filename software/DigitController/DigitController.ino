

// Real Time Kernel
#include <Arduino_FreeRTOS.h>
#include "queue.h"

// Library for controling the stepper
#include "CheapStepper.h"

// manage the parsing of commands
#include "DigitCommandParser.h"

// Number of digits depends on the mecanical design
#define NUMBER_OF_DIGITS 12

#define MAXTOWAIT 1000

void TaskSerialProtocol(void *parameters);


/* Define the data type that will be queued. */
typedef struct A_Message
{
 char ucData[ 30 ];
} AMessage;

/* Define the queue parameters. */
#define QUEUE_LENGTH 2
#define QUEUE_ITEM_SIZE sizeof( AMessage )


static QueueHandle_t xFrontSendingQueue;
static QueueHandle_t xBackSendingQueue;

// attributed address of the module
static uint8_t attributedAddress = -1;


// global positionning (motor)
static int currentStep = -1;

// total step = -1 -> no homing done yet
static int totalSteps = -1;


void setup() {
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);

  /*
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB, on LEONARDO, MICRO, YUN, and other 32u4 based boards.
  }
  */

  
   // Create the queue, storing the returned handle in the xQueue variable. 
  xFrontSendingQueue = xQueueCreate( QUEUE_LENGTH, QUEUE_ITEM_SIZE );
  if( xFrontSendingQueue == NULL )
  {
      // The queue could not be created. 
      Serial.println("Front Queue cannot be created");
  }

  // Create the queue, storing the returned handle in the xQueue variable. 
  xBackSendingQueue = xQueueCreate( QUEUE_LENGTH, QUEUE_ITEM_SIZE );
  if( xBackSendingQueue == NULL )
  {
      // The queue could not be created.
      Serial.println("Back Queue cannot be created");
  }


  // Now set up two tasks to run independently.
  xTaskCreate(
    TaskSerialProtocol
    ,  (const portCHAR *)"Serial"   // A name just for humans
    ,  512  // This stack size can be checked & adjusted by reading the Stack Highwater
    ,  NULL
    ,  2  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL  );

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
      if (pattern[i] == 0) {
        // end of both
        return true;
      }
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


void commandCanceled() {
  Serial.println("commandCanceled");
}

int readUpStream() {
  return Serial.read();
}

int readDownStream() {
  // no read
  return -1;
}

static AMessage bufferMessage;
void pushMessageToQueue(char* message,QueueHandle_t queue) {

  int message_length = strlen(message);
  // copy message
  sprintf(bufferMessage.ucData, "S%03d%s\n", message_length, message);
  if (xQueueSend(queue, &bufferMessage, MAXTOWAIT) != pdPASS) {
    // issue in posting the element on the queue
    Serial.println(F("error in pushing the message"));
  }  
}


void processBackCommand(const char *command) {
  Serial.print(F("Command from Back Executed :"));
  Serial.println(command);
}

void moveTo(uint16_t digit) {
  uint16_t stepsInterval = totalSteps / NUMBER_OF_DIGITS;
  uint16_t s =  digit * totalSteps / NUMBER_OF_DIGITS + stepsInterval * 3 / 4 ;
  objectifStep = s % totalSteps;
}

void processFrontCommand(const char *command) {
  
  Serial.print(F("Command from Front Executed :"));
  Serial.println(command);

  if (startsWith(command,"MOVE-")) { // use char * to avoid String usage
    int steps = atoi((char *)(command + 5));
    objectifStep = steps;
    // Serial.println(objectifStep);
  } else if (startsWith(command, "HELLO")) {
    pushMessageToQueue("HELLO",xFrontSendingQueue );
  } else if (startsWith(command, "IAM-")) {
    int frontAddress = atoi((char *)(command + 4));
    attributedAddress = frontAddress + 1;
    char attributionMessage[12];
    sprintf(attributionMessage, "IAM-%d",attributedAddress);
    pushMessageToQueue(attributionMessage, xBackSendingQueue );
  } else if (startsWith(command, "DIGIT-")) {
    uint16_t digit =atoi((char *)(command + 6));
    moveTo(digit);
  } else if (startsWith(command, "DISPLAY-")) {
     uint8_t offset = 8 + attributedAddress;
     if (offset >= 8) {
       // Serial.println(command[offset]);
       uint16_t digit = command[offset] - '0';
       moveTo(digit);
     }
  }
  else 
  {
    Serial.println(F("unknown command"));
  }
  
}

// structure used for front parsing
static parser_t frontParser;

// structure used for back message parsing
static parser_t backParser;

// Working message
static AMessage m;

// Serial State automaton
// and Serial sending
void TaskSerialProtocol(void *parameters) {
   
    init(&frontParser);
    init(&backParser);
  
    for(;;) {
       
       // receive front
       handleSerialReceive(&frontParser, &processFrontCommand, &readUpStream, &commandCanceled);
       
       // receive back
       handleSerialReceive(&backParser, &processBackCommand, &readDownStream, &commandCanceled);

       // send front messages
        if (uxQueueMessagesWaiting( xFrontSendingQueue ) > 0) {
            
             if (xQueueReceive(xFrontSendingQueue, &m, ( TickType_t ) 0) == pdPASS) {
             // send message to front
             Serial.print(F("front send message:"));
             Serial.println(m.ucData);
           }
        }
       
       // send back messages
      if (uxQueueMessagesWaiting( xBackSendingQueue ) > 0) {
             if (xQueueReceive(xBackSendingQueue, &m, ( TickType_t ) 0) == pdPASS) {
             // send message to back
             Serial.print(F("back send message:"));
             Serial.println(m.ucData);
           }
        }
       
    }
}


////////////////////////////////////////////////////////////////
// Motor Controlling
// 
//  Motor is handled on interrupts to avoid the 15ms watch dog timer of 
//  FreeRT Os
//  This also smooth the move

// Pins in the design
const int IN1 = 10;
const int IN2 = 16;
const int IN3 = 14;
const int IN4 = 15;

// Homing SWITCH READING
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
                bool inHoming = (totalSteps == -1);
                totalSteps = currentStep;
                currentStep = 0;
                if (inHoming) {
                  // next first objective is 0
                  moveTo(0);
                }
              }
               isIn = false;
            } 

    }
}



void TaskMotor(void *parameters) {
  
  Serial.println(F("Motor initialized"));
  for(;;) {
      vTaskDelay(100);
       char buffer[40];
       sprintf(buffer, "%d / %d", currentStep, totalSteps);
      Serial.println(buffer);
     
      //pushMessageToQueue(buffer, xFrontSendingQueue);
  }
}

void loop() {
  //nothing to do, tasks are running
}
