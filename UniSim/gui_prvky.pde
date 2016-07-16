/* Objekt pre pracu spolom prvkov */
class Gui_prvky {

 /* @var Prvok[] prvky Pole typu Prvok */
 Prvok[] prvky;
 int mimo = 0;
 /* Velkost plochy y bez pomocnej casti*/
 int size_y;
 /* Velkost jedneho policka v smere x a y */
 int krok_x, krok_y;
 /* @var int XP x-ovi rozmer plochy */
 int XP = 63;
 /* @var int YP y-ovi rozmer plochy */
 int YP = 30;
 int pocet;
 
 /* Konstruktor */
 Gui_prvky() {
   pocet = XP*YP;
   prvky = new Prvok[pocet]; //Definuje pole rozmerov XP*YP
   for (int i = 0; i < pocet; i = i+1) { //Inicializuje pole vyplnenim ""
     prvky[i] = new Prvok("");
   }
   size_y = height - 200;
   krok_x = width / XP;
   krok_y = size_y / YP;
 }
 
 /* Vrati dlzku pola XP*YP
  * @return int */
 int getPocet() {
   return pocet;
 }
 
 /* Nastavi v poli prvky konkretnu polozku na zaklade info. v s
  * @param String s Info o prvku */
 void SetPrvok(String s) {
   int xs = int(s.substring(4,7));
   if (xs < pocet) {
     prvky[xs].updatePrvok(s);
//     text("OK  : " + str(xs) + " s: " + s, 5, 30 + 15 * mimo);
   } else {
//     text("Mimo: " + str(xs) + " s: " + s, 5, 30 + 15 * mimo);
     mimo = mimo+1;
   }   
 }
 
 int getMimo() {
   return mimo;
 }
 
 int getXP() {
   return XP;
 }
 
 /* Vrati konkretny prvok pola podla suradnice xs
  * @param int xs Suradnica
  * @return String */
 String/*Prvok*/ GetPrvok(int xs) {
  return prvky[xs].getPrvokObsah(); 
 }
 
 void mriezka() {
   for (int i = 0; i < pocet; i = i+1) {
     stroke(128,200,200);
     noFill();
     rect((i % XP) * krok_x, (i / XP) * krok_y, krok_x, krok_y);
   }
 }
 
 void kresliPrvok(int xs) {
   if (prvky[xs].getPrvok().ch[0] != ' ') {
     stroke(128,200,200);
     fill(230);
     rect((xs % XP) * krok_x, (xs / XP) * krok_y, krok_x, krok_y);
   }
 }
  
}