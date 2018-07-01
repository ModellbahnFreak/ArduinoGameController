class ScMenu implements Scene {
  ArrayList<UIObj> objekte = new ArrayList<UIObj>();
  CallScene szeneRufen = null;
  String name;

  ScMenu(CallScene _szeneRufen) {
    UIButton btnPong = new UIButton(width/10, height/12, height/14, color(255, 255, 255), "Pong");
    UIButton btnOpt = new UIButton(width/10, (height/12)*11, height/14, color(255, 255, 255), "Optionen");
    UIButton btnSnake = new UIButton(width/10, (height/12)*2, height/14, color(255, 255, 255), "Snake");
    UIButton btnContol = new UIButton(width/10, (height/12)*3, height/14, color(255, 255, 255), "Steuern");
    btnPong.setEvent(new UIEvents() {
      @Override
        void click() {
        if (szeneRufen != null ) {
          szeneRufen.setScene("Pong");
        }
      }
    }
    );
    btnOpt.setEvent(new UIEvents() {
      @Override
        void click() {
        if (szeneRufen != null ) {
          szeneRufen.setScene("Optionen");
        }
      }
    }
    );
    btnSnake.setEvent(new UIEvents() {
      @Override
        void click() {
        if (szeneRufen != null ) {
          szeneRufen.setScene("Snake");
        }
      }
    }
    );
    btnContol.setEvent(new UIEvents() {
      @Override
        void click() {
        if (szeneRufen != null ) {
          szeneRufen.setScene("Control");
        }
      }
    }
    );
    objekte.add(btnPong);
    objekte.add(btnOpt);
    objekte.add(btnSnake);
    objekte.add(btnContol);
    szeneRufen = _szeneRufen;
  }

  void display() {
    background(0);
    for (UIObj obj : objekte) {
      obj.display();
    }
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
  }
  void keyUp(char code) {
  }
}