import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.MouseInfo;
import java.awt.Point;

class ScControl implements Scene {
  CallScene szeneRufen = null;
  String name = "Control";
  Robot tasten = null;

  int startTime = -1;
  int phase = 0;

  ScControl (CallScene _szeneRufen) {
    szeneRufen = _szeneRufen;
    try {
      println("Init");
      tasten = new Robot();
    } 
    catch (Exception e) {
      println("Fehler beim setup der tastenkontrolle");
      exit();
    }
  }

  void display() {
    background(0);
    Point mousePos = MouseInfo.getPointerInfo().getLocation();
    tasten.mouseMove(mousePos.x+1, mousePos.y);
    if (phase == 0 && millis()-startTime > 1000) {
      tasten.keyRelease(KeyEvent.VK_D);
      tasten.keyPress(KeyEvent.VK_W);
      startTime = millis();
      phase = 1;
    }
    if (phase == 1 && millis()-startTime > 1000) {
      tasten.keyRelease(KeyEvent.VK_W);
      tasten.keyPress(KeyEvent.VK_A);
      startTime = millis();
      phase = 2;
    }
    if (phase == 2 && millis()-startTime > 1000) {
      tasten.keyRelease(KeyEvent.VK_A);
      tasten.keyPress(KeyEvent.VK_S);
      startTime = millis();
      phase = 3;
    }
    if (phase == 3 && millis()-startTime > 1000) {
      tasten.keyRelease(KeyEvent.VK_S);
      tasten.keyPress(KeyEvent.VK_D);
      startTime = millis();
      phase = 0;
    }
  }

  void activate() {
    startTime = -1;
    phase = 0;
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
    if (code == 'q' || code == 'x') {
      szeneRufen.setScene("Hauptmenu");
    }
  }

  void keyUp(char code) {
    if (code == 'q' || code == 'x') {
      szeneRufen.setScene("Hauptmenu");
    }
  }
}