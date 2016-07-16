unit GVDnewu;
interface
procedure smallFontProc;
function igraph(dir:string):string;
procedure kbd(var a:integer);
function hladaj(ms:string):boolean;
procedure vmenu(x,y:word;k1,k2,po:byte;var vyb:byte);
procedure nulmenu(x,y:word;k1,k2,po:byte);
procedure karta(x1,y1,x2,y2,x:integer;nazov:string;vid:boolean);
procedure zadokno(x,y,z:integer;typ:boolean);
procedure vstl(x1,y1,x2,y2,z:word;tl:boolean;s:string);
procedure tlacidko(x,y:word;tl:boolean;s:string);
procedure tlacsip(x,y:word;tl:boolean;ch:char);
procedure zaskrt(x,y:word;za,typ:boolean;s:string);
function vybe(i:integer):string;
procedure xr(x,y,cp,co:integer;s:string;var xr:string);
procedure von(x,y,co,p:integer;cis:real);
procedure dnu(x,y,cp,co:integer;s:string;var dnu:real);
procedure vondnu(x,y,cp,co,cv:word;vypis,nastav:string;var vondnu:real);
procedure vondnus(x,y,cp,co,cv:word;vypis,nastav:string;var vondnu:string);
function red(s:string):string;
function sti(r:real;c,d:byte):string;
function help(index:byte):string;
procedure pomocnik(index:byte);
procedure chybhl(index:byte);
function anonie(s:string):boolean;
procedure chybt(s:string);
procedure druhvl(cislo:longint;var vlak:string);
implementation
uses crt,graph,dos,dswmouse;
type sst=^string;
     ii=^integer;
var q,qo:sst;
    s:string;
    i,x,y,z:integer;
    vel:array[1..5] of word;
    miesto:array[1..5]of pointer;
    pal:palettetype;

procedure smallFontProc; external;
{$L Small.OBJ }

function igraph(dir:string):string;
var gd,gm,chy:integer;
    menodir,hla:string;
    directory:text;
begin hla:='';
mouseinst;
if instalm then begin end else begin
 writeln('Nie je v pam„ti zavedenì driver pre myç ! ');halt(1);end;
if RegisterBGIfont(@smallFontProc) < 0 then hla:='Small';
getdir(0,menodir);
igraph:=menodir;
gd:=detect;gm:=1;menodir:=menodir+'\fonty';
initgraph(gd,gm,menodir);
chy:=graphresult;
if chy <> grOK then begin
 writeln('Program konŸ¡ chybou: ',chy,'. Mo§n  pr¡Ÿina :',hla);
 HALT(1);end;
cleardevice;
MouseZap;SetMousePos(320,240);SetX(0,GetMaxX);SetY(0,GetMaxY);
MouseCitl(8,8);mousevyp;
end;

procedure kbd(var a:integer);
var ch:char;
begin
a:=0;ch:=readkey;
if ord(ch)=0 then begin ch:=readkey;
                       a:=ord(ch)+256;end
                       else a:=ord(ch);
end;

function hladaj(ms:string):boolean;
var f:file;
begin
{$I-}
 assign(f,ms);reset(f);close(f);
{$I+}
 hladaj:=(ioresult=0)and(ms<>'');
end;


procedure vmenu(x,y:word;k1,k2,po:byte;var vyb:byte);
var xmx,ymx,i,j,a,b:integer;
    dvoj:boolean;
 procedure nulit;
 var i:byte;
 begin
  setfillstyle(1,1);bar(x+1,y+1,xmx-1,ymx-1);
  setcolor(9);line(x,ymx,x,y);line(x,y,xmx-1,y);
  setcolor(8);line(xmx,y,xmx,ymx);line(xmx,ymx,x+1,ymx);
  setcolor(14);
  for i:=k1 to k2 do outtextxy(x+10,y+(i-k1)*12+5,vybe(i));
 end;

begin
settextstyle(2,0,4);xmx:=0;
for i:=k1 to k2 do if (length(vybe(i))*8)>xmx then xmx:=length(vybe(i))*8;
if (xmx+x+20)>getmaxx then x:=getmaxx-xmx-20;
xmx:=x+xmx+20;
if (y+(k2-k1)*12+18)>getmaxy then y:=getmaxy-((k2-k1)*12)-18;
ymx:=y+(k2-k1)*12+18;
vel[po]:=imagesize(x,y,xmx,ymx);getmem(miesto[po],vel[po]);
getimage(x,y,xmx,ymx,miesto[po]^);nulit;
mousezap;
repeat
 getmousepos(mx,my);tlac:=tlacitka(dvoj);
 if (mx>x)and(mx<xmx)and(my>y)and(my<ymx) then begin
 a:=abs(my-y-5);
 a:=trunc(a/12);
 if a>(k2-k1) then a:=k2-k1;
 if a<>b then begin
  mousevyp;nulit;setfillstyle(1,6);bar(x+1,y+3+a*12,xmx-1,y+15+a*12);
  setcolor(13);outtextxy(x+10,y+5+a*12,vybe(a+k1));b:=a;mousezap;end;
 end;
until tlac=1;
mousevyp;delay(250);
vyb:=a+k1;
end;

procedure nulmenu(x,y:word;k1,k2,po:byte);
var xmx,ymx,i:word;
begin
xmx:=0;
for i:=k1 to k2 do if (length(vybe(i))*8)>xmx then xmx:=length(vybe(i))*8;
if (xmx+x+20)>getmaxx then x:=getmaxx-xmx-20;
xmx:=x+xmx+20;
if (y+(k2-k1)*13+10)>getmaxy then y:=getmaxy-((k2-k1)*13)-10;
ymx:=y+(k2-k1)*13+10;
setfillstyle(1,0);bar(x,y,xmx,ymx);
putimage(x,y,miesto[po]^,0);
end;


procedure zadokno(x,y,z:integer;typ:boolean);
var f:byte;
begin
if typ=true then f:=15 else f:=8;
 setfillstyle(1,f);bar(x,y,x+z+1,y+15);
 setcolor(0);line(x-1,y,x-1,y+14);
 setcolor(8);line(x-1,y-1,x+z+1,y-1);line(x+z+1,y-1,x+z+1,y+14);
 setcolor(7);line(x,y+14,x+z,y+14);
end;

procedure vstl(x1,y1,x2,y2,z:word;tl:boolean;s:string);
type farb=array[1..2,1..4]of byte;
const f:farb=((7,15,8,0),(8,0,15,7));
var fa:byte;
begin
case tl of
 false:fa:=1;
 true:fa:=2;
end;
 setfillstyle(1,f[fa,1]);bar(x1,y1,x2,y2);
 setcolor(f[fa,2]);line(x1-1,y1-1,x2,y1-1);line(x1-1,y1-1,x1-1,y2);
 setcolor(f[fa,3]);line(x1-1,y2+1,x2+1,y2+1);line(x2+1,y2+1,x2+1,y1-1);
 settextstyle(2,0,4);setcolor(f[fa,4]);outtextxy(x1+5,y1+z,s);
end;



procedure tlacidko(x,y:word;tl:boolean;s:string);
begin
if tl=true then begin
 vstl(x,y,x+50,y+20,5,tl,s);delay(200);tl:=false;end;
vstl(x,y,x+50,y+20,5,tl,s);
end;

procedure tlacsip(x,y:word;tl:boolean;ch:char);
 procedure sipka;
 var f:byte;
  begin
   if tl=false then f:=0 else f:=15;
   setcolor(f);
   case ch of
    '':begin moveto(x+5,y+3);linerel(-3,4);linerel(6,0);linerel(-3,-4);end;
    '':begin moveto(x+5,y+7);linerel(-3,-4);linerel(6,0);linerel(-3,4);end;
   end;
   setfillstyle(1,f);floodfill(x+5,y+5,f);
  end;
begin
if tl=true then begin
 vstl(x,y,x+10,y+10,5,tl,'');sipka;delay(200);tl:=false;end;
vstl(x,y,x+10,y+10,5,tl,'');sipka;
end;

procedure zaskrt(x,y:word;za,typ:boolean;s:string);
var f:byte;
begin
if typ=true then f:=15 else f:=8;
setcolor(f);circle(x+5,y+5,4);
setfillstyle(1,f);floodfill(x+5,y+5,f);
setcolor(0);arc(x+5,y+5,45,225,5);
setcolor(7);arc(x+5,y+5,225,45,5);
setcolor(0);settextstyle(2,0,4);outtextxy(x+15,y,s);
if (za=true) and (typ=true) then begin
 setcolor(1);circle(x+5,y+5,2);setfillstyle(1,1);floodfill(x+5,y+5,1);end;
end;

procedure karta(x1,y1,x2,y2,x:integer;nazov:string;vid:boolean);
begin
if x>=0 then begin
 if vid=true then begin
  setcolor(0);
  line(x1,y1,x1+x,y1);moveto(x1+x,y1);linerel(0,-20);
  linerel(45,0);linerel(0,20);line(x1+x+45,y1,x2,y1);
  setcolor(15);
  line(x1+1,y1+1,x1+x+1,y1+1);moveto(x1+x+1,y1+1);linerel(0,-20);
  linerel(43,0);line(x1+x+46,y1+1,x2-1,y1+1);
  setcolor(0);
  line(x1+x+46,y1-19,x1+x+46,y1);settextstyle(2,0,4);
  outtextxy(x1+x+4,y1-15,nazov);
  moveto(x1,y1);linerel(0,y2-y1);linerel(x2-x1,0);linerel(0,y1-y2);
  setcolor(15);
  moveto(x1+1,y1+1);linerel(0,y2-y1-2);moveto(x1+1,y2+1);linerel(x2-x1,0);
  linerel(0,y1-y2);
                  end;
 if vid=false then begin
  setcolor(0);
  moveto(x1+x,y1-1);linerel(0,-19);linerel(45,0);linerel(0,20);
  settextstyle(2,0,4);outtextxy(x1+x+4,y1-15,nazov);
  setcolor(15);
  moveto(x1+x+1,y1-1);linerel(0,-18);linerel(43,0);
  line(x1+x+46,y1-1,x1+x+46,y1-19);
                   end;
                   end
 else begin setfillstyle(1,7);bar(x1,y1,x2,y2);setfillstyle(1,1);
  bar(x1+5,y1+2,x2-5,y1+15);settextstyle(2,0,4);setcolor(15);
  outtextxy(x1+10,y1+4,nazov);
      end;
end;

function vybe(i:integer):string;
var p:string;
begin
case i of
  1:p:='Subor';                          2:p:='Stanica';
  3:p:='Vlak';                           4:p:='Tabulka';
  5:p:='Help';                           6:p:='Koniec';

  10:p:='Novy';                          11:p:='Otvor';
  12:p:='Uloz';                          13:p:='Uloz ako';

  40:p:='List';                          41:p:='Tabulka stanic';

  90:p:='Stanica';                       91:p:='Zastavka';
  92:p:='Odbocka';                       93:p:='Vyhybna';

  100:p:='Ano';                          101:p:='Nie';
end;
vybe:=p;
end;

procedure xr(x,y,cp,co:integer;s:string;var xr:string);
const odstup=6;
var ch:char;
    key:integer;
begin setcolor(co);for key:=1 to length(s) do outtextxy(x+odstup*(key-1),y,s[key]);
      x:=x+odstup*length(s);
      setlinestyle(0,0,1);
repeat;
 rectangle(x+2,y-2,x+6,y+9);
 kbd(key);
 case key of
 32..126,130,147,149,150,155,156,159..161,163,166,167,172,210,212,213,229..231,236:begin
 {zadaj}  ch:=chr(key);setcolor(cp);rectangle(x+2,y-2,x+6,y+9);setcolor(co);
          outtextxy(x,y,ch);s:=s+ch;x:=x+odstup;
         end;
 8:begin i:=length(s);ch:=s[i];
 {<-}    setcolor(cp);rectangle(x+2,y-2,x+6,y+9);x:=x-odstup;
         setfillstyle(1,cp);bar(x,y,x+odstup,y+9);
         setcolor(co);
         delete(s,i,1);
   end;
 339:begin setcolor(cp);rectangle(x+2,y-2,x+6,y+9);x:=x-odstup*length(s);
 {del}     outtextxy(x,y,s);
           setcolor(co);s:='';
     end;
 end;
 until key=13;
 setcolor(cp);rectangle(x+2,y-2,x+6,y+9);
 xr:=s;
end;

procedure von(x,y,co,p:integer;cis:real);
var q:sst;
begin
 setcolor(co);new(q);
 str(cis:10:p,q^);q^:=red(q^);
 outtextxy(x,y,q^);dispose(q);
end;

procedure dnu(x,y,cp,co:integer;s:string;var dnu:real);
begin
 new(q);
 xr(x,y,cp,co,s,q^);
 val(q^,dnu,i);dispose(q);
end;

procedure vondnu(x,y,cp,co,cv:word;vypis,nastav:string;var vondnu:real);
const odstup=6;
begin
 setcolor(cv);outtextxy(x,y,vypis);
 if (length(vypis)*odstup)>620 then begin y:=y+15;x:=200;end
  else x:=(length(vypis)*odstup)+10+x;
 dnu(x,y,cp,co,nastav,vondnu);
end;

procedure vondnus(x,y,cp,co,cv:word;vypis,nastav:string;var vondnu:string);
const odstup=8;
begin
 setcolor(cv);outtextxy(x,y,vypis);
 if (length(vypis)*odstup)>620 then begin y:=y+15;x:=200;end
  else x:=(length(vypis)*odstup)+10+x;
 xr(x,y,cp,co,nastav,vondnu);
end;


function red(s:string):string;
begin
while(s[1]=' ') do delete(s,1,1);
red:=s;
end;

function sti(r:real;c,d:byte):string;
var s:string;
    a:boolean;
begin
 str(r:c:d,s);c:=length(s);
 if d>0 then begin
  repeat;a:=false;
  if s[c]='0' then begin delete(s,c,1);a:=true;c:=length(s);end;
  if s[c]='.' then delete(s,c,1);
  until a=false;
             end;
 sti:=red(s);
end;



function help(index:byte):string;
begin
 case index of
  1:help:='Dlzka nazvu musi byt v rozmedzi 1-8 znakov.';
  2:help:='Pocet casti musi byt od 1 do 3.';
  3:help:='Cas musi byt medzi 0 az 23 hod.(v celych hodinach).';
  4:help:='Toto priecestie treba rozbyt na dva jednokolajne';
  5:help:='Hodnota musi byt v rozmedzi 1-50';
  6:help:='Musis oznacit ci ide o priecesti alebo priechod';
  7:help:='Hodnota musi byt v rozmedzi 1-20';
  8:help:='Hodnota musi byt v rozmedzi 0-1,5';
  9:help:='Hodnota musi byt v rozmedzi 3-10';
  10:help:='V tejto verzii nie je aktivne.';
  11:help:='Najprv treba zadat vstupne data alebo otvorit existujuci subor';
 end;
end;

procedure pomocnik(index:byte);
var s:array[1..3]of string;
    i:byte;
begin
for i:=1 to 3 do outtextxy(15,415+15*i,s[i]);
settextstyle(0,0,1);
end;

procedure chybhl(index:byte);
var miesto:pointer;
    velkost:word;
begin
 if index>0 then begin
 velkost:=imagesize(5,225,635,255);settextstyle(2,0,4);
 getmem(miesto,velkost);getimage(5,225,635,255,miesto^);
 setfillstyle(1,4);bar(5,225,635,255);setlinestyle(0,0,1);setcolor(14);
 rectangle(10,230,630,250);setcolor(10);outtextxy(25,237,help(index));readln;
 setfillstyle(0,0);bar(5,225,635,255);putimage(5,225,miesto^,normalput);
 settextstyle(0,0,1);
                 end;
end;


function anonie(s:string):boolean;
var vel:word;
    mi:pointer;
    x:word;
    ak,dvoj:boolean;
begin
x:=length(s)*3+10;if x<65 then x:=65;
vel:=imagesize(320-x,210,320+x,270);
getmem(mi,vel);
getimage(320-x,210,320+x,270,mi^);
karta(320-x,210,320+x,270,-1,'Rozhodnutie',true);setcolor(0);
outtextxy(330-x,230,s);
tlacidko(330-x,245,false,'Ano');
tlacidko(260+x,245,false,'Nie');
mousezap;ak:=false;
repeat
repeat
 getmousepos(mx,my);tlac:=tlacitka(dvoj);
until tlac=1;
mousevyp;
if (my>245)and(my<265) then begin
 if (mx>330-x)and(mx<380-x) then begin
  tlacidko(330-x,245,true,'Ano');ak:=true;anonie:=true;end;
 if (mx>260+x)and(mx<310+x) then begin
  tlacidko(260+x,245,true,'Nie');ak:=true;anonie:=false;end;
                            end;
mousezap;
until ak=true;
setfillstyle(1,0);bar(320-x,210,320+x,270);
putimage(320-x,210,mi^,normalput);
end;

procedure chybt(s:string);
var vel:word;
    mi:pointer;
    x:word;
    ak,dvoj:boolean;
begin
x:=length(s)*3+10;if x<65 then x:=65;
vel:=imagesize(320-x,210,320+x,270);
getmem(mi,vel);
getimage(320-x,210,320+x,270,mi^);
karta(320-x,210,320+x,270,-1,'Chyba',true);setcolor(4);
outtextxy(330-x,230,s);
tlacidko(295,245,false,'OK');
mousezap;ak:=false;
repeat
repeat
 getmousepos(mx,my);tlac:=tlacitka(dvoj);
until tlac=1;
mousevyp;
if (mx>295)and(mx<345)and(my>245)and(my<265) then begin
 tlacidko(295,245,true,'OK');ak:=true;end;
mousezap;
until ak=true;
mousevyp;
setfillstyle(1,0);bar(320-x,210,320+x,270);
putimage(320-x,210,mi^,normalput);
end;

procedure druhvl(cislo:longint;var vlak:string);
var dlzka:integer;
    cs:string[5];
  begin
    cs:=sti(cislo,5,0);
    dlzka:=length(cs);
    case dlzka of 1,2:vlak:='EC';
                  3:if cs[1] in ['1'..'5'] then vlak:='IC'
                                           else vlak:='R';
                  4:begin
                 if (cs[1]='1')and(cs[2] in['0'..'6']) then vlak:='Rpost'
                                                       else
                    if (cs[1]='1')and(cs[2] in['7'..'9']) then vlak:='Zr'
                                                         else vlak:='Os';
              if (cs[1]='2')and(cs[2]='8')and(cs[3]='8') then vlak:='Sv';
                    end;
                5:case cs[1] of '1':if cs[3] in['0'..'6'] then vlak:='R'
                                                         else vlak:='Os';
                                '2':vlak:='Os';
                                '3','4':vlak:='Pn';
                                '5':case cs[4] of '0':vlak:='Nex';
                                                  '1','2':vlak:='Rn';
                                                  '3','4':vlak:='KPS';
                                              '5','6','7':vlak:='Sn';
                                                  '8','9':vlak:='Vn';
                                                  end;
                   '6':vlak:='Pn';
                   '7':vlak:='Lv';
                   '8':if cs[4] in['0'..'7'] then vlak:='Mn'
                                             else vlak:='Vlec';
                   '9':vlak:='Pv';
                   end;
                end;
  end;
end.
