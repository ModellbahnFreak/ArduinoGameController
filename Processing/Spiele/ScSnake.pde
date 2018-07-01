import java.util.Set;
import java.util.TreeSet;

class ScSnake implements Scene {
  ArrayList<int[]> snakePos = new ArrayList<int[]>();
  ArrayList<int[]> essenPos = new ArrayList<int[]>();
  int spalten = 30;
  int zeilen = 30;
  float colWidth = (width/spalten);
  float rowHeight = (height/zeilen);
  CallScene szeneRufen = null;
  String name = "Snake";
  int lastMove = -1;
  int moveTime = 250;
  int direction = 1; //0: stehen, 1: hoch, 2:runter, 3: links, 4: rechts
  int snakeLen = 1;
  int punkte = 0;
  boolean gameOver = false;

  ScSnake(CallScene _szeneRufen) {
    szeneRufen = _szeneRufen;
  }

  void display() {
    if (szeneRufen.arduinoConn()) {
      checkBtns();
    }
    if (!gameOver && millis() - lastMove > moveTime) {
      int[] posKopf = snakePos.get(snakePos.size()-1);
      switch (direction) {
      case 1:
        snakePos.add(new int[]{posKopf[0], posKopf[1]-1});
        break;
      case 2:
        snakePos.add(new int[]{posKopf[0], posKopf[1]+1});
        break;
      case 3:
        snakePos.add(new int[]{posKopf[0]-1, posKopf[1]});
        break;
      case 4:
        snakePos.add(new int[]{posKopf[0]+1, posKopf[1]});
        break;
      }
      while (snakePos.size() > snakeLen) {
        snakePos.remove(0);
      }
      //ArrayList<int[]> doppelt = new ArrayList<int[]>();
      //Set<int[]> sortiert = new TreeSet<int[]>(new PosComparator());
      PosComparator vergl = new PosComparator();
      int snakeSize = snakePos.size();
      int[] kopf = snakePos.get(snakeSize-1);

      background(0);
      noStroke();
      for (int i = 0; i < snakeSize; i++) {
        int[] pos = snakePos.get(i);
        /*if (!sortiert.add(pos)) {
         gameOver = true;
         }*/
        if (i != snakeSize-1 && vergl.compare(kopf, pos) == 0) {
          gameOver = true;
        }
        if (pos[0] < 0 || pos[0] >= spalten || pos[1] < 0 || pos[1] >= zeilen) {
          gameOver = true;
        }
        if (i != snakeSize-1) {
          fill(255, 255, 0);
          rect(pos[0]*colWidth, pos[1]*rowHeight, colWidth, rowHeight);
        }
      }

      int essenSize = essenPos.size();
      for (int i = 0; i < essenSize; i++) {
        int[] pos = essenPos.get(i);
        fill(122, 0, 255); 
        rect(pos[0]*colWidth, pos[1]*rowHeight, colWidth, rowHeight);
        if (vergl.compare(kopf, pos) == 0) {
          //Punkt gemacht
          punkte++;
          snakeLen++;
          moveTime--;
          essenPos.remove(i);
          i--;
          essenSize = essenPos.size();
          essenPos.add(new int[]{(int)random(0, spalten-1), (int)random(0, zeilen-1)});
          if (punkte%5 == 0) {
            essenPos.add(new int[]{(int)random(0, spalten-1), (int)random(0, zeilen-1)});
          }
          szeneRufen.sendDispl((byte)1,"Pt.: " + punkte + "  Ziele: " + essenPos.size());
        }
      }

      fill(75, 255, 0);
      rect(kopf[0]*colWidth, kopf[1]*rowHeight, colWidth, rowHeight);

      fill(255);
      textSize(50);
      textAlign(LEFT, TOP);
      text("Punkte: " + punkte, colWidth, rowHeight);

      if (gameOver) {
        textAlign(RIGHT, TOP);
        text("Zurück durch klicken", width-colWidth, rowHeight*3);
        fill(255, 0, 0);
        text("GAME OVER!", width-colWidth, rowHeight);
      }

      lastMove = millis();
    } else if (gameOver) {
      szeneRufen.sendDispl((byte)1,"GAME OVER");
      fill(255);
      textAlign(RIGHT, TOP);
      text("Zurück durch klicken", width-colWidth, rowHeight*3);
      fill(255, 0, 0);
      text("GAME OVER!", width-colWidth, rowHeight);
    }
    /*rect(pos[0]*colWidth, pos[1]*rowHeight, colWidth, rowHeight);*/
  }

  void activate() {
    gameOver = false;
    punkte = 0;
    snakeLen = 1;
    moveTime = 250;
    snakePos.clear();
    snakePos.add(new int[]{spalten/2, zeilen/2});
    essenPos.clear();
    essenPos.add(new int[]{(int)random(0, spalten-1), (int)random(0, zeilen-1)});
    szeneRufen.sendDispl((byte)1,"Pt.: " + punkte + "  Ziele: " + essenPos.size());
    lastMove = millis();
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
    switch(code) {
    case 'w':
      if (direction == 2) {
        gameOver = true;
      }
      direction = 1;
      break;
    case 's':
      if (direction == 1) {
        gameOver = true;
      }
      direction = 2;
      break;
    case 'a':
      if (direction == 4) {
        gameOver = true;
      }
      direction = 3;
      break;
    case 'd':
      if (direction == 3) {
        gameOver = true;
      }
      direction = 4;
      break;
    }
  }

  void keyUp(char code) {
  }
  
  void checkBtns() { //1: Li, 2: Hoch, 3: Runter, 4: Re
    if (szeneRufen.getBtn(2)) {
      //println("Hoch");
      if (direction == 2) {
        gameOver = true;
      }
      direction = 1;
    } else if (szeneRufen.getBtn(3)) {
      //println("Runter");
      if (direction == 1) {
        gameOver = true;
      }
      direction = 2;
    }
    if (szeneRufen.getBtn(1)) {
      //println("Links");
      if (direction == 4) {
        gameOver = true;
      }
      direction = 3;
    } else if (szeneRufen.getBtn(4)) {
      //println("Rechts");
      if (direction == 3) {
        gameOver = true;
      }
      direction = 4;
    }
  }
}