class UIInput implements UIObj {
  float x;
  float y;
  int opacity;
  float w = 0;
  float h = 0;
  int farbe;
  int textColor;
  String text = "";
  UIEvents event = null;

  UIInput(float _x, float _y, float _w, float _h, int _farbe) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    farbe = _farbe;
    textColor = color(255-red(farbe), 255-green(farbe), 255-blue(farbe));
  }

  void display() {
    fill(farbe);
    rect(x, y, w, h);
    fill(textColor);
    textAlign(LEFT, TOP);
    textSize(h-6);
    text(text, x+3, y+3);
  }

  void setEvent(UIEvents event) {
  }

  void clicked() {
  }

  void keyDown(char code) {
    if (code == 8) {
      if (text.length() > 0) {
        text = text.substring(0, text.length()-1);
      }
    } else if (code >= 32 && code <= 126) {
      text += code;
    }
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
    return w;
  }

  float getHeight() {
    return h;
  }
}