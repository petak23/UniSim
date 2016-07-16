/* Program UniSim
 *
 * Posledna zmena(last change): 13.07.2016
 * @author Ing. Peter VOJTECH ml. <petak23@gmail.com>
 * @copyright  Copyright (c) 2012 - 2016 Ing. Peter VOJTECH ml.
 * @license
 * @link       http://petak23.echo-msz.eu
 * @version 1.0.0
 */

/* @var String[] oblast_subor nacitany subor oblasti */
String[] oblast_subor;
//Prvok[] prvok;
Gui_prvky prvky;
int pocet_prvkov, xs;


void setup() {
  
  size(800, 800);
  background(0);
  stroke(255);
  oblast_subor = loadStrings("../trschemy/MALA.TXT");
  pocet_prvkov =  oblast_subor.length;
  prvky = new Gui_prvky();
  
  fill(255);
  textSize(15);
//  text("Našiel som: " + str(pocet_prvkov) + " prvkov. Max XS = "+ prvky.getPocet() +". Načítavam...", 5, 15);
  
  for (int i = 0; i < pocet_prvkov; i = i+1) {
     prvky.SetPrvok(oblast_subor[i]);
  }
//  text("Mimo je: " + prvky.getMimo(), 5, 30);
  prvky.mriezka();
  for (int i = 0; i < prvky.getPocet(); i = i+1) {
     prvky.kresliPrvok(i);
  }
}

void draw() {
  
}