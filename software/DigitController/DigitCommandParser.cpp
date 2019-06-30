
#include "DigitCommandParser.h"
#include <stdlib.h>


/**
 * init parser structure
 */
  parser_h init(parser_t *parser) {
      
    parser->state = 0;
    parser->numberLengthToRead = 0;
  
    // registering commands
  
    parser->bufferPos = 0;
  
    return parser;
    
  }

/**
 * function for handling parser, called periodically to handle characters 
 * and transform them into commands
 */
  int handleSerialReceive(parser_t *parser, ProcessMessage processCommand,
                           ReadChar readChar,
                           MessageCanceled commandCanceled) {

        // read the incoming byte:
        int incomingByte = (*readChar)();
        
        if (incomingByte < 0) {
          return 0;
        }

        int retvalue = 1;
        
        switch (parser->state) {
          
          case 0:
             if (incomingByte == 'S')
             {
               parser->state = 1;
               // Serial.println("move to 1");
               parser->numberLengthToRead = 3;
             }
             // reset buffer
             parser->bufferPos = 0;
             break;
          case 1:
          
              // overflow
              if (parser->bufferPos >= COMMAND_SERIAL_BUFFER_SIZE || incomingByte == '\n') {
                parser->bufferPos = 0;
                parser->state = 0;
                return retvalue;
              }
      
              parser->buffer[parser->bufferPos++] = (char)incomingByte;
              parser->numberLengthToRead--;
              if (parser->numberLengthToRead <= 0) {
                  parser->buffer[parser->bufferPos++] = 0;
                  parser->numberLengthToRead = atoi(parser->buffer);
                 
                  if (parser->numberLengthToRead <=0) {
                    commandCanceled();
                    // end of reading
                    parser->state = 0;
                    // Serial.println("move to 0");
                 
                    parser->bufferPos = 0;
                    return retvalue;
                  }
                  // Serial.println("move to 2");
                  parser->state = 2;
                  parser->bufferPos = 0;
              }
              
            break;
          case 2:
               // READ Content
               if ( (char)incomingByte == '\n') {
                  // reset
                  parser->state = 0;
                  parser->bufferPos = 0;
                  commandCanceled();
                  return retvalue;
               }
               
              parser->buffer[parser->bufferPos++] = (char)incomingByte;
              parser->numberLengthToRead --;
              if (parser->numberLengthToRead <= 0) {
                // Serial.println("move to 5");
                // end of line
                parser->buffer[parser->bufferPos++] = 0;
                parser->state = 5;
              }
              break;
           case 5:
             if ( (char)incomingByte != '\n' ) {
               commandCanceled();
             } else {
               // process command
               processCommand(parser->buffer);
               
             }
             parser->state = 0;
             parser->bufferPos = 0;   
             break;          
        } // switch

        return retvalue;

}
