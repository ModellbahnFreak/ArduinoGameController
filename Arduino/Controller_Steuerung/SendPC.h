#ifndef SendPC_h
#define SendPC_h
#include "Arduino.h"

class SendPC {
  public:
    SendPC(int sinnloseZahl);
    void begin();
    void sendDistance(byte num, byte value);//in cm
    void sendPoti(byte num, byte value);
    void sendBtn(byte num, boolean value);
    byte* getRGB(byte num);
    String getDisplay(byte num);
    byte getVoltage(byte num);
    byte getServo(byte num);
  private:
    byte rgb[3];
    String display;
    byte* voltage = new byte[4];
    byte* servo = new byte[3];
    
    byte readData[262];
    int readPos = 0;
    boolean prevHead = false;
    void sendData(byte sensor, byte num, byte* data, byte dataLen);
    void recvData();
    void parseRecv();
};

#endif
