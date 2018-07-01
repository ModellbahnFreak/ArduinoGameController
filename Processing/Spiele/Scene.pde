interface Scene {
  void display();
  void activate();
  void deactivate();
  void setCall(CallScene szeneRufen);
  void setName(String _name);
  String getName();
  void clicked();
  void keyDown(char code);
  void keyUp(char code);
}