class UIText implements UIObj {
  /*float x = 0;
   float y;
   int opacity;*/
  float x;
  float y;
  int opacity;
  float h = 0;
  int farbe;
  String text;
  UIEvents event = null;
  int textPosV = TOP;
  int textPosH = LEFT;

  UIText(float _x, float _y, float _h, int _farbe, String _text) {
    x=_x;
    y=_y;
    h=_h;
    farbe = _farbe;
    text = _text;
  }

  void setEvent(UIEvents _event) {
    event = _event;
  }

  void display() {
    noStroke();
    fill(farbe);
    textAlign(textPosH, textPosV);
    textSize(h);
    text(text, x, y);
  }
  
  void setTextMode(int posH, int posV) {
    textPosV = posV;
    textPosH = posH;
  }

  void setText(String _text) {
    text = _text;
  }

  void clicked() {
    /*if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      if (event != null) {
        event.click();
      }
    }*/
  }

  void setX(float _x) {
    x = _x;
  }
  void setY(float _y) {
    y = _y;
  }
  
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  float getWidth() {
    textSize(h);
    return textWidth(text);
  }
  float getHeight() {
    return h;
  }
}