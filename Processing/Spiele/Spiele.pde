//Diese Zeile Ändern um den richtigen Serial-Port zu wählen:
int serialPort = 1;

ArrayList<Scene> szenen = new ArrayList<Scene>(); 
Scene active = null;

boolean exitAfterList = false;

CallScene ruf = new CallScene() {
  @Override
    void setScene(String name) {
    for (Scene s : szenen) {
      if (s.getName() == name) {
        //println("Calling" + s.getName());
        s.activate();
        active = s;
      }
    }
  }
  void sendRGB(byte num, byte r, byte g, byte b) {
    verb.sendRGB(num, r, g, b);
  }
  void sendDispl(byte num, String text) {
    verb.sendDisplay((byte)1, text);
  }
  boolean getBtn(int num) {
    return verb.getBtn(num);
  }
  boolean arduinoConn() {
    return verb.isConnected;
  }
  int getPoti(int num) {
    return verb.getPoti(num);
  }
};

ArduinoConnect verb = null;

void setup() {
  size(1500, 1500);
  Scene menu = new ScMenu(ruf);
  menu.setName("Hauptmenu");
  Scene pong = new ScPong(ruf);
  pong.setName("Pong");
  Scene options = new ScOpt(ruf);
  options.setName("Optionen");
  szenen.add(menu);
  szenen.add(pong);
  szenen.add(options);
  Scene snake = new ScSnake(ruf);
  snake.setName("Snake");
  szenen.add(snake);
  Scene control = new ScControl(ruf);
  control.setName("Control");
  szenen.add(control);
  active = szenen.get(0);
  verb = new ArduinoConnect(this);
  if (exitAfterList) {
    exit();
  }
  verb.begin(serialPort);
}

String ausgabe = "";

void draw() {
  //checkReset();
  //println(active.getName());
  active.display();
  /*background(0);
  String text = "";
  text += verb.getPoti(1) + "-";
  text += verb.getBtn(1)+"\n"; 
  if (text != null) {
    ausgabe+=text;
    if (ausgabe.length() > 50) {
      ausgabe = ausgabe.substring(ausgabe.length()-49);
    }
  }
  textSize(25);
  fill(255, 255, 255);
  text(ausgabe, 100, 100);*/
  //println(verb.getPoti((byte)1));
  //verb.sendVoltage((byte)1,(byte)65);
}

void mouseClicked() {
  active.clicked();
  /*for (byte i = 0; i < 100; i++) {
   verb.sendRGB((byte)1, (byte)i,(byte)(255-i),(byte)(127-i));
   }*/
  //verb.sendDisplay((byte)1,"Punkte: 5");
}

void keyPressed() {
  active.keyDown(key);
}

void keyReleased() {
  active.keyUp(key);
}

void checkReset() {
  if (verb.getBtn(20)) {
    ruf.setScene("Hauptmenu");
  }
}