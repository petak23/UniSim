int krok_x, krok_y;
int XP = 63;
int YP = 30;
void setup() {
  
  size(820, 800);
  background(0);
  stroke(255);
  
  
  PFont font;
  font = createFont("Courier", 20, true);//Monaco
  textFont(font);
  fill(255);
  //textSize(15);
  for (int i = 0; i < 256; i = i+1) {
     text(i + ":"+ char(i), 5 + (80*(i/40)), 30 + (15 * (i%40)));
  }
  
  krok_x = width / XP;
  krok_y = (height - 200) / YP;
  text("krok_x: " + krok_x + " | krok_y: " + krok_y, 35, 650);
  noFill();
  stroke(120,250,25);
  rect(20, 700, krok_x, krok_y);
  
  //textSize(15);
  textAlign(CENTER, CENTER);
  text("M", 20 + krok_x / 2+1, 700 + krok_y / 2-3);
  line(10, 700 + krok_y / 2, 20, 700 + krok_y / 2);
  line(20 + krok_x, 700 + krok_y / 2, 30 + krok_x, 700 + krok_y / 2);
  

}

void draw() {
  
}