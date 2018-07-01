/* Arduino SendPC Library
 * Entwicklung Georg Reißner, 2018
 * HINWEIS: BITTE BEI NUTZUNG DER LIBRARY DEN
 * SERIELLEN PORT DES ARDUINO NICHT NUTZEN!
 * Beschreibung zu Funktionen im Header-File (SendPC.h)
 * Sendet und Empfängt Daten für verschiedene
 * Sensoren und Aktoren von/zum PC, wo eine ähnliche
 * Library die Daten entgegennimmt
 * Die Lirary enthält einen Puffer für die Daten
 * NUR ZUR PRIVATEN VERWENDUNG
 */

#include "Arduino.h"
#include "SendPC.h"

//Konstruktor
SendPC::SendPC(int portNum) {}

//Init-Methode
void SendPC::begin() {
  Serial.begin(19200);
  readPos = 0;
}

//Hilfsmethode zum Empfnangen
void SendPC::recvData() {
  /* Funktiosweise Empfagen:
   *  Wenn mehr als 500 Bytes im Puffer,
   *    Solange Bytes lesen, bis Puffergröße < 500 (Overload-Schutz)
   *  Wenn readPos <= 0:
   *    Prüfen, ob Header "0x00 0xFF" empfangen, wenn ja:
   *      Header ins readData-Array und readPos auf 2
   *    Sonst:
   *      Nächstes Byte lesen
   *  Wenn readPos > 0:
   *    Aktuelles Byte ins readData-Array und readPos+1
   *    Wenn End-Head gefunden:
   *      Empfangene Daten Parsen
   *      readPos = 0
   */
  while (Serial.available() > 0) {
    while (Serial.available() > 500) {
      Serial.read();
    }
    //Serial.println("Data available");
    byte gelesen = Serial.read();
    if (readPos <= 0) {
      if (prevHead) {
        //Serial.print("Head: ");
        //Serial.println(gelesen);
      }
      if (prevHead && gelesen == 0xFF) {
        readData[0] = 0x00;
        readData[1] = 0xFF;
        //Serial.println("Received start head");
        readPos = 2;
        prevHead = false;
      } else if (gelesen == 0x00) {
        //Serial.println("Received 00");
        prevHead = true;
      }
    } else {
      //Serial.println(gelesen);
      readData[readPos] = gelesen;
      readPos++;
      if (prevHead && gelesen == 0x00) {
        //Serial.println("Received end header");
        parseRecv();
        readPos = 0;
        prevHead = false;
      } else if (gelesen == 0xFF) {
        //Serial.println("Received ff");
        prevHead = true;
      }
    }
  }
}

//Analysiert und speichert die Empfangenen Daten
void SendPC::parseRecv() {
  /*Funktionsweise Parsen
   * Prüfen, welcher Sensor/Aktor Daten
   * Display:
   *   Daten nach empfangener Länge durchgehen und zum String hinzufügen
   * RGB:
   *   Alle 3 Empfangenen Bytes ins RGB-Array schreiben
   * Spannung:
   *   Wenn Nummer der Spannung zw. 1 und 4:
   *     Spannung an die Stelle ins Array
   * Servo:
   *   Wenn Nummer zw. 1 und 3:
   *     Wert ins Array
   */
  //if (readData[0] == 0x00 && readData[1] == 0xFF) {
  //Serial.println("Parse lauched");
  switch (readData[3]) {
    case 4://Display
      if (readData[2] >= 1) {
        display = "";
        for (int i = 5; i < readPos - 2; i++) {
          display += char(readData[i]);
        }
        //Serial.println("Text: " + display);
        //display.substring(5, 5+readData[2]-1);
      }
      break;
    case 5: //RGB
      rgb[0] = readData[5];
      rgb[1] = readData[6];
      rgb[2] = readData[7];
      //Serial.println("RGB");
      break;
    case 6: //Voltage
      //Serial.println("Received voltage");
      if (readData[4] <= 4 && readData[4] > 0) {
        voltage[(int)readData[4]-1] = readData[5];
      }
      break;
    case 7: //Servo
      if (readData[4] <= 4 && readData[4] > 0) {
        servo[readData[4]-1] = readData[5];
      }
      break;
  }
  //}
}

//Hilfsfunktion zum Senden der Daten (setzt Nachricht zusammen)
void SendPC::sendData(byte sensor, byte num, byte* data, byte dataLen) {
  Serial.write(0x00);
  Serial.write(0xFF);
  Serial.write(dataLen);
  /*Serial.write(1);
  Serial.write(2);
  Serial.write(2);
  Serial.write(12);*/
  Serial.write(sensor);
  Serial.write(num);
  Serial.write(data, dataLen);
  Serial.write(0xFF);
  Serial.write(0x00);
  recvData();
}

void SendPC::sendDistance(byte num, byte value) {//in cm
  byte* daten = {value};
  sendData(1, num, daten, 1);
}

void SendPC::sendPoti(byte num, byte value) {
  byte* daten = {value};
  sendData(2, num, daten, 1);
}

void SendPC::sendBtn(byte num, boolean value) {
  byte* daten = new byte[1];
  if (value) {
    daten[0] = 1;
  } else {
    daten[0] = 0;
  }
  sendData(3, num, daten, 1);
}

byte* SendPC::getRGB(byte num) {
  recvData();
  return rgb;
}
String SendPC::getDisplay(byte num) {
  recvData();
  if (num == 1) {
    return display;
  } else {
    return "";
  }
}

byte SendPC::getVoltage(byte num) {
  recvData();
  if (num > 0 && num <= 4) {
    return voltage[(int)(num)-1];
  } else {
    return 0;
  }
}

byte SendPC::getServo(byte num) {
  recvData();
  if (num > 0 && num <= 3) {
    return servo[(int)(num)-1];
  } else {
    return 0;
  }
}

