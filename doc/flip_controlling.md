# Flip controlling - Protocol

*Patrice Freydiere - 2019*



This document describe the flip display protocol. It implements a minimum protocol, with an integrated message control, using the length.



The module has two Serial Port : In and Out



Digits module elect the master at the top left of the chain, every digits modules are connected in a serial manner.



All Internal messages are sent using the following structure

"S" + [SIZE_3DIGITS] + [MSG] + [10]

if the message has 10 characters, it is escaped using the "\\" character. 

for synchronous messages, responder respond S**002**OK\n for acknowledgement , within 1s







## Initialization - Concensus

At init, the module wants to know if he is the latest one, to determine it's number in the stack.



Protocol to initialize the module

| Sequence | Message              | Message Orientation | Description                                                  | End of message        |
| -------- | -------------------- | ------------------- | ------------------------------------------------------------ | --------------------- |
| 1        | INIT                 | [<-] MODULE         | the module tell it is inited                                 | TimeOut - OR SEQUENCE |
| 2        | IAM-[NoATTRIBUTED]   | [->] MODULE         | the preceding module inform of its no.                       |                       |
| 3        | IAM-[NoATTRIBUTED+1] | MODULE [->]         | the module inform the following of his attributed no (address) |                       |



## Display Command

| Sequence | Message           | Message Orientation | Description                                                  | End of message                                               |
| -------- | ----------------- | ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1        | DISPLAY-[MESSAGE] | [->] MODULE [->]    | ask to display the message, the module take the [No] digit number. Each Digits are on 2 digits |                                                              |
| 2        | ACKDISPLAY-[No]   | [<-] MODULE         |                                                              |                                                              |
| 3        | DIGIT-[DIGITNO]   | [->] MODULE         | Ask to display the given digit                               | Display the digit  number (from 0-12). no ack for this operation |

## Stepper Command (Testing)

| Sequence | Message     | Message Orientation | Description | End of message |
| -------- | ----------- | ------------------- | ----------- | -------------- |
| 1        | MOVE-[step] | [->] MODULE         |             |                |

## HeartBeat

(From Master)



| Sequence | Message | Message Orientation | Description                           | End of message |
| -------- | ------- | ------------------- | ------------------------------------- | -------------- |
| 1        | HELLO   | [->] MODULE [->]    | Preceding module inform of its status |                |
|          |         |                     |                                       |                |
|          |         |                     |                                       |                |



## Error Handling

In case states are not properly covered, some error messages can be sent.



| Sequence | Message         | Message Orientation | Description        | End of message |
| -------- | --------------- | ------------------- | ------------------ | -------------- |
| 1        | ERROR-[MESSAGE] | [<-] MODULE [<-]    | inform of an error |                |
|          |                 |                     |                    |                |



## Debug Message

In debugging status, messages can be send, they are not handled by up and down



| Sequence | Message         | Message Orientation | Description        | End of message |
| -------- | --------------- | ------------------- | ------------------ | -------------- |
| 1        | DEBUG-[MESSAGE] | [->] MODULE [<-]    | debug message sent |                |
|          |                 |                     |                    |                |

