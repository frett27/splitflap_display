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

| Sequence | Message              | Message Orientation | End of message        |
| -------- | -------------------- | ------------------- | --------------------- |
| 1        | INIT                 | [<-] MODULE         | TimeOut - OR SEQUENCE |
| 2        | IAM-[NoATTRIBUTED]   | [->] MODULE         |                       |
| 3        | IAM-[NoATTRIBUTED+1] | MODULE [->]         |                       |



## Display Command

| Sequence | Message           | Message Orientation | End of message |
| -------- | ----------------- | ------------------- | -------------- |
| 1        | DISPLAY-[MESSAGE] | [->] MODULE [->]    |                |
| 2        | ACKDISPLAY-[No]   | [<-] MODULE         |                |
|          |                   |                     |                |

## Stepper Command (Testing)

| Sequence | Message     | Message Orientation | End of message |
| -------- | ----------- | ------------------- | -------------- |
| 1        | MOVE-[step] | [->] MODULE         |                |

## HeartBeat

(From Master)



| Sequence | Message | Message Orientation | End of message |
| -------- | ------- | ------------------- | -------------- |
| 1        | HELLO   | [->] MODULE [->]    |                |
|          |         |                     |                |
|          |         |                     |                |



## Error Handling

In case states are not properly covered, some error messages can be sent.



| Sequence | Message         | Message Orientation | End of message |
| -------- | --------------- | ------------------- | -------------- |
| 1        | ERROR-[MESSAGE] | [<-] MODULE [<-]    |                |
|          |                 |                     |                |