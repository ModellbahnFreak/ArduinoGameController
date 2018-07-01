interface CallScene {
  void setScene(String name);
  void sendRGB(byte num, byte r, byte g, byte b);
  void sendDispl(byte num, String text);
  boolean getBtn(int num);
  int getPoti(int num);
  boolean arduinoConn();
}