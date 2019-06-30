#include <SoftwareSerial.h>



//  ces pins ne fonctionnent pas (pas d'interruption associée)
// SoftwareSerial ds(3, 2); // RX, TX

 SoftwareSerial ds(8, 9); // RX, TX


// Serial 1 pour l'incoming
//SoftwareSerial downSerial(0, 1); // RX, TX

 static char t;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115000);
  
  ds.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
 Serial.print("A");
 delay(3000);
ds.println("H");
 
    Serial.write(ds.read());
  


}
