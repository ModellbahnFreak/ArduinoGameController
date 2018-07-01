/*PC-Gamecontroller
 * Fabian Beck & Kevin Wiedemann, 2018
 * Programm um Sensordaten des Controllers zum PC zu schicken
 * und Ausgabedaten zu empfangen
 */

//Library sum Senden und Empfangen einbinden
#include "SendPC.h"
//Library für das LCD einbinden
#include <LiquidCrystal.h>

//Display Objekt Erstellen (angeschlossen an die Pins 12, 13, A1, 4, 3, 2)
LiquidCrystal lcd(12, 13, A1, 4, 3, 2);

//Variablen für den Abstandssensor
//Pinnummern
int trigger = 7;
int echo = 8;
//Berechnete Werte
long dauer = 0;
long entfernung = 0;

//Pinnummer Reset-Button
int reset = 9;

//Instanz der Library zur PC-Kommunikation erstellen
SendPC pc(324); //Parameter ist (bisher) nicht genutzt

void setup() {
  //Kommunikation starten
  pc.begin();

  //LCD auf eine Größe von je 16 Zeichen in 2 Zeilen setzen
  lcd.begin(16, 2);
  //LCD-Cursor nach oben Links
  lcd.setCursor(0, 0);
  //Begrüßung ausgeben
  lcd.print("Servus!");
  delay(2000);
  //Nach 2s Display löschen
  lcd.clear();
  
  //Alle Knöfpe als INPUT festlegen
  pinMode (A2, INPUT);
  pinMode (A3, INPUT);
  pinMode (A4, INPUT);
  pinMode (A5, INPUT);
  pinMode (reset,INPUT);

}

void loop() {
  //RGB-Werte abfragen und an der LED mit PWM ausgeben
  analogWrite (5, pc.getRGB(1)[0]);
  analogWrite (6, pc.getRGB(1)[1]);
  analogWrite (11, pc.getRGB(1)[2]);

  //Display-Text aktualisieren
  Display();

  //Poti-Wert an den PC-Senden
  ballgeschw();

  //Abstand berechnen und an den PC senden (außer Betrieb, wei noch zu große Verzögerung)
  //abstand();

  //Alle Button-Werte an den PC senden
  knopf();

  //10 ms warten, um der seriellen Schnittstelle Zeit zum Senden zu geben
  delay(10);

}

void Display() {
  /*lcd.setCursor(0, 1);
    lcd.print("Pong");
    delay(1000);
    lcd.setCursor(6, 1);
    lcd.print("Dong");
    delay(1000);
    lcd.setCursor(11, 1);
    lcd.print("Klong");
    delay(1000);*/
  //Display löschen, Cursor nach oben links
  lcd.clear();
  lcd.setCursor(0, 0);
  //"Spielstand" ausgeben
  lcd.print("Spielstand:");
  //Cursor in die 2. Zeil2
  lcd.setCursor(0, 1);
  /* lcd.print("Los geht es!");
    delay(2000);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Spielstand:");*/
  //Eingelesenen Text ausgeben
  lcd.print(pc.getDisplay(1));
}


void ballgeschw() {
  //Poti-Wert auslesen 
  int potiWert = analogRead(A0);
  //und von 10-bit nach 8-bit konvertieren
  potiWert = map(potiWert, 0, 1023, 0, 255);
  //Konvertierten Wert an den PC senden
  pc.sendPoti(1, potiWert);
}

void abstand() {
  /*Abstand messen:
   * Trigger für kurze Zeit auf HIGHT (davou u. dannach LOW)
   * Pulslänge des Pulses am Echo-Pin messen
   * Dauer durch 2 (Hin UND zurück) mal Schallgeschwindigkeit (in m/µs)
   */
  digitalWrite(trigger, LOW);
  delay(5);
  digitalWrite(trigger, HIGH);
  delay(10);
  digitalWrite(trigger, LOW);
  dauer = pulseIn(echo, HIGH);
  entfernung = (dauer / 2) * 0.0003432;/*0.03432*/
  //Serial.println(entfernung);
}

void knopf() {
  //Buttonwerte einlesen und an den PC senden
  pc.sendBtn(1, digitalRead(A2)); //Links
  pc.sendBtn(2, digitalRead(A3)); //Hoch
  pc.sendBtn(3, digitalRead(A4)); //Runter
  pc.sendBtn(4, digitalRead(A5)); //Rechts
  pc.sendBtn(20, digitalRead(reset));

}

