#include "Arduino.h"
#include "SendPC.h"

SendPC::SendPC(int sinnloseZahl) {

}

void SendPC::begin() {
  Serial.begin(19200);
  readPos = 0;
}

void SendPC::recvData() {
  /*wenn pos=0: Daten durchgehen
     wenn 00 ff gedunden, in array schreiben, pos auf 2
     wenn pos>0: daten in array schreiben, pos++
     wenn ff 00 gefunden, in array schreiben, pos +2, parserecv, pos=0
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

void SendPC::parseRecv() {
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
        voltage[(int)readData[4]] = readData[5];
      }
      break;
    case 7: //Servo
      if (readData[4] <= 4 && readData[4] > 0) {
        servo[readData[4]] = readData[5];
      }
      break;
  }
  //}
}

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

