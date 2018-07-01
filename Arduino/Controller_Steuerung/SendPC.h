/* Arduino SendPC Library
 * Entwicklung Georg Reißner, 2018
 * HINWEIS: BITTE BEI NUTZUNG DER LIBRARY DEN
 * SERIELLEN PORT DES ARDUINO NICHT NUTZEN!
 * Sendet und Empfängt Daten für verschiedene
 * Sensoren und Aktoren von/zum PC, wo eine ähnliche
 * Library die Daten entgegennimmt
 * Die Lirary enthält einen Puffer für die Daten
 * NUR ZUR PRIVATEN VERWENDUNG
 */
#ifndef SendPC_h
#define SendPC_h
#include "Arduino.h"

class SendPC {
  //Öffentliche Funktionen:
  public:
    //Initialisiert die Library (MAXIMAL EINE INSTANZ GLEICHZEITIG); portNum aktuell wirkungslos
    SendPC(int portNum);
    //Startet die serielle Schnittstelle und öffnet die Verbindung
    void begin();
    //Wert eines Abstandssensors senden (Wert zw. 0 und 255 in cm)
    void sendDistance(byte num, byte value);
    //Wert eines Potis senden
    void sendPoti(byte num, byte value);
    //Senden, ob Button Nummer [num] an (true) oder aus (false)
    void sendBtn(byte num, boolean value);
    //Werte der RGB-LED aus dem Puffer auslesen (num (aktuell) egall)
    byte* getRGB(byte num);
    //Text z.B. für ein LCD abfagen
    String getDisplay(byte num);
    //Spannungswert abfragen (num zw. 1 und 4 inkl.)
    byte getVoltage(byte num);
    //Servo-Stellung abfragen (num zw. 1 und 3 inkl.)
    byte getServo(byte num);

  //Nicht-öffentliche Funktionen/Variablen
  private:
    //Puffer:
    //RGB-Wert-Array
    byte rgb[3];
    //Display-Text
    String display;
    //Spannungswerte (Array)
    byte* voltage = new byte[4];
    //Servo-Werte (Array)
    byte* servo = new byte[3];

    //Variablen für das einlesen der seriellen Daten
    byte readData[262];
    int readPos = 0;
    boolean prevHead = false;

    //Hilfsfunktion zum Senden der Daten
    void sendData(byte sensor, byte num, byte* data, byte dataLen);

    //Hilfsfunktionen zum Empfangen der Daten
    void recvData();
    void parseRecv();
};

#endif
