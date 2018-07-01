class UIRect implements UIObj {
  float x;
  float y;
  int opacity;
  float w = 0;
  float h = 0;
  int farbe;
  UIEvents event = null;
  boolean CenterMode = false;

  UIRect(float _x, float _y, float _w, float _h, int _farbe) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    farbe = _farbe;
  }
  
  void setCenterMode(boolean mode) {
    CenterMode = mode;
  }
  
  void setEvent(UIEvents _event) {
    event = _event;
  }

  void display() {
    noStroke();
    fill(farbe);
    if (CenterMode) {
      rectMode(CENTER);
      rect(x, y, w, h);
      rectMode(CORNER);
    } else {
      rect(x, y, w, h);
    }
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