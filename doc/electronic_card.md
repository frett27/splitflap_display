# Electronic Card



slot for connecting to an other digit module



leonardo - uno : can be powered on 12v

the first module is powered with 12v



### Connector



slot from the input side

<-  on the input side

- GND
- VCC
- RESET
- RX
- TX
- pull up connection



on the other side / symetric

- GND
- VCC
- RESET
- TX
- RX
- Connected



### The logic :

at reset we send a transmission to count the number of digits, when done

this read the motor situation (in eeprom)



a protocol in place send the number to display. 



leonardo does not have multiple uart, the SoftwareSerial it used for this purpose.

