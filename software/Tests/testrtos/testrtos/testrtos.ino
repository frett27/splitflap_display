

#include <Arduino_FreeRTOS.h>
// #include <pins_arduino.h>

#include "CheapStepper.h"

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
    ,  128  // This stack size can be checked & adjusted by reading the Stack Highwater
    ,  NULL
    ,  2  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );


   xTaskCreate(
    TaskMotor
    ,  (const portCHAR *)"Motor"   // A name just for humans
    ,  256  // This stack size can be checked & adjusted by reading the Stack Highwater
    ,  NULL
    ,  2  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );



    DDRC |= 0x80;
    cli();          // disable global interrupts
    TCCR1A = 0;     // set entire TCCR1A register to 0
    TCCR1B = 0;     // same for TCCR1B
    // set compare match register to desired timer count
    OCR1A = 15;
    // turn on CTC mode:
    TCCR1B |= (1 << WGM12);
    // Set CS10 and CS12 bits for 1024 prescaler
     TCCR1B |= (1 << CS10);
    TCCR1B |= (1 << CS12);
    
    // enable timer compare interrupt
    TIMSK1 |= (1 << OCIE1A);
    // enable global interrupts
    
    sei();
    
     vTaskStartScheduler();
  
}

void TaskSerialProtocol(void *parameters) {
  for(;;) {
    Serial.println("hello from task");
     vTaskDelay(10); // yield
  }
}

const int IN1 = 10;
const int IN2 = 16;
const int IN3 = 14;
const int IN4 = 15;

const int SWITCH = 18;

static const CheapStepper cs = CheapStepper(IN1,IN2,IN3,IN4);


ISR(TIMER1_COMPA_vect) {
    cs.move(true,1);
    
}



void TaskMotor(void *parameters) {
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);

  pinMode(SWITCH,INPUT);

  Serial.println("Motor initialized");
             
  for(;;) {
    for (int i = 0 ; i < 10;i++) {
   
    vTaskDelay(1);
    }
    Serial.println(analogRead(SWITCH));
  }


}

void loop() {
  
   // manage serial controller   


}
