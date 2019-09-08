# Flip controlling - Protocol

*Patrice Freydiere - 2019*

### Introduction

This document describe the flip display protocol. It implements a minimum protocol, with an integrated message control, using the length.



The module has two Serial Port for communication : In and Out. And one serial port for command.



Digits module elect the master at the top left of the chain, every digits modules are connected in a serial manner.



### Message protocol

To remain simple, easy to analyze and DEBUG, all messages are in text format.



All Internal messages are sent using the following envelope structure :

"S" + [SIZE_3DIGITS] + [MSG] + [10]

if the message has 10 characters, it is escaped using the "\\" character. 



## Chain control

At init, the module wants to know if he is the latest one, to determine it's number in the stack.



Protocol to initialize the module: send IAM-[] message, the message will be serially forwarded with an updated address. This permit the chain to allocate their addressID. 

By default the initialized id is -1 for each module



| Sequence | Message                                      | Message Orientation | Description                                                  | Note |
| -------- | -------------------------------------------- | ------------------- | ------------------------------------------------------------ | ---- |
| 2        | IAM-[NoATTRIBUTED]                           | [->] MODULE [->]    | Define the address for the module. The message is forwarded to the next one, with the next NoAttributed. |      |
| 4        | CMD-[NoAttributed]-[MessageLength]-[Command] | [->] MODULE         | This command permit to send a specific message to a digit module |      |
| 1        | DISPLAY-[MESSAGE]                            | [->] MODULE [->]    | Ask to display the message, the module take the [No] digit number. Each Digits are on 2 digits |      |
| 2        | ACKDISPLAY-[NoAttributed]                    | [<-] MODULE         | Acknowledge about the message                                |      |



## Module Display Command

| ID   | Message         | Message Orientation | Description                                                  | Note                                                         |
| ---- | --------------- | ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 3    | DIGIT-[DIGITNO] | [->] MODULE         | Ask to display the given digit                               | Display the digit  number (from 0-12). no ack for this operation |
| 4    | OFFSET          | [->] MODULE         | Define the homing offset to tune the position of the first flip |                                                              |



## Module Stepper Command (Testing)

| ID   | Message     | Message Orientation | Description                             | Note |
| ---- | ----------- | ------------------- | --------------------------------------- | ---- |
| 1    | MOVE-[step] | [->] MODULE         | move the digit module to the given step |      |



## Module HeartBeat

| ID   | Message | Message Orientation | Description                                                  | Note |
| ---- | ------- | ------------------- | ------------------------------------------------------------ | ---- |
| 1    | HELLO   | [->] MODULE [->]    | Preceding module inform of its status, following module responde HELLO Message also |      |



## Error Handling

In case states are not properly covered, some error messages can be sent.

| ID   | Message         | Message Orientation | Description        | Note |
| ---- | --------------- | ------------------- | ------------------ | ---- |
| 1    | ERROR-[MESSAGE] | [<-] MODULE [<-]    | inform of an error |      |



## Debug Message

In debugging status, messages can be send, they are not handled by up and down



| ID   | Message         | Message Orientation | Description        | Note |
| ---- | --------------- | ------------------- | ------------------ | ---- |
| 1    | DEBUG-[MESSAGE] | [->] MODULE [<-]    | debug message sent |      |



## Message examples



**Hello Message**

```
S005HELLO
```

Response on command Port:

```
Command from Front Executed :HELLO
front send message:S005HELLO
```



**Print a specific DIGIT**

```
S008DIGIT-02
```

Response on command port

```
Command from Front Executed :DIGIT-02
```



**Move stepper to a specific step**

```
S008MOVE-003
```

Response:

```
Command from Front Executed :MOVE-500
```



**Define the offset of the stepper initial offset**

```
S011OFFSET-0500
```

response:

```

Command from Front Executed :OFFSET-0500

```



## Chain Command Examples

to initiate the hole chain, you have to call the IAM function that define the addresses of all connected modules



**Define the chain addresses of modules**

```
S005IAM-0
```

```
Command from Front Executed :IAM-0
back send message:S005IAM-1
```



**Send a specific command to a module in the chain**

```
S016CMD-001-DIGIT-08
```

```
Command from Front Executed :CMD-001-DIGIT-08
Command from Front Executed :DIGIT-08
1750 / 4096
```



**Send a hole display message to the chain**

```
S013DISPLAY-06234
```

Response

```
command from Front Executed :DISPLAY-06234
front send message:S012ACKDISPLAY-1
```

