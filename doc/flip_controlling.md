# Flip controlling - Protocol

*Patrice Freydiere - 2019*

### Introduction

This document describe the flip display protocol. It implements a minimum protocol, with an integrated message control, using the length.



The module has two Serial Port : In and Out



Digits module elect the master at the top left of the chain, every digits modules are connected in a serial manner.



### Message protocol

All Internal messages are sent using the following structure

"S" + [SIZE_3DIGITS] + [MSG] + [10]

if the message has 10 characters, it is escaped using the "\\" character. 

for synchronous messages, responder respond S**002**OK\n for acknowledgement , within 1s



## Initialization - Concensus

At init, the module wants to know if he is the latest one, to determine it's number in the stack.



Protocol to initialize the module

| Sequence | Message                                      | Message Orientation | Description                                                  | Note                |
| -------- | -------------------------------------------- | ------------------- | ------------------------------------------------------------ | ------------------- |
| 2        | IAM-[NoATTRIBUTED]                           | [->] MODULE [->]    | Define the address for the module. The message is forwarded to the next one, with the next NoAttributed. |                     |
| 4        | CMD-[NoAttributed]-[MessageLength]-[Command] | [->] MODULE         | This command permit to send a specific message to a digit module | NOT IMPLEMENTED YET |



## Display Command

| Sequence | Message                   | Message Orientation | Description                                                  | Note                                                         |
| -------- | ------------------------- | ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1        | DISPLAY-[MESSAGE]         | [->] MODULE [->]    | Ask to display the message, the module take the [No] digit number. Each Digits are on 2 digits |                                                              |
| 2        | ACKDISPLAY-[NoAttributed] | [<-] MODULE         | Acknowledge about the message                                |                                                              |
| 3        | DIGIT-[DIGITNO]           | [->] MODULE         | Ask to display the given digit                               | Display the digit  number (from 0-12). no ack for this operation |

## Stepper Command (Testing)

| Sequence | Message     | Message Orientation | Description                             | Note |
| -------- | ----------- | ------------------- | --------------------------------------- | ---- |
| 1        | MOVE-[step] | [->] MODULE         | move the digit module to the given step |      |

## HeartBeat

(From Master)



| Sequence | Message | Message Orientation | Description                           | Note |
| -------- | ------- | ------------------- | ------------------------------------- | ---- |
| 1        | HELLO   | [->] MODULE [->]    | Preceding module inform of its status |      |
|          |         |                     |                                       |      |
|          |         |                     |                                       |      |





## Error Handling

In case states are not properly covered, some error messages can be sent.



| Sequence | Message         | Message Orientation | Description        | Note |
| -------- | --------------- | ------------------- | ------------------ | ---- |
| 1        | ERROR-[MESSAGE] | [<-] MODULE [<-]    | inform of an error |      |
|          |                 |                     |                    |      |



## Debug Message

In debugging status, messages can be send, they are not handled by up and down



| Sequence | Message         | Message Orientation | Description        | Note |
| -------- | --------------- | ------------------- | ------------------ | ---- |
| 1        | DEBUG-[MESSAGE] | [->] MODULE [<-]    | debug message sent |      |
|          |                 |                     |                    |      |

