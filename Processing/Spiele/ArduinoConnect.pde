import processing.serial.*;

class ArduinoConnect {
  PApplet parent = null;
  Serial arduino = null;
  int recvDaten[] = new int[262];
  int recvPos = 0;
  public boolean isConnected = false;
  HashMap<Integer, Integer> distance = new HashMap<Integer, Integer>();
  HashMap<Integer, Integer> poti = new HashMap<Integer, Integer>();
  HashMap<Integer, Boolean> btn = new HashMap<Integer, Boolean>();

  /*Sensor/aktortypen: 1: Abstand, 2: Poti, 3: Knopf, 4: Text-Display, 5: RGB-LED, 6: Spannungsmessgerät, 7: Servo
   Protokoll: 0x00 0xFF [Laenge(nur Daten)] [Sensortyp] [Sensornummer] [Daten] 0xFF 0x00
   */

  ArduinoConnect(PApplet _parent) {
    printArray(Serial.list());
    parent = _parent;
  }

  void begin(int nummer) {
    try {
      arduino = new Serial(parent, Serial.list()[nummer], 19200);
      isConnected = true;
    } 
    catch (Exception e) {
      println("Gewaehlter Serial-Port nicht verfügbar!");
      //exit();
    }
  }

  String getRaw() {
    try {
      return arduino.readString();
    } 
    catch (Exception e) {
      println("Kein Arduino verfuegbar");
      return null;
    }
  }

  boolean prevHead = false;

  void checkRecv() {
    /*262 Bytes in Puffer einlesen umd mit Puffer verfahren (pro byte):
     wenn pos=0: Daten durchgehen
     wenn 00 ff gedunden, in array schreiben, pos auf 2
     wenn pos>0: daten in array schreiben, pos++
     wenn ff 00 gefunden, in array schreiben, pos +2, parserecv, pos=0
     */
    /*if (recvPos == 0) {
     if (arduino.available() > 0) {
     recvPos = arduino.readBytes(recvDaten);
     if (recvDaten[0] == 0x00 && recvDaten[1] == 0xFF && recvDaten[recvPos-2] == 0xFF && recvDaten[recvPos-1] == 0x00) {
     analyseRecv();
     recvDaten = new byte[262];
     recvPos = 0;
     }
     }
     } else {
     if (recvDaten[0] == 0x00 && recvDaten[1] == 0xFF) {
     while (arduino.available() > 0) {
     recvDaten[recvPos] = (byte)arduino.read();
     recvPos++;
     if (recvDaten[recvPos-2] == 0xFF && recvDaten[recvPos-1] == 0x00) {
     analyseRecv();
     recvDaten = new byte[262];
     recvPos = 0;
     }
     }
     } else {
     byte lastByte = 2;
     byte aktByte = 2;
     boolean weiter = true;
     while (arduino.available() > 0 && weiter) {
     aktByte = (byte)arduino.read();
     if (lastByte == 0x00 && aktByte == 0xFF) {
     recvDaten[0] = 0x00;
     recvDaten[1] = (byte)0xFF;
     recvPos = 2;
     weiter = false;
     checkRecv();
     }
     lastByte = aktByte;
     }
     }
     }*/
    try {
      while (arduino.available() > 0) {
        //Serial.println("Data available");
        int gelesen = arduino.read();
        if (recvPos <= 0) {
          if (prevHead) {
            //print("Head: ");
            //Serial.println(gelesen);
          }
          if (prevHead && gelesen == 0xFF) {
            recvDaten[0] = 0x00;
            recvDaten[1] = 0xFF;
            //println("Received start head");
            recvPos = 2;
            prevHead = false;
          } else if (gelesen == 0x00) {
            //println("Received 00");
            prevHead = true;
          }
        } else {
          //Serial.println(gelesen);
          recvDaten[recvPos] = gelesen;
          recvPos++;
          if (prevHead && gelesen == 0x00) {
            //println("Received end header");
            analyseRecv();
            recvPos = 0;
            prevHead = false;
          } else if (gelesen == 0xFF) {
            //Serial.println("Received ff");
            prevHead = true;
          }
        }
      }
    } 
    catch (Exception e) {
      println("Kein Arduino verfuegbar");
    }
  }

  void analyseRecv() {
    int len = recvDaten[2];
    int sensor = recvDaten[3];
    int num = recvDaten[4];

    switch(sensor) {
    case 1: //Abstand
      //println("Abstand " + num + ": " + recvDaten[5]);
      distance.put(num, recvDaten[5]);
      break;
    case 2: //Poti
      //println("Poti " + num + ": " + recvDaten[5]);
      poti.put(num, recvDaten[5]);
      break;
    case 3: //Knopf
      if (num == 4 && recvDaten[5] != 0) {
        println("rechts");
      } else if (num == 20) {
        println("Reset: " + recvDaten[5]);
      }
      //println("Btn " + num + ": " + recvDaten[5]);
      if (recvDaten[5] == 0) {
        btn.put(num, false);
      } else {
        btn.put(num, true);
      }
      break;
      /*case 4: //Text-Display
       break;
       case 5: //RGB-LED
       break;
       case 6: //Spannungsmessgerät
       break;*/
    }
  }

  void sendData(byte sensor, byte num, byte[] data, byte dataLen) { 
    int arrayLen = 7+(dataLen&0xff);
    byte[] senden = new byte[arrayLen];
    senden[0] = 0x00;
    senden[1] = (byte)0xFF;
    senden[2] = dataLen;
    senden[3] = sensor;
    senden[4] = num;
    senden[arrayLen-2] = (byte)0xFF;
    senden[arrayLen-1] = (byte)0x00;
    for (int i = 5; i < arrayLen-2; i++) {
      senden[i] = data[i-5];
    }
    try {
      arduino.write(senden);
    } 
    catch (Exception e) {
      println("Kein Arduino verfuegbar");
    }
  }

  void sendDisplay(byte num, String text) {
    byte textLen = (byte)text.length();
    if (text.length() > 255) {
      textLen = (byte)255;
    }
    sendData((byte)4, num, text.getBytes(), textLen);
  }

  void sendRGB(byte num, byte r, byte g, byte b) {
    byte[] led = {r, g, b};
    sendData((byte)5, num, new String(led).getBytes(), (byte)3);
  }

  void sendVoltage(byte num, byte value) {
    byte[] led = {value};
    sendData((byte)6, num, new String(led).getBytes(), (byte)1);
  }

  void sendServo(byte num, byte value) {
    byte[] led = {value};
    sendData((byte)7, num, new String(led).getBytes(), (byte)1);
  }

  int getDistance(int num) { //in cm
    checkRecv();
    return distance.get(num);
  }

  int getPoti(int num) {
    checkRecv();
    try {
      return poti.get(num);
    } 
    catch (Exception e) {
      return 0;
    }
  }

  boolean getBtn(int num) {
    checkRecv();
    try {
      return btn.get(num);
    } 
    catch (Exception e) {
      return false;
    }
  }
}