class ScPong implements Scene {
  //ArrayList<UIObj> objekte = new ArrayList<UIObj>();
  UIRect paddleLi = null;
  boolean LiPressed[] = {false, false};
  UIRect paddleRe = null;
  boolean RePressed[] = {false, false};
  UIRect ball = null;
  float impuls[] = {0, 0}; //x, y
  CallScene szeneRufen = null;
  String name;
  int Punkte[] = {0, 0};
  UIText txtPoints = null;
  UIEvents backHaupt = new UIEvents() {
    @Override
      void click() {
      if (szeneRufen != null ) {
        szeneRufen.setScene("Pong");
      }
    }
  };

  ScPong(CallScene _szeneRufen) {
    paddleLi = new UIRect(width/20-width/40, 0, width/40, height/6, color(255, 0, 0));
    paddleRe = new UIRect((width/20)*19, 0, width/40, height/6, color(0, 0, 255));
    //objekte.add(paddleLi);
    //objekte.add(paddleRe);
    ball = new UIRect(width/2, width/2, width/40, width/40, color(255));
    ball.setCenterMode(true);
    txtPoints = new UIText(width/2, height/40, height/30, color(255), "0:0");
    txtPoints.setTextMode(CENTER, TOP);
    //objekte.add(ball);
    szeneRufen = _szeneRufen;
  }

  void display() {
    checkPoti();
    background(0);
    movePaddleLi();
    movePaddleRe();
    paddleLi.display();
    paddleRe.display();
    moveBall();
    ball.display();
    setPoints();
    txtPoints.display();
  }

  void activate() {
    impuls[0] = random(-10.0, 10.0);
    Punkte[0] = 0;
    Punkte[1] = 0;
    resetBall();
    print("Impuls: ");
    impuls[1] = random(-10.0, 10.0);
    println(impuls[0] + "; " + impuls[1]);
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
    szeneRufen.setScene("Hauptmenu");
  }
  void keyDown(char code) {
    //println("Down: " + code);
    if (code == 'w') {
      //LeftUp
      LiPressed[0] = true;
    } else if (code == 's') {
      //LeftDown
      LiPressed[1] = true;
    } else if (code == 'o') {
      //RightUp
      RePressed[0] = true;
    } else if (code == 'l') {
      //RightDown
      RePressed[1] = true;
    }
  }
  void keyUp(char code) {
    if (code == 'w') {
      //LeftUp
      LiPressed[0] = false;
    } else if (code == 's') {
      //LeftDown
      LiPressed[1] = false;
    } else if (code == 'o') {
      //RightUp
      RePressed[0] = false;
    } else if (code == 'l') {
      //RightDown
      RePressed[1] = false;
    }
  }

  void moveBall() {
    int inPaddle = ballInPaddle();
    if (inPaddle == 1) {
      println("li");
    } else if (inPaddle == 2) {
      println("re");
    }
    float ballX = ball.getX();
    float ballY = ball.getY();
    if (inPaddle == 1 || inPaddle == 2) {
      impuls[0] = impuls[0]*(-1);
    }
    if (ballY < 0 || ballY > height) {
      impuls[1] = impuls[1]*(-1);
    }
    if (ballX < 0) {
      impuls[0] = impuls[0]*(-1);
      Punkte[0]++;
      resetBall();
    } else if (ballX > width) {
      impuls[0] = impuls[0]*(-1);
      Punkte[1]++;
      resetBall();
    } else {
      ball.setX(ballX+impuls[0]);
      ball.setY(ballY+impuls[1]);
    }
    //szeneRufen.sendRGB((byte)1,(byte)((ballX/width)*255),(byte)((ballY/height)*255), (byte)0);
  }

  final char paddleSpeed = 4;

  void movePaddleLi() {
    float paddleY = paddleLi.getY();
    if (szeneRufen.arduinoConn()) {
      paddleY = (szeneRufen.getPoti(1)/255.0)*(height-paddleLi.getHeight());
    } else {
      if (LiPressed[0] && paddleY >= 0) {
        paddleLi.setY(paddleY-paddleSpeed);
      }
      if (LiPressed[1] && paddleY+paddleLi.getHeight() <= height) {
        paddleLi.setY(paddleY+paddleSpeed);
      }
    }
  }

  void movePaddleRe() {
    float paddleY = paddleRe.getY();
    if (RePressed[0] && paddleY >= 0) {
      paddleRe.setY(paddleY-paddleSpeed);
    }
    if (RePressed[1] && paddleY+paddleRe.getHeight() <= height) {
      paddleRe.setY(paddleY+paddleSpeed);
    }
  }

  int ballInPaddle() { //0: nein, 1: nur li; 2: nur re, 3: beide
    float ballX = ball.getX();
    float ballY = ball.getY();
    float ballW = ball.getWidth();
    float ballH = ball.getHeight();
    float LiX = paddleLi.getX();
    float LiY = paddleLi.getY();
    float LiH = paddleLi.getHeight();
    float LiW = paddleLi.getWidth();
    float ReX = paddleRe.getX();
    float ReY = paddleRe.getY();
    float ReH = paddleRe.getHeight();
    float ReW = paddleRe.getWidth();
    int erg = 0;
    if (ballX+ballW*0.5 > LiX && ballX-ballW*0.5 < LiX+LiW && ballY+ballH*0.5 > LiY && ballY-ballH*0.5 < LiY+LiH) {
      erg = 1;
    }
    if (ballX+ballW*0.5 > ReX && ballX-ballW*0.5 < ReX+ReW && ballY+ballH*0.5 > ReY && ballY-ballH*0.5 < ReY+ReH) {
      if (erg == 1) {
        erg = 3;
      } else {
        erg = 2;
      }
    }
    return erg;
  }

  void setPoints() {
    txtPoints.setText(Punkte[1] + ":" + Punkte[0]);
  }

  void resetBall() {
    ball.setX(width/2);
    ball.setY(height/2);
    szeneRufen.sendDispl((byte)1, "Blau: " + Punkte[0] + "  Rot: " + Punkte[1]);
    //println("Reset");
  }

  void checkPoti() {
  }
}