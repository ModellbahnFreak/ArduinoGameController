class UIButton implements UIObj {
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
  String text;
  UIEvents event = null;

  UIButton(float _x, float _y, /*float _w,*/ float _h, int _farbe, String _text) {
    x=_x;
    y=_y;
    //w=_w;
    h=_h;
    farbe = _farbe;
    text = _text;
    textSize(h-6);
    w = textWidth(text+6);
    textColor = color(255-red(farbe), 255-green(farbe), 255-blue(farbe));
  }

  void setEvent(UIEvents _event) {
    event = _event;
  }

  void display() {
    noStroke();
    fill(farbe);
    rect(x, y, w, h);
    fill(textColor);
    textAlign(LEFT, TOP);
    textSize(h-6);
    text(text, x+3, y+3);
  }

  void setText(String _text) {
    text = _text;
  }

  void clicked() {
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
      if (event != null) {
        event.click();
      }
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