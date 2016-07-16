unit nepouzit;
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ----------------NEPOUZITE Procedury a funkcie --------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
Interface
function popen:string;
    {Vracia meno suboru}
function help(index:byte):string;
    {Text pre Help}
procedure chybhl(index:byte);
    {Chybove hlasenie}
procedure zadokno(x,y,z:integer;typ:boolean);
    {Zadavacie okno}
procedure tab(x1,y1,x2,y2,c1,c2:word);
    {tabulka????}
procedure tlacsip(x,y:word;tl:boolean;ch:char);
    {Tlacitko so sipkou}
procedure vloz(casl:longint;por:word;volba:byte);
    {Vlozenie na zaciatok. Volba rozhodne ktora fronta sa pouzije}
procedure hodnoty(volba:byte);
    {Vypisanie hodnot fronty. Volba urci frontu.}
procedure vloz_vlak(cislol:longint;vmaxl,vakt,vpom:byte);
    {vlozenie VLAKU na zaciatok}
procedure kv_dej;
   {vypise vrchol zasobnika}

Implementation


function zoznam:word;
var su:subo;
    dirinfo:searchrec;
    j:word;
begin
 assign(subor,ss+'zoznam.sub');rewrite(subor);
 findfirst(ss+'*.dat',archive,dirinfo);j:=0;
 while doserror = 0 do begin
  su:=dirinfo.name;
  write(subor,su);j:=j+1;
  findnext(dirinfo);   end;
zoznam:=j;
close(subor);
end;

function popen:string;  {Nahrava data zo suboru s menom v premennej menosub+'.dat'}
var su:subo;
    menosub:string;
    key:integer;
begin
tab(200,100,480,300,9,14);setcolor(15);
outtextxy(210,115,'Aktualny adresar :');outtextxy(215,130,ss);
outtextxy(210,145,'Meno suboru :');setfillstyle(1,8);
bar(210,158,470,170);
setcolor(15);rectangle(210,180,470,290);
j:=zoznam;
reset(subor);
for i:=1 to j do begin
 read(subor,su);delete(su,length(su)-3,4);outtextxy(215,172+i*13,su);end;
reset(subor);read(subor,su);close(subor);
delete(su,length(su)-3,4);menosub:=su;i:=1;
repeat
 setfillstyle(1,15);bar(214,159,215+length(menosub)*8,169);
 setcolor(8);
 for i:=1 to length(menosub) do outtextxy(207+8*i,160,menosub[i]);
 repeat;kbd(key);
  case key of
   32..126,130,147,149,150,155,156,159..161,163,166,167,172,210,212,213,229..231,236:begin
    dnustr(215,160,8,15,255,menosub,key,menosub);key:=13;end;
   336:begin i:=i+1;if i>j then i:=1;reset(subor);seek(subor,i-1);read(subor,su);
           close(subor);delete(su,length(su)-3,4);menosub:=su;
           setfillstyle(1,8);bar(210,158,470,170);setcolor(15);
           outtextxy(215,160,menosub);
       end;
  end;
 until key=13;
 if hladaj(ss+menosub+'.dat')=false then chybhl(12)
 else popen:=menosub;
until hladaj(ss+menosub+'.dat')=true;
erase(subor);
setfillstyle(0,0);bar(200,100,480,300);
end;

procedure dnustr(x,y,cp,co,dlzka:word;nastav:string;riad:word;var xr:string);
const odstup=8;
var ch:char;
    key,i,dly:integer;
    na:string;
    svit,c:boolean;
begin
if dlzka>255 then dlzka:=255;
na:=nastav;c:=true;
setfillstyle(1,co);bar(x-1,y-1,x+length(na)*8,y+9);
setcolor(cp);svit:=true;
for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
x:=x+odstup*length(na);setfillstyle(1,cp);setcolor(co);
dly:=length(na);
repeat;
 rectangle(x+2,y-1,x+6,y+9);
 if (c=true) and (riad>0) then begin key:=riad;c:=false;end else kbd(key);
case key of
 32..126,130,147,149,150,155,156,159..161,163,166,167,172,210,212,213,229..231,236:begin
      if dly+1<=dlzka then begin
       setcolor(cp);rectangle(x+2,y-1,x+6,y+9);x:=x-odstup*length(na);
       bar(x-1,y-1,x+length(na)*8,y+9);
       if svit=true then begin na:=chr(key);svit:=false;end else na:=na+chr(key);
       setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
       x:=x+odstup*length(na);dly:=length(na);
      end;
     end;
 8:begin setcolor(cp);rectangle(x+2,y-1,x+6,y+9);x:=x-odstup*length(na);
      bar(x-1,y-1,x+length(na)*8,y+9);dly:=dly-1;
      setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
      x:=x+odstup*length(na);i:=length(na);ch:=na[i];setcolor(cp);
      rectangle(x+2,y-1,x+6,y+9);
      if length(na)>0 then x:=x-odstup;
      outtextxy(x,y,ch);
      setcolor(co);delete(na,i,1);
      end;
 339:begin setcolor(cp);rectangle(x+2,y-1,x+6,y+9);x:=x-odstup*length(na);
           bar(x-1,y-1,x+length(na)*8,y+9);setcolor(co);na:='';dly:=0;
     end;
 end;
 until key=13;
 setcolor(cp);rectangle(x+2,y-1,x+6,y+9);
 xr:=na;
end;

function help(index:byte):string;
begin
 case index of
  1:help:='Hodnota';
 end;
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

procedure zadokno(x,y,z:integer;typ:boolean);
var f:byte;
begin
if typ=true then f:=15 else f:=8;
 setfillstyle(1,f);bar(x,y,x+z+1,y+15);
 setcolor(0);line(x-1,y,x-1,y+14);
 setcolor(8);line(x-1,y-1,x+z+1,y-1);line(x+z+1,y-1,x+z+1,y+14);
 setcolor(7);line(x,y+14,x+z,y+14);
end;

procedure tab(x1,y1,x2,y2,c1,c2:word);
begin
setfillstyle(1,c1);bar(x1,y1,x2,y2);
setcolor(c2);rectangle(x1+5,y1+5,x2-5,y2-5);
if (c2-8)<0 then setcolor(c2) else setcolor(c2-8);
rectangle(x1,y1,x2,y2);
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
    '<':begin moveto(x+2,y+4);linerel(6,-2);linerel(0,4);linerel(-6,-2);end;
    '>':begin moveto(x+8,y+4);linerel(-6,-2);linerel(0,4);linerel(6,-2);end;
   end;
   setfillstyle(1,f);floodfill(x+5,y+4,f);
  end;
begin
if tl=true then begin
 vstl(x,y,x+10,y+10,5,tl,'');sipka;delay(200);tl:=false;end;
vstl(x,y,x+10,y+10,5,tl,'');sipka;
end;

procedure vloz(casl:longint;por:word;volba:byte);
 {Vlozenie na zaciatok. Vstup volba rozhoduje ktora fronta sa pouzije}
var temp:dej_ukaz;      {1 - fronta DEJ ; 2 - fronta POM}
begin
 new(temp);
 with temp^ do begin
  cas:=casl;cislo:=por;
 end;
 case volba of
 1:begin temp^.dalsi:=dej_vrchol;
         dej_vrchol:=temp;
         temp:=NIL;
         {kv_dej}{vypis vrcholu zasobnika}
   end;
 2:begin temp^.dalsi:=pom_vrchol;
         pom_vrchol:=temp;
         temp:=NIL;
   end;
 end;
end;

procedure hodnoty(volba:byte);
 {vypisanie hodnot fronty. Volba urci frontu:1 - DEJ; 2 - POM}
var temp:dej_ukaz;
    poc:word;
begin
 poc:=1;
 if volba=1 then temp:=dej_vrchol else temp:=pom_vrchol;
 if temp=NIL then begin
  textcolor(12);writeln('Zoznam je prazdny');textcolor(7);
 end else
  while temp<>NIL do begin
   writeln(poc,'. cislo:',temp^.cislo,' <> cas:',temp^.cas);
   temp:=temp^.dalsi;inc(poc);
  end;
end;

procedure vloz_vlak(cislol:longint;vmaxl,vakt,vpom:byte);
 {vlozenie vlaku do fronty VLAK na zaciatok}
var temp:vlak_ukaz;
begin
 new(temp);
 with temp^ do begin
  cislo:=cislol;vmax:=vmaxl;va:=vakt;vp:=vpom;
  dalsi:=vlak_vrchol;
 end;
 vlak_vrchol:=temp;
 temp:=NIL;
 {kv_vlak}{vypis vrcholu zasobnika}
end;

procedure kv_dej;
   {vypise vrchol zasobnika}
var a:shortint;
    b:longint;
begin
 setfillstyle(0,0);
 bar(2,30,230,45);setcolor(15);
 a:=slpoz[dej_vrchol^.cislo].nst;b:=slpoz[dej_vrchol^.cislo].x;
 outtextxy(2,30,'vrchol: '+sti(dej_vrchol^.cas,7,0)+','+sti(a,2,0)+','+sti(pozicia[b].vlak,5,0));
end;

end.