
#ifndef DIGITCOMMANDPARSER_h
#define DIGITCOMMANDPARSER_h


  // process message is a call back for handling messages
  typedef void (*ProcessMessage)(char *messageParsed);

  // call back tosignal the message has been aborted
  typedef void (*MessageCanceled)();

  // given function to read char from serial
  typedef int (*ReadChar)();

  typedef struct {
       #define COMMAND_SERIAL_BUFFER_SIZE 200
       char buffer[COMMAND_SERIAL_BUFFER_SIZE];
      
       int state; // 0 - Wait for start
                            // 1 - Start detected and reading length
                            // 2 - Content read
                            // 5 - Waiting for end of char
      
       int numberLengthToRead;    
       int bufferPos;
  } parser_t;

  typedef parser_t *parser_h;

  /**
   * init parser structure
   */
  extern parser_h init(parser_t *parser);

  /**
   * This function process input characters from readChar function and 
   * translate it into Commands, formatted as described in the reference
   */
  extern void handleSerialReceive(parser_h parser, ProcessMessage processCommand,
                                  ReadChar readChar,
                                  MessageCanceled commandCanceled);

#endif
                           
