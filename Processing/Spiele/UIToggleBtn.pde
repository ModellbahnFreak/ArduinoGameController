class UIToggleBtn implements UIObj {
  /*float x = 0;
   float y;
   int opacity;*/
  float x;
  float y;
  int opacity;
  float w = 0;
  float h = 0;
  int farbe;
  int textColor;
  int farbeGedr;
  String text;
  String textGedr;
  UIEvents event = null;
  boolean gedrueckt = false;

  UIToggleBtn(float _x, float _y, /*float _w,*/ float _h, int _farbe, int _farbeGedr, String _text, String _textGedr) {
    x=_x;
    y=_y;
    //w=_w;
    h=_h;
    farbe = _farbe;
    farbeGedr = _farbeGedr;
    text = _text;
    textGedr = _textGedr;
    textSize(h-6);
    float wNGedr = textWidth(text+6);
    float wGedr = textWidth(textGedr+6);
    if (wNGedr > wGedr) {
      w = wNGedr;
    } else {
      w = wGedr;
    }
    textColor = color(255-red(farbe), 255-green(farbe), 255-blue(farbe));
  }

  void setEvent(UIEvents _event) {
    event = _event;
  }

  void display() {
    noStroke();
    if (gedrueckt) {
      fill(farbe);
      rect(x, y, w, h);
      fill(textColor);
      textAlign(LEFT, TOP);
      textSize(h-6);
      text(text, x+3, y+3);
    } else {
      fill(farbeGedr);
      rect(x, y, w, h);
      fill(textColor);
      textAlign(LEFT, TOP);
      textSize(h-6);
      text(textGedr, x+3, y+3);
    }
  }

  void setText(String _text) {
    text = _text;
  }
  
  void setGedr(String _text) {
    text = _text;
  }

  void clicked() {
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      if (event != null && !gedrueckt) {
        event.click();
      }
      gedrueckt = !gedrueckt;
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