#include <SendPC.h>
#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 13, A1, 4, 3, 2);

int trigger = 7;
int echo = 8;
long dauer = 0;
long entfernung = 0;
int reset = 9;


SendPC pc(324);

void setup() {
  pc.begin();
  lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.print("Servus!");
  delay(2000);
  lcd.clear();
  ///Serial.begin(4800);
  pinMode (A2, INPUT);
  pinMode (A3, INPUT);
  pinMode (A4, INPUT);
  pinMode (A5, INPUT);
  pinMode (reset,INPUT);

}

void loop() {
  analogWrite (5, pc.getRGB(1)[0]);
  analogWrite (6, pc.getRGB(1)[1]);
  analogWrite (11, pc.getRGB(1)[2]);
  Display();
  ballgeschw();
  //abstand();
  knopf();
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
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Spielstand:");
  lcd.setCursor(0, 1);
  /* lcd.print("Los geht es!");
    delay(2000);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Spielstand:");*/
  lcd.print(pc.getDisplay(1));
}


void ballgeschw() {
  pc.sendPoti(1, analogRead(A0));
}

void abstand() {
  digitalWrite(trigger, LOW);
  delay(5);
  digitalWrite(trigger, HIGH);
  delay(10);
  digitalWrite(trigger, LOW);
  dauer = pulseIn(echo, HIGH);
  entfernung = (dauer / 2) * 0.03432;
  //Serial.println(entfernung);
}

void knopf() {

  pc.sendBtn(1, digitalRead(A2));
  pc.sendBtn(2, digitalRead(A3));
  pc.sendBtn(3, digitalRead(A4));
  pc.sendBtn(4, digitalRead(A5));
  //pc.sendBtn(20, digitalRead(reset));

}

