class ScOpt implements Scene {
  String name = "";
  CallScene szeneRufen = null;
  ArrayList<UIObj> objekte = new ArrayList<UIObj>();
  UIInput eingabe = null;
  
  ScOpt(CallScene _szeneRufen) {
    UIToggleBtn btnActArduino = new UIToggleBtn(width/10, height/12, height/25, color(100, 100, 100), color(255, 255, 255), "Arduino einschalten", "Arduino ausschalten");
    btnActArduino.setEvent(new UIEvents() {
      @Override
      void click() {
        if (szeneRufen != null ) {
          //szeneRufen.setScene("Pong");
          println("Leer");
        }
      }
    });
    objekte.add(btnActArduino);
    UIButton btnBack = new UIButton(width/10, (height/12)*11, height/14, color(255, 255, 255), "Zurück");
    btnBack.setEvent(new UIEvents() {
      @Override
      void click() {
        if (szeneRufen != null ) {
          szeneRufen.setScene("Hauptmenu");
        }
      }
    });
    objekte.add(btnBack);
    eingabe = new UIInput(width/10, (height/12)*2,(width/10)*9 , height/14, color(255));
    szeneRufen = _szeneRufen;
  }
  
  void display() {
    background(0);
    for (UIObj obj : objekte) {
      obj.display();
    }
    eingabe.display();
  }
  
  void activate() {
  }
  
  void deactivate() {
    
  }
  
  void setCall(CallScene _szeneRufen) {
    szeneRufen = _szeneRufen;
  }
  
  void setName(String _name) {
    name = _name;
  }
  
  String getName() {
    return name;
  }
  
  void clicked() {
    for (UIObj obj : objekte) {
      obj.clicked();
    }
  }
  
  void keyDown(char code) {
    eingabe.keyDown(code);
  }
  
  void keyUp(char code) {
    
  }
}