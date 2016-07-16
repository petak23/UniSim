unit deklar;
interface                      {0  1  2  3  4 5 6  7  8  9}
const dx:array[0..9]of integer=(0,-1, 0, 1,-1,0,1,-1, 0, 1); {posun x}
      dy:array[0..9]of integer=(0, 1, 1, 1, 0,0,0,-1,-1,-1); {posun y}
      krokx=10;kroky=12;    {graficky krok(x,y)-parne cislo>5}
      xmin=01;xmax=(639 div krokx);   {hranice X -> 0<xmin<63}
      ymin=10;ymax=(300 div kroky)+13;{hranice Y -> 9<ymin<30}
      slmax=150;      {Pocet poloziek v poly premennej SLPOZ}
      relx=0;rely=0;  {relativna suradnica pre vykreslovanie - prevody}

      riadky=9;stlpce=3; {vypis vlakov}
      mstan=10;       {Max-pocet stanic vlakov}
type
   {Definovanie dinamickych typov}         {1 2|and|or |xor}
     chup=^chu;                            {0 0| 0 | 0 | 0 }
     vlakkp=^vlakk;                        {0 1| 0 | 1 | 1 }
     tep=^te;                              {1 0| 0 | 1 | 1 }
     ssp=^string;                          {1 1| 1 | 1 | 0 }
   {Charakteristika useku}                 {or - nastav 1  }
     chu=record                            {and- nastav 0  }
      ch:array[1..2]of char;
      dl,nx0,ty0:word;
      c:array[1..4] of longint;
      xs:word;
      y:byte;
      sm:byte;
      sl:integer;
      odk:byte;
     end;
     chudin=^chudyn;
   {pozicia}
     chudyn=record  {Pre POZICIU}
      stav:shortint;
        {ษออออหอออออออออออออออออออออหออออหอออออออออออออออออออออออป
         บstavณ Vyznam              บstavณ Vyznam                บ
         ฬออออฮอออออออออออออออออออออฮออออฮอออออออออออออออออออออออน
         บ -1 ณ odkaz               บ  5 ณ Rusenie posunovej c.  บ
         บ  0 ณ volny usek          บ  6 ณ Rusenie vlakovej c.   บ
         บ  1 ณ zaver posunovej c.  บ    ณ                       บ
         บ  2 ณ zaver vlakovej c.   บ    ณ                       บ
         บ  3 ณ obsadeny usek       บ    ณ                       บ
         บ  4 ณ porucha useku       บ    ณ                       บ
         ฬออออฮอออออออออออออออออออออสออออสอออออออออออออออออออออออน
         บ >0 ณ pre ZB odk. na vlak cez slpoz                    บ
         ฬออออฮออออออออออออออออออออออออออออออออออออออออออออออออออน
         บ 1,2ณ pre TS smer                                      บ
         บbit2ณ =1 pre TS pozadovana zmena pre AB                บ
         ฬออออสออออออออออออออออออออออออออออออออออออออออออออออออออน
         บpre K? bit 0-3 sucasny stav bit 4-7 nasl. zaver cesty  บ
         ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
         }
      pvlak:longint; {ak je usek obsadeny al. pod zav.vl. al. pos c.
                     tak je tam cislo vlaku. Inak 0.}
      rych:byte;     {znizena rychl. pre dany usek. Ak 255-neurcena}
      ch:array[1..2]of char;
      dl:word;
      n:array[1..2] of word;
      c:array[1..4] of longint;
      sm,odk,y,sl:byte;
      viac:pointer;  {- N? if <>nil tak fronta pre vykreslenie cesty}
                     {- K? info o vlakoch,supravach a lv na kolaji}
     end;
   {Text}
     te=record
      xs:word;
      tex:string;
      skr:string[3];
     end;
   {vlakova cesta}
     vlcesta=record
      ch:byte;
      zc,kc:word;
      vyh:array[1..20]of byte;{VK-bit 0,1 cesta 1 al.2 ak 0 nepouzite}
                              {  -bit 2,3 cesta 3 al.4 ak 0 nepouzite}
     end;
   {slpoz}
     sslpo=record
      x:word;
      y,cas:longint;
      nst:shortint;
        {ษออออหออออออออออออออออออออออออออออออออออออออออออออออออออป
         บnst.ณ Nasleduluci stav                                 บ
         ฬออออฮออออออออออออออออออออออออออออออออออออออออออออออออออน
         บ -1 ณ Bez vyznamu - volna polozka                      บ
         บ  0 ณ Uvolnenie useku medzistanicneho                  บ
         บ  1 ณ Uvolnenie useku so zmazanim vlaku z plochy       บ
         บ  2 ณ Uvolnenie useku v posunovej ceste                บ
         บ  3 ณ Obsadenie medzistanicneho useku                  บ
         บ  4 ณ Obsadenie useku v posunovej ceste                บ
         บ  5 ณ Uvolnenie useku vo vlakovej ceste                บ
         บ  6 ณ Obsadenie useku vo vlakovej ceste                บ
         บ  7 ณ Zmena smeru vlaku a odpocet                      บ
         บ  8 ณ  -- // --                                        บ
         บ  9 ณ  -- // --                                        บ
         บ 10 ณ Rusenie vlakovej cesty                           บ
         บ 14 ณ Zmena rychlosti vlaku                            บ
         บ 20 ณ Zaradenie dalsieho vlaku                         บ
         บ 21 ณ Vchod prijateho vlaku                            บ
         บ 22 ณ Zaradenie novych vlakov podla GVD                บ
         บ 30 ณ Zmena TS pri AB                                  บ
         บ 50 ณ Ako 0 ale vlak stoji vakt=0                      บ
         บ 51 ณ Ako 1 ale vlak stoji vakt=0                      บ
         บ 53 ณ Ako 3 ale vlak stoji vakt=0                      บ
         บ 55 ณ Ako 5 ale vlak stoji vakt=0                      บ
         บ 56 ณ Ako 6 ale vlak stoji vakt=0                      บ
         บ 70 ณ Zastavenie vlaku v stanici                       บ
         บ100 ณ Zmazanie okienka diag. nav                       บ
         ศออออสออออออออออออออออออออออออออออออออออออออออออออออออออผ}
     end;
   {vlak}
     vlakk=record
      cv1,cv2,clo:longint;
      casz,mz,mo:word;
      vm,dl:byte;
      sm:shortint;
      stm:array[1..mstan]of word;{cis SB}
      stco:array[1..mstan]of word;{cas odchodu v min}
      stcp:array[1..mstan]of word;{cas prichodu v min}
     end;
   {-- FRONTY --}
    {fronty dejov}
     dej_ukaz=^dej_prvok;
     dej_prvok=record
      cas:longint;
      cislo:word;
      dalsi:dej_ukaz;
     end;
    {fronta vlakov}
     vlak_ukaz=^vlak_prvok;
     vlak_prvok=record
      cislo:longint;  {cislo vlaku}
      vmax,va,vp:byte;{rychlosti:vmax-maximalna,va-aktualna,vp-pomocna}
      poz:word;       {pozicia v subore vlakov}
      dalsi:vlak_ukaz;
     end;
   {-- KONIEC FRONTY --}
     subo=string[12];
    {-- Hodinky --}
     hho=record
      text:string[8];
      cas:longint;
     end;
    {-- Okienka --}
     okie=record
      slid,cisn:word;
     end;
   {Zlozenie kolaje-obsadenie voznami}
     kolaj_fr=^kolaj_prvok;{fronta kolaje}
     kolaj_prvok=record    {prvok fronty}
      cislo:longint;       {cislo vlaku, lv, supravy}
      smer:array[1..2] of kolaj_fr;{odkaz podla smeru na dalsiu cast}
     end;
     zloz_po=^zlozenied;   {zlozenie kolaje - din. pr.}
     zlozenied=array[0..2]of kolaj_fr;{ukazatel na frontu}
var i,j,k,tlac,polh,kx:word;
    slind:word;    {index slpoz pri deleni do moznosti}
    body:word;     {bodovanie}
    mx,my:word;    {pozicia mysy}
    mysx,mysy:word;{stara pozicia mysy koli menu}
    pomv:longint;  {pomocny longinteger}
    mys_stl:byte;  {ci je stlacena mys}
    cis_menu:byte; {cislo vyvolaneho menu}
    key:integer;   {stisnuta klavesa}
    cha:byte;      {charakter vlak. cesty- 2-vlakova,1-posunova}
    ca:boolean;
    ss:ssp;
    dvoj:boolean;  {pri dvojkliku mysou}
    charusk:chu;
    chu_zac:word;  {zaciatok vlakovej cesty}
    vlakc:vlcesta;
    vlak:vlakk;
    txt:tep;
    zlozenie:zloz_po;
     {-- Okienka --}
    okno_nav:okie;
     {-- Hodiny --}
    casre:longint;
    pripocitaj:boolean;
    hodiny:hho;
     {-- Subory --}
    usek:file of chu;
    strsu:file of te;
    vlc:file of vlcesta;
    svlak:file of vlakk;
    subor:file of subo;
     {-- Polia --}
    pozicia:array[xmin..(ymax-ymin)*xmax]of chudin;
    slpoz:array[1..slmax] of sslpo;
    caslong,caspom,caszac,slcas:longint;
    pomoc:text;
     {-- Fronta --}
    pom_vrchol,dej_vrchol:dej_ukaz;
    vlak_vrchol:vlak_ukaz;
    naz:string;
    stav:byte;
      {ษอออหอออหอออออออออออออออออออออออออออออออออออออออออออออออออป
       บbitบ h บ vyznam - toto je stavov์ bajt                   บ
       ฬอออฮอออฮอออออออออออออออออออออออออออออออออออออออออออออออออน
       บ 0 บ  1บ cas bol aktualizovany                           บ
       บ 1 บ  2บ ak =1 tak povolena diagn. nav.                  บ
       บ 2 บ  4บ ak =1 zakaz vypisu casu                         บ
       บ 3 บ  8บ bola stlacena klavesa                           บ
       บ 4 บ 16บ                                                 บ
       บ 5 บ 32บ                                                 บ
       บ 6 บ 64บ                                                 บ
       บ 7 บ128บ                                                 บ
       ศอออสอออสอออออออออออออออออออออออออออออออออออออออออออออออออผ}
    stavkl:byte;
      {ษอออหอออหอออออออออออออออออออออออออออออออออออออออออออออออออป
       บbitบ h บ vyznam - toto je stavov์ bajt klavesnice        บ
       ฬอออฮอออฮอออออออออออออออออออออออออออออออออออออออออออออออออน
       บ 0 บ  1บ stlaceny Ctrl                                   บ
       บ 1 บ  2บ stlaceny Alt                                    บ
       บ 2 บ  4บ stlaceny Shift                                  บ
       บ 3 บ  8บ                                                 บ
       บ 4 บ 16บ                                                 บ
       บ 5 บ 32บ                                                 บ
       บ 6 บ 64บ                                                 บ
       บ 7 บ128บ                                                 บ
       ศอออสอออสอออออออออออออออออออออออออออออออออออออออออออออออออผ}

{procedure hodnoty(volba:byte);
function  sti(r:real;c,d:byte):string;}

implementation
{
procedure hodnoty(volba:byte);
 {vypisanie hodnot fronty. Volba urci frontu:1 - DEJ; 2 - POM, 3-vlak}
var temp:dej_ukaz;
    poc:word;
    temp1:vlak_ukaz;
begin
 poc:=1;
 writeln(pomoc,'Caslong: ',caslong);
 case volba of
  1,2:begin
       if volba=1 then temp:=dej_vrchol else temp:=pom_vrchol;
       if temp=NIL then writeln(pomoc,'Zoznam je prazdny')
       else while temp<>NIL do begin
        with temp^ do
         writeln(pomoc,poc:2,'. cas:',cas,'- slpoz[',cislo:2,'] (x:',slpoz[cislo].x:4,',y:',slpoz[cislo].y:5,
         ',cas:',slpoz[cislo].cas:6,',nst:',slpoz[cislo].nst:2,')');
        temp:=temp^.dalsi;inc(poc);
       end;
      end;
  3:begin
     temp1:=vlak_vrchol;
     if temp1=NIL then writeln(pomoc,'Zoznam je prazdny')
     else while temp1<>NIL do begin
      with temp1^ do
       writeln(pomoc,poc:2,'. cislo:',cislo:5,'- vmax:',vmax:3,',va:',va:3,',vp:',vp:3,',poz:',poz:6);
      temp1:=temp1^.dalsi;inc(poc);
     end;
    end;
 end;
end;

function sti(r:real;c,d:byte):string;
var q:sst;
    a:boolean;
begin
 new(q);
 str(r:c:d,q^);c:=length(q^);
 if d>0 then begin
  repeat;
   a:=false;
   case q^[c] of
    '0':begin delete(q^,c,1);a:=true;c:=length(q^);end;
    '.':delete(q^,c,1);
   end;
  until a=false;
             end;
 sti:=red(q^);dispose(q);
end; }

begin
  {--- I n i c i a l i z a c i a  ---}
  {Zistenie pracovneho adresara}
{ new(ss);
 getdir(0,ss^);
 assign(pomoc,ss^+'\pomoc.txt');rewrite(pomoc);
 ss^:=ss^+'\trschemy\';
  {Priradenie suborov}
 assign(usek,ss^+'mala.dat');
 assign(strsu,ss^+'mala.dtx');
 assign(vlc,ss^+'mala.dvl');
 assign(svlak,ss^+'mala.gvd');dispose(ss);
  {Zakladne operacie so subormi}
 reset(usek);close(usek);
 reset(strsu);close(strsu);
 reset(vlc);close(vlc);
 reset(svlak);close(svlak);
  {Vycistenie zakladnych premennych}
 with charusk do begin
  ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;sl:=0;odk:=0;
 end;
 chu_zac:=0;
 for i:=xmin to ((ymax-ymin)*xmax) do pozicia[i]:=NIL;
 for i:=1 to slmax do
  with slpoz[i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
 mys_stl:=0;
 cis_menu:=0;body:=0;
 stav:=2;{povolena diagnostika nav.}
 with okno_nav do begin slid:=0;cisn:=0;end;}
end.
