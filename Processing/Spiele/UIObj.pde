interface UIObj {
  void display();
  void setEvent(UIEvents event);
  void clicked();
  void setX(float _x);
  void setY(float _y);
  float getX();
  float getY();
  float getWidth();
  float getHeight();
}