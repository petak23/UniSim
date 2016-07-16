class Prvok {
  String obsah;
  int stav;
      /*----*---------------------*----*-----------------------*
       |stav| Vyznam              |stav| Vyznam                |
       *----*---------------------*----*-----------------------*
       | -1 | odkaz               |  5 | Rusenie posunovej c.  |
       |  0 | volny usek          |  6 | Rusenie vlakovej c.   |
       |  1 | zaver posunovej c.  |    |                       |
       |  2 | zaver vlakovej c.   |    |                       |
       |  3 | obsadeny usek       |    |                       |
       |  4 | porucha useku       |    |                       |
       *----*---------------------*----*-----------------------*
       | >0 | pre ZB odk. na vlak cez slpoz                    |
       *----*--------------------------------------------------*
       | 1,2| pre TS smer                                      |
       |bit2| =1 pre TS pozadovana zmena pre AB                |
       *----*--------------------------------------------------*
       |pre K? bit 0-3 sucasny stav bit 4-7 nasl. zaver cesty  |
       *----*--------------------------------------------------*/
    int pvlak; /* ak je usek obsadeny al. pod zav.vl. al. pos c. tak je tam cislo vlaku. Inak 0. */
    int rych;  /* znizena rychlost pre dany usek. Ak 255-neurcena */
    char[] ch = new char[2];
    int dl;
    int[] n = new int[2];
    int[] c = new int[4];
    int sm, odk, y, sl;
//    viac:pointer;  /* - N? if <>nil tak fronta pre vykreslenie cesty 
//                      - K? info o vlakoch,supravach a lv na kolaji */

   Prvok(String s) {
     obsah = s;
     ch[0] = ' ';
     ch[1] = ' ';
     y = 0;
     for (int i = 0; i < 4; i = i+1) { 
       c[i] = 0;
     }  
     dl = 0;
     n[0] = 0;
     n[1] = 0;
     sm = 0;
     sl = 0;
     odk = 0;
   }
 
  void updatePrvok(String s) {
    obsah = s;
    ch[0] = s.charAt(1);
    ch[1] = s.charAt(2);
    y = int(s.substring(9,11));
    for (int i = 0; i < 4; i = i+1) { 
      c[i] = int(s.substring(4+i*9,11+i*9));
    }  
    dl = int(s.substring(49,54));
    n[0] = int(s.substring(56,60));
    n[1] = int(s.substring(62,66));
    sm = int(s.substring(68,70));
    sl = int(s.substring(72,72));
    odk = int(s.substring(74,74));
  }

  String getPrvokObsah() {
    return obsah;
  }
  
  Prvok getPrvok() {
    return this;
  }
}