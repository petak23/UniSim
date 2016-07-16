unit sprites;
interface

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ D E K L A R A C I E ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

procedure prvky(chu_prvky:word;kod:byte);
   {vykresli prvok podla charakteristiky}
procedure oodkazy(xz:word);
   {Vykreslenie policok UO}
procedure krstav(chu_kresli:word);
   {na zaklade stavu v pozicii vzkresli prvok}
procedure kv_vlak;
   {vypise frontu vlak}
procedure kresli_nav(hore,dole:byte);
   {Vykresli kontrolu navestidla}
procedure uvod;
   {uvodna stranka}
procedure logo(x,y:word);
   {vykresli logo programu}
procedure kr_menu(index,zaskrt:byte);
   {vykresli menu a zaskrtne polozky}
procedure kr_info(x:word);
   {vypise info. o vybranych prvkoch}
procedure kr_infovlak(x:word);
   {vypise info. o vybranom vlaku}

implementation

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ Procedury a funkcie ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

uses deklar,graph,dos,menus,pomocny,crt,smerniky,show_pcx;

procedure prvky(chu_prvky:word;kod:byte);
{vykresli prvok podla charakteristiky}
label zaciatok;
var a:array[1..4,1..3]of byte;
    xxs,yys,b:integer;
    i,j:word;
    kr2x,kr2y,fa:byte;
    ppom:longint;

begin
if pozicia[chu_prvky]=NIL then begin
  writeln('Chyba programu. Stav je v subore pomoc.txt');
  writeln(pomoc,'Vstup chu_prvky=',chu_prvky,' Fa:',fa,' kod:',kod);
  writeln(pomoc,'Fronta DEJ');hodnoty(1);writeln(pomoc,'Fronta POM');hodnoty(2);
  writeln(pomoc,'Fronta vlak');hodnoty(3);readln;halt(1);
 end;
i:=0;j:=0;
kr2x:=krokx shr 1;kr2y:=kroky shr 1;
xxs:=relx+sux(chu_prvky)*krokx-kr2x;
yys:=rely+suy(chu_prvky)*kroky-kr2y;
with pozicia[chu_prvky]^ do begin
case ch[1] of
 'U','M':case ch[2] of
          'B','O','U':b:=1;
          else b:=0;
         end;
 'K':if ch[2]='B' then b:=1 else b:=0;
 'V':case ch[2] of
      'N':b:=2;
      'K':b:=4;
      else b:=0;
     end;
 else b:=0;
end;
if b>0 then begin
 for j:=1 to 4 do for i:=1 to 3 do a[j,i]:=0;
 for i:=1 to b do begin
  ppom:=c[i] and 4095;
  a[i,1]:=ppom shr 8;
  a[i,2]:=(ppom shr 4) and 15;
  a[i,3]:=ppom and 15;
 end;
end;
case ch[1] of
{ --- USEKY --- }
 'U','M':begin case stav of            
                0:setcolor(8);{volny}
                1:setcolor(15);{posun-zaver}
                2:setcolor(2);{vlak-zaver}
                3:setcolor(12);{obsadeny}
                4:setcolor(14);{porucha}
               end;
         case ch[2] of
     'B':begin { USEK }
          moveto(xxs+kr2x*dx[a[1,1]],yys+kr2y*dy[a[1,1]]);
          linerel(kr2x*(dx[a[1,2]]-dx[a[1,1]]),kr2y*(dy[a[1,2]]-dy[a[1,1]]));
          linerel(kr2x*(dx[a[1,3]]-dx[a[1,2]]),kr2y*(dy[a[1,3]]-dy[a[1,2]]));
          b:=(sm and 240) shr 4; {vykreslenie zastavky}
          if b>0 then begin
           setcolor(6);kr2x:=kr2x shr 1;kr2y:=kr2y shr 1;
           moveto(xxs+kr2x*(dx[a[1,1]]+dx[b]),yys+kr2y*(dy[a[1,1]]+dy[b]));
           linerel(kr2x*(dx[a[1,2]]-dx[a[1,1]]),kr2y*(dy[a[1,2]]-dy[a[1,1]]));
           linerel(kr2x*(dx[a[1,3]]-dx[a[1,2]]),kr2y*(dy[a[1,3]]-dy[a[1,2]]));
          end;
         end;
     'O':begin   { USEK ODKAZ }
          moveto(xxs+kr2x*dx[a[1,1]],yys+kr2y*dy[a[1,1]]);
          linerel(kr2x*(dx[a[1,2]]-dx[a[1,1]]),kr2y*(dy[a[1,2]]-dy[a[1,1]]));
          linerel(kr2x*(dx[a[1,3]]-dx[a[1,2]]),kr2y*(dy[a[1,3]]-dy[a[1,2]]));
         end;
     'U':begin   { KUSA KOLAJ }
          setcolor(8);moveto(xxs,yys);
          linerel(kr2x*dx[a[1,3]],kr2y*dy[a[1,3]]);
          moverel(-1*kr2x*dx[a[1,3]],-1*kr2y*dy[a[1,3]]);
          case a[1,3] of
           1,9:begin linerel(2-kr2x,2-kr2y);linerel(kr2x+1,kr2y+1);end;
           2,8:begin linerel(2-kr2x,0);linerel(kr2x+1,0);end;
           3,7:begin linerel(2-kr2x,kr2y-2);linerel(kr2x+1,-kr2y-1);end;
           4,6:begin linerel(0,2-kr2y);linerel(0,kr2y+1);end;
          end;end;
     'A':begin { AUTOBLOK }
          moveto(xxs-kr2x+1,yys);linerel(krokx-2,0);{usek}
          b:=2;   {zakl. stav zelena na AB}
          if stav=3 then b:=12 else case c[2] of
                                     0:b:=2;
                                     1..100:b:=14;
                                    end;
          setcolor(b);
          if sm and 4=4 then setcolor(0);
          case sm and 3 of {navestidlo AB}
           1:case c[1] of
              0,1:rectangle(xxs-5,yys+2,xxs-4,yys+3);
                2:rectangle(xxs-5,yys-2,xxs-4,yys-3);
             end;
           2:case c[1] of
              0,2:rectangle(xxs+5,yys-2,xxs+4,yys-3);
                1:rectangle(xxs+5,yys+2,xxs+4,yys+3);
             end;
          end;
          b:=(sm and 240) shr 4;    {vykreslenie zastavky}
          if b>0 then begin
           setcolor(6);
           moveto(xxs-kr2x+3,yys+(kr2y shr 1)*dy[b]);linerel(krokx-6,0);
          end;
         end;
     'R':begin { PREDZVEST}
          moveto(xxs-kr2x+1,yys);linerel(krokx-2,0);
          b:=(sm and 240) shr 4; {zastavka}
          if b>0 then begin
           setcolor(6);
           moveto(xxs-kr2x+3,yys+(kr2y shr 1)*dy[b]);
           linerel(krokx-6,0);
          end;
         end;
     'K':begin { KRIZOVANIE }
          for i:=1 to 2 do begin
           moveto(xxs+kr2x*dx[a[i,1]],yys+kr2y*dy[a[i,1]]);
           linerel(kr2x*(dx[a[i,2]]-dx[a[i,1]]),kr2y*(dy[a[i,2]]-dy[a[i,1]]));
           linerel(kr2x*(dx[a[i,3]]-dx[a[i,2]]),kr2y*(dy[a[i,3]]-dy[a[i,2]]));
          end;
         end;
     'P':begin   { PRIECESTIE }
          setfillstyle(1,0);bar(xxs-kr2x+1,yys-kr2y+1,xxs+kr2x-1,yys+kr2y-1);
          if sm and 24>0 then begin {uzavrete}
           moveto(xxs-kr2x,yys);linerel(krokx,0);setcolor(8);
           moveto(xxs-2,yys-kr2y+1);linerel(0,2);linerel(kr2x-1,0);linerel(0,-2);
           moveto(xxs-2,yys+kr2y-1);linerel(0,-2);linerel(kr2x-1,0);linerel(0,2);
          end else begin {otvorene}
           moveto(xxs-kr2x,yys);linerel(1,0);moverel(krokx-2,0);linerel(1,0);
           setcolor(8);moveto(xxs-2,yys-kr2y+1);linerel(0,kroky-2);
           moveto(xxs+2,yys-kr2y+1);linerel(0,kroky-2);
          end;
         end;
     'Z':begin     {MIESTO ZJAVENIA}
          setcolor(7);settextjustify(lefttext,centertext);
          case n[1] of
           0:{<>}outtextxy(xxs-3,yys-3,'ุ');
           1,2:case sm of
                1:{>}outtextxy(xxs-3,yys-3,'ู');
                2:{<}outtextxy(xxs-3,yys-3,'ฺ');
               end;
          end;
          settextjustify(lefttext,toptext);
         end;
     end;
     end;
{ --- USEKY PRE KONIEC VL. CESTY ---}
 'K':case ch[2] of
       'B':begin case stav and $F of   { USEK }
                  0:setcolor(7);{volny}
                  1:setcolor(15);{posun-zaver}
                  2:setcolor(2);{vlak-zaver}
                  3:setcolor(12);{obsadeny}
                  4:setcolor(14);{porucha}
                 end;
            moveto(xxs+kr2x*dx[a[1,1]],yys+kr2y*dy[a[1,1]]);
            linerel(kr2x*(dx[a[1,2]]-dx[a[1,1]]),kr2y*(dy[a[1,2]]-dy[a[1,1]]));
            linerel(kr2x*(dx[a[1,3]]-dx[a[1,2]]),kr2y*(dy[a[1,3]]-dy[a[1,2]]));
           end;
       'S':begin                 {STANICNA KOLAJ }
            setfillstyle(1,0);setcolor(6);setlinestyle(0,0,1);
            new(ss);if kod=0 then ss^:=sti(n[1],5,0) else ss^:=sti(c[4],5,0);
            b:=length(ss^);if ss^='0' then b:=0;
            i:=10*(c[1] shr 4);j:=10*(c[1] and 15);
            bar(xxs-15-i,yys-kr2y+2,xxs+15+j,yys-2+kr2y);
            if pozicia[chu_prvky]^.sm and 1=1 then begin {nastupiste}
             moveto(xxs-krokx-kr2x,yys+kr2y);linerel(3*krokx,0);
             moverel(-3*krokx,1);linerel(3*krokx,0);end;
            if pozicia[chu_prvky]^.sm and 2=2 then begin
             moveto(xxs-krokx-kr2x,yys-kr2y);linerel(3*krokx,0);
             moverel(-3*krokx,1);linerel(3*krokx,0);end;
            case stav and $F of
             0:a[1,1]:=8;{volny}
             1:a[1,1]:=15;{posun-zaver}
             2:a[1,1]:=2;{vlak-zaver}
             3:a[1,1]:=12;{obsadeny}
             4:a[1,1]:=14;{porucha}
            end;
            setcolor(a[1,1]);fa:=a[1,1];
            case y of
             1:begin setfillstyle(1,4);fa:=14;end;{stoji a nema}
             2:begin setfillstyle(1,4);fa:=0;end; {stoji a ma>3}
             3:begin setfillstyle(1,9);fa:=14;end; {1 min do odchodu}
            end;
            if y>0 then bar(xxs-b*3,yys-kr2y+2,xxs+b*3-1,yys+kr2y-2);
            if b=0 then begin moveto(xxs-15-i,yys);lineto(xxs+15+j,yys);end
            else begin
             if (b<5) or (i>0) then begin moveto(xxs-15-i,yys);lineto(xxs-b*3-2,yys);end;
             if (b<5) or (j>0) then begin moveto(xxs+15+j,yys);lineto(xxs+b*3+2,yys);end;
             setcolor(fa);settextjustify(centertext,centertext);
             outtextxy(xxs,yys-2,ss^);settextjustify(lefttext,toptext);
            end;
            dispose(ss);
           end;
     end;
{ --- NAVESTIDLA --- }
 'N':case ch[2] of
      'H':begin{Navestidlo vchodove}
           settextjustify(centertext,centertext);
           case kod of
            0,5:begin {STOJ 0=Zakl. stav 5=rusenie cesty}
                 setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                 if sm and 4=4 then begin {predzvest}
                  setcolor(14);
                  case sm and 3 of 1:{>}b:=1;2:{<}b:=9;end;
                  rectangle(xxs+dx[b]*13,yys+dy[b]*2,xxs+dx[b]*12,yys+dy[b]*3);
                 end;
                 if kod=5 then begin
                  setcolor(4);rectangle(xxs-4,yys-4,xxs+4,yys+4);
                  setcolor(13);outtextxy(xxs,yys-2,sti(y,1,0));
                 end;
                end;
              6:begin {nulovanie po ruseni cesty}
                 setfillstyle(0,0);bar(xxs-4,yys-4,xxs+4,yys+4);setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                end;
            1,2:begin {Volba 1=vlakova  2=posunova cesta}
                 if kod=1 then setcolor(2) else setcolor(1);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                end;
          11,12:begin {rozsvietene nav. 11=Volno 12=Posun}
                 if kod=11 then setcolor(2) else setcolor(15);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                 if sm and 4=4 then begin {predzvest}
                  case sm and 3 of 1:{>}b:=1;2:{<}b:=9;end;
                  rectangle(xxs+dx[b]*13,yys+dy[b]*2,xxs+dx[b]*12,yys+dy[b]*3);
                 end;
                end;
           end;
           settextjustify(lefttext,toptext);
          end;
      'D':begin{Navestidlo odchodove a cestovne}
           settextjustify(centertext,centertext);
           case kod of
            0,5:begin {STOJ 0=Zakl. stav 5=rusenie cesty}
                 setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                 if kod=5 then begin
                  setcolor(4);rectangle(xxs-4,yys-4,xxs+4,yys+4);
                  setcolor(13);outtextxy(xxs,yys-2,sti(y,1,0));
                 end;
                end;
              6:begin {nulovanie po ruseni cesty}
                 setfillstyle(0,0);bar(xxs-4,yys-4,xxs+4,yys+4);setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                end;
            1,2:begin {Volba 1=vlakova  2=posunova cesta}
                 if kod=1 then setcolor(2) else setcolor(1);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                end;
          11,12:begin {rozsvietene nav. 11=Volno 12=Posun}
                 if kod=11 then setcolor(2) else setcolor(15);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(241+(sm and 3)));
                end;
           end;
           settextjustify(lefttext,toptext);
          end;
     'E','K':{Navestidlo posunovacie 'E' a "koncove"-zakl. nav STOJ 'K'}
          begin settextjustify(centertext,centertext);
           case kod of
            0,5:begin {STOJ 0=Zakl. stav 5=rusenie cesty}
                 setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                 if kod=5 then begin
                  setcolor(4);rectangle(xxs-4,yys-4,xxs+4,yys+4);
                  setcolor(13);outtextxy(xxs,yys-2,sti(y,1,0));
                 end;
                end;
              6:begin {nulovanie po ruseni cesty}
                 setfillstyle(0,0);bar(xxs-4,yys-4,xxs+4,yys+4);setcolor(8);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                end;
              2:begin {Volba posunova cesta}
                 setcolor(1);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                end;
             12:begin {rozsvietene nav. Posun}
                 setcolor(15);
                 if sm and 3 in [1..2] then
                  outtextxy(xxs-3,yys-2,chr(243+(sm and 3)));
                end;
           end;
           settextjustify(lefttext,toptext);
          end;
     end;
{ --- VYHYBKY --- }
 'V':begin
     case stav of
      0:fa:=7;{volny}
      1:fa:=15;{posun-zaver}
      2:fa:=2;{vlak-zaver}
      3:fa:=12;{obsadeny}
      4:fa:=14;{porucha}
     end;
     case ch[2] of
      'N':begin setcolor(1);
           i:=3-sm;
           moveto(xxs+kr2x*dx[a[i,1]],yys+kr2y*dy[a[i,1]]);
           lineto(xxs+kr2x*dx[a[i,2]],yys+kr2y*dy[a[i,2]]);
           lineto(xxs+kr2x*dx[a[i,3]],yys+kr2y*dy[a[i,3]]);
           if kod=0 then setcolor(8) else setcolor(fa);
           moveto(xxs+kr2x*dx[a[sm,1]],yys+kr2y*dy[a[sm,1]]);
           lineto(xxs+kr2x*dx[a[sm,2]],yys+kr2y*dy[a[sm,2]]);
           lineto(xxs+kr2x*dx[a[sm,3]],yys+kr2y*dy[a[sm,3]]);
          end;
      'K':begin setcolor(1);
           b:=(sm and 3);i:=3-b;
           moveto(xxs+kr2x*dx[a[i,1]],yys+kr2y*dy[a[i,1]]);
           lineto(xxs+kr2x*dx[a[i,2]],yys+kr2y*dy[a[i,2]]);
           lineto(xxs+kr2x*dx[a[i,3]],yys+kr2y*dy[a[i,3]]);
           if kod=0 then setcolor(8) else setcolor(fa);
           if (sm and 16=16)or(kod=0) then begin
            moveto(xxs+kr2x*dx[a[b,1]],yys+kr2y*dy[a[b,1]]);
            lineto(xxs+kr2x*dx[a[b,2]],yys+kr2y*dy[a[b,2]]);
            lineto(xxs+kr2x*dx[a[b,3]],yys+kr2y*dy[a[b,3]]);
           end;
           b:=((sm shr 2) and 3);i:=5-b;b:=b+2;setcolor(1);
           moveto(xxs+kr2x*dx[a[i,1]],yys+kr2y*dy[a[i,1]]);
           lineto(xxs+kr2x*dx[a[i,2]],yys+kr2y*dy[a[i,2]]);
           lineto(xxs+kr2x*dx[a[i,3]],yys+kr2y*dy[a[i,3]]);
           if kod=0 then setcolor(8) else setcolor(fa);
           if (sm and 32=32)or(kod=0) then begin
            moveto(xxs+kr2x*dx[a[b,1]],yys+kr2y*dy[a[b,1]]);
            lineto(xxs+kr2x*dx[a[b,2]],yys+kr2y*dy[a[b,2]]);
            lineto(xxs+kr2x*dx[a[b,3]],yys+kr2y*dy[a[b,3]]);
           end;
          end;
     end;
     end;
{ --- ZADAVACIA BUNKA ---}
 'Z':begin
      setcolor(1);
      case sm and 1 of
       0:begin
          setfillstyle(0,0);b:=sm shr 1; {b-pocet riadkov}
          bar(xxs-kr2x,yys-kr2y+1,xxs+krokx*2+kr2x,yys+kroky*b+kr2y-1);
          rectangle(xxs-kr2x,yys-kr2y+1,xxs+krokx*2+kr2x,yys+kroky*b+kr2y-1);
          setcolor(11);
          settextjustify(righttext,centertext);
          if kod=0 then begin
           for i:=0 to b do
            if c[i+1]>0 then
             outtextxy(xxs+krokx*2+kr2x,yys-2+i*(kroky-1),sti(c[i+1],5,0));
          end else begin
            outtextxy(xxs+krokx*2+kr2x,yys-1,sti(c[4],5,0));
            settextjustify(centertext,centertext);
            outtextxy(xxs+krokx,yys+kroky-2,'?');
            setcolor(2);outtextxy(xxs,yys+kroky-2,'A');
            setcolor(4);outtextxy(xxs+krokx*2,yys+kroky-2,'N');
          end;
         end;
       1:begin
          setfillstyle(0,0);b:=sm shr 1; {b-pocet riadkov}
          bar(xxs-kr2x,yys-kroky*b-kr2y,xxs+krokx*2+kr2x,yys+kr2y-1);
          rectangle(xxs-kr2x,yys-kroky*b-kr2y,xxs+krokx*2+kr2x,yys+kr2y-1);
          setcolor(11);
          settextjustify(righttext,centertext);
          if kod=0 then begin
           for i:=0 to b do
            if c[i+1]>0 then
             outtextxy(xxs+krokx*2+kr2x,yys-2-i*(kroky-1),sti(c[i+1],5,0));
          end else begin
            outtextxy(xxs+krokx*2+kr2x,yys-kroky-1,sti(c[4],5,0));
            settextjustify(centertext,centertext);
            outtextxy(xxs+krokx,yys-3,'?');
            setcolor(2);outtextxy(xxs,yys-3,'A');
            setcolor(4);outtextxy(xxs+krokx*2,yys-3,'N');
          end;
         end;
      end;
      settextjustify(lefttext,toptext);
     end;
{ --- TRATOVY SUHLAS --- }
 'T':begin
      setfillstyle(0,0);
      if n[2]=1 then setcolor(2)
      else begin setcolor(0);setfillstyle(1,8);end;{zakl.stav}
      if c[3]>0 then setcolor(4);           {obsadeny}
      if dl>0 then setcolor(12);            {blokovany}
      if stav and 4=4 then setcolor(1);     {zmena smeru na AB}
      bar(xxs-4,yys-4,xxs+4,yys+4);
      settextjustify(LeftText,CenterText);
      case stav and 3 of
       1:{>}outtextxy(xxs-3,yys-2,'ฏ');
       2:{<}outtextxy(xxs-3,yys-2,'ฎ');
      end;
      settextjustify(LeftText,TopText);
     end;
{ --- STANICNA BUDOVA --- }
 'S':begin
      setcolor(6);setfillstyle(1,8);
      case sm of
       1:begin bar(xxs-3,yys-3,xxs+3,yys+1);rectangle(xxs-5,yys-5,xxs+5,yys+3);end;
       2:begin bar(xxs-3,yys-1,xxs+3,yys+3);rectangle(xxs-5,yys-3,xxs+5,yys+5);end;
      end;
     end;
 end;
end;
end;

procedure oodkazy(xz:word);
 {Vykreslenie policok UO}
var i:word;
begin
 for i:=xmin to ((ymax-ymin)*xmax) do
  if (pozicia[i]<>NIL)and(pozicia[i]^.ch[2]='O') then begin
   with pozicia[i]^ do if xz=n[sm] then stav:=pozicia[xz]^.stav;
   krstav(i);
  end;
end;


procedure krstav(chu_kresli:word);
  {na zaklade stavu v pozicii vykresli prvok}
begin
 case pozicia[chu_kresli]^.stav and $F of
 -1,0:{nedef,volny}prvky(chu_kresli,0);
  1:{posun}prvky(chu_kresli,12);
  2:{vlak} prvky(chu_kresli,11);
  3:{obasd}prvky(chu_kresli,13);
 end;
 with pozicia[chu_kresli]^ do
  if (odk>0)and(ch[2]<>'O') then
   if (ch[1]='V') then begin
    if (sm and odk=odk) then oodkazy(chu_kresli);
   end else oodkazy(chu_kresli);
end;

procedure kv_vlak;
const ods:byte=9;
   {vypise frontu vlak}
var ri,si:word;
    temp:vlak_ukaz;
begin
 setfillstyle(1,8);
 bar(251,1,629,79);setcolor(5);line(377,0,377,80);line(503,0,503,80);
 temp:=vlak_vrchol;ri:=1;si:=0;
 if temp=NIL then exit;
 new(txt);reset(svlak);
 while (temp<>NIL)and(ri*si+1<>riadky*stlpce) do begin
  seek(svlak,temp^.poz);read(svlak,vlak);{najdenie vlaku co sa ma vypisat}
  reset(strsu);ca:=false;{najdenie skratky}
  while not(eof(strsu)) and (not ca) do begin
   read(strsu,txt^);
   if txt^.xs=pozicia[vlak.mo]^.n[2] then ca:=true;
  end;
  setcolor(15);outtextxy(255+si*126,ri*ods-8,typ_vlaku(temp^.cislo));
  setcolor(10);outtextxy(336+si*126,ri*ods-8,txt^.skr);
  settextjustify(righttext,toptext);
  setcolor(14);outtextxy(311+si*126,ri*ods-8,sti(temp^.cislo,5,0)+',');
               outtextxy(335+si*126,ri*ods-8,sti(vlak.dl*10,3,0)+',');
  setcolor(11);outtextxy(372+si*126,ri*ods-8,sti((temp^.vmax div 10),3,0));
  settextjustify(lefttext,toptext);
  temp:=temp^.dalsi;inc(ri);
  if ri=riadky then begin ri:=1;inc(si);end;
 end;
 dispose(txt);
end;

procedure kresli_nav(hore,dole:byte);
var i:byte;
begin
setfillstyle(1,8);bar(217,0,247,91);
if okno_nav.cisn>0 then begin
 settextjustify(centertext,toptext);
 setcolor(15);outtextxy(232,79,sti(okno_nav.cisn,4,0));
 settextjustify(lefttext,toptext);
end;
setcolor(0);line(217,80,247,80);
moveto(229,09);lineto(235,09);lineto(239,12);lineto(239,57);
lineto(235,60);lineto(229,60);lineto(225,57);lineto(225,12);
lineto(229,09);setfillstyle(1,0);floodfill(227,20,0);
setfillstyle(1,7);bar(230,61,234,79);setcolor(8);
setcolor(14);
case dole of
 40:outtextxy(229,39,'๗');
 60:begin outtextxy(229,39,'๗');bar(226,53,238,54);end;
 80:begin outtextxy(229,39,'๗');setfillstyle(1,2);bar(226,53,238,54);end;
 100:begin outtextxy(229,39,'๗');
          setfillstyle(1,2);bar(226,53,238,54);bar(226,56,238,57);end;
end;
case hore of
  0:begin setcolor(14);outtextxy(229,7,'๗');end;
  1:begin setcolor(4);outtextxy(229,23,'๗');end;
  39:begin setcolor(15);outtextxy(229,31,'๗');end;{posun}
  40..254:begin end;
  255:begin setcolor(2);outtextxy(229,15,'๗');end;
end;
end;

procedure uvod;
type
  RGBRec = record
    RedVal, GreenVal, BlueVal : Integer;{ Intenzita hodnota od 0 do 63 }
  end;
const
  EGAColors : array[0..15] of RGBRec = (
   ( RedVal:00;GreenVal:00;BlueVal:00{;Name:'Black';        ColorNum:00}),
   ( RedVal:00;GreenVal:00;BlueVal:40{;Name:'Blue';         ColorNum:01}),
   ( RedVal:00;GreenVal:40;BlueVal:00{;Name:'Green';        ColorNum:02}),
   ( RedVal:00;GreenVal:40;BlueVal:40{;Name:'Cyan';         ColorNum:03}),
   ( RedVal:40;GreenVal:07;BlueVal:07{;Name:'Red';          ColorNum:04}),
   ( RedVal:40;GreenVal:00;BlueVal:40{;Name:'Magenta';      ColorNum:05}),
   ( RedVal:40;GreenVal:30;BlueVal:00{;Name:'Brown';        ColorNum:20}),
   ( RedVal:49;GreenVal:49;BlueVal:49{;Name:'Light Gray';   ColorNum:07}),
   ( RedVal:26;GreenVal:26;BlueVal:26{;Name:'Dark Gray';    ColorNum:56}),
   ( RedVal:00;GreenVal:00;BlueVal:63{;Name:'Light Blue';   ColorNum:57}),
   ( RedVal:90;GreenVal:63;BlueVal:09{;Name:'Light Green';  ColorNum:58}),
   ( RedVal:00;GreenVal:63;BlueVal:63{;Name:'Light Cyan';   ColorNum:59}),
   ( RedVal:63;GreenVal:10;BlueVal:10{;Name:'Light Red';    ColorNum:60}),
   ( RedVal:44;GreenVal:00;BlueVal:63{;Name:'Light Magenta';ColorNum:61}),
   ( RedVal:63;GreenVal:63;BlueVal:18{;Name:'Yellow';       ColorNum:62}),
   ( RedVal:63;GreenVal:63;BlueVal:63{;Name:'White';        ColorNum:63}));
  colnum:array[0..15] of byte=(0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
begin
cleardevice;
for i:=0 to 15 do setRGBpalette(colnum[i],0,0,0);
 setRGBpalette(2,0,0,60);
setcolor(2);outtextxy(0,468,'Nahr vam ...');
read_pcx('100.pcx');
setfillstyle(1,3);bar(400,10,630,60);rectangle(401,11,629,59);
settextstyle(2,0,4);setcolor(11);outtextxy(406,13,'UniSiM v.1.2 - edit. 3 ๐ 05/2005');
outtextxy(406,25,'þ Ing. Peter VOJTECH ml. ๘');
outtextxy(406,37,'V็etky pr va vyhraden!');
setcolor(0);
moveto(611,15);linerel(3,-2);linerel(2,0);linerel(3,2);
linerel(0,15);linerel(-3,2);linerel(-2,0);linerel(-3,-2);linerel(0,-15);
setfillstyle(1,0);floodfill(614,20,0);
setfillstyle(1,9);bar(614,33,616,34);
setfillstyle(1,11);bar(614,34,616,37);
setfillstyle(1,15);bar(614,38,616,41);
setfillstyle(1,11);bar(614,42,616,45);
setfillstyle(1,15);bar(614,46,616,49);
setfillstyle(1,9);bar(614,50,616,55);
setcolor(7);line(614,19,616,19);line(614,21,616,21);
setcolor(8);line(614,20,616,20);line(615,19,615,21);
delay(4000);
for i:=0 to 15 do
with EGAColors[i] do SetRGBPalette(colnum[i], RedVal, GreenVal, BlueVal);
cleardevice;
end;

procedure logo(x,y:word);
   {vykresli logo programu} {x=420;y=440}
begin
 settextjustify(CenterText,TopText);
 settextstyle(2,0,4);
 setfillstyle(1,6);bar(x,y,x+210,y+30);
 setcolor(4);rectangle(x,y,x+209,y+29);
 setcolor(12);rectangle(x+1,y+1,x+210,y+30);
 setcolor(4);outtextxy(x+104,y,'þ  Ing. Peter Vojtech 2005');
 setcolor(1);outtextxy(x+105,y+1,'þ  Ing. Peter Vojtech 2005');
 settextstyle(0,0,1);
 setfillstyle(1,1);bar(x+45,y+14,x+100,y+25);
 setcolor(13);outtextxy(x+104,y+16,'UnIsiM  R     ');
              circle(x+116,y+19,6);
 setcolor(15);outtextxy(x+105,y+17,'UnIsiM  R     ');
              circle(x+117,y+20,6);
 setcolor(3);moveto(x+160,y+16);linerel(0,8);linerel(8,-8);linerel(9,0);
 linerel(-17,8);linerel(13,0);moverel(-4,-4);linerel(5,0);
 setcolor(15);moveto(x+161,y+17);linerel(0,8);linerel(8,-8);linerel(9,0);
 linerel(-17,8);linerel(13,0);moverel(-4,-4);linerel(5,0);
 settextjustify(LeftText,TopText);
end;

procedure kr_menu(index,zaskrt:byte);
   {vykresli menu a zaskrtne polozky}
var s:ssp;
    po:byte;
begin
if index=0 then begin {Vymazanie menu}
 setfillstyle(0,0);bar(55,1,119,79);
 setx(0,639);sety(0,479);setmousepos(mysx,mysy);cis_menu:=0;
end else begin        {vykreslenie menu}
 setfillstyle(1,1);bar(55,1,119,79);
 setcolor(7);line(57,13,117,13);setcolor(11);
 settextjustify(centertext,toptext);new(s);
 case index of {nazov menu}
  1:s^:='Navest';  {Pre rusenie,resp. obnovu navesti}
  2:s^:='Nudz.ru็';{Pre nudzove uvolnenie TS}
 end;
 outtextxy(87,0,s^);setcolor(14);setfillstyle(1,9);
 for po:=1 to 7 do begin
  case index of {polozky menu}
   1:case po of
      1:s^:='Rus cestu';
      2:s^:='Rus volbu';
      3:s^:='Dov. nav.';
      4..7:s^:='';
     end;
   2:case po of
      1:s^:='Uvolni';
      2..7:s^:='';
     end;
  end;
  if (s^<>'')and((zaskrt and (1 shl (po-1)))=(1 shl (po-1))) then
   bar(58,9*po+7,116,9*(po+1)+6);
  outtextxy(87,9*po+4,s^);
 end;
 cis_menu:=index;
 setmousepos(87,18);setX(58,116);setY(16,76);
 settextjustify(lefttext,toptext);
end;
end;

procedure kr_info(x:word);
{vypise info. o vybranych prvkoch}
var s:string;
begin
if x=0 then begin
 setfillstyle(0,0);bar(105,469,355,479);
 exit;
end;
setfillstyle(1,6);bar(105,469,355,479);settextjustify(lefttext,toptext);
setcolor(14);s:='';
if pozicia[x]^.ch[2]='O' then x:=pozicia[x]^.n[pozicia[x]^.sm];
with pozicia[x]^ do
 case pozicia[x]^.ch[2] of
  'B','R':if ch[1]<>'Z' then begin
           s:=ch[1]+ch[2]+'-'+sti(dl,4,0)+'m, '+sti(n[2],3,0)+'km/h [';
           if (ch[1]='M')and(sm>0) then s:=s+' Z';
           if n[1]>0 then s:=s+',PU ';
           outtextxy(107,467,s+']');
          end else outtextxy(107,467,'ZB-'+sti(sm shr 1,1,0));
  'P':begin
       s:=ch[1]+ch[2]+'-'+sti(dl,4,0)+'m, '+sti(n[2],3,0)+'km/h [';
       if c[4]>0 then s:=s+' Z';
       outtextxy(107,467,s+']');
      end;
  'A':begin
       s:='AB-'+sti(dl,4,0)+'m, '+sti(n[2],3,0)+'km/h [';
       if sm and 240>0 then s:=s+' Z';
       if n[1]>0 then s:=s+',PU';
       outtextxy(107,467,s+']');
      end;
  'S':if ch[1]='K' then begin
       s:=ch[1]+ch[2]+'-'+sti(n[1],3,0)+', '+sti(dl,4,0)+'m, '+sti(n[2],3,0)+'km/h [';
       if sm>0 then s:=s+' N';
       case y of
        1:s:=s+',!'+sti(pvlak,5,0);
        2:s:=s+', '+sti(pvlak,5,0);
        3:s:=s+',*'+sti(pvlak,5,0);
       end;
       outtextxy(107,467,s+']');
      end;
  'N','K':if ch[1]='V' then begin
           s:=ch[1]+ch[2]+'-'+sti(dl,4,0)+'m, '+sti(n[2],3,0)+'/'+sti(n[1],3,0)+'km/h';
           outtextxy(107,467,s);
          end;
  'Z':outtextxy(107,467,ch[1]+ch[2]+'-'+sti(dl,4,0)+'m{fi}');
  else outtextxy(107,467,'Nie je info.');
 end;
end;

procedure kr_infovlak(x:word);
{vypise info. o vybranom vlaku}
var s:string;
    vm,va,vp:byte;
    zlozenie:zloz_po;
    kus:kolaj_fr;

 procedure vlkr;
 begin
  if s<>'' then begin
   setfillstyle(1,6);bar(105,469,355,479);settextjustify(lefttext,toptext);
   setcolor(11);
   outtextxy(107,467,s);
  end;
 end;

begin
if x=0 then begin
 setfillstyle(0,0);bar(105,469,355,479);
 exit;
end;
s:='';
with pozicia[x]^ do
 case ch[1] of
  'K':case ch[2] of
       'S':begin
            if viac=nil then begin
             if c[4]>0 then begin
              najd_vlak(c[4],vm,va,vp);
              s:=chr(216+vlak.sm)++' '+typ_vlaku(vlak.cv1)+' '+sti(vlak.cv1,5,0)+'-';
              s:=s+sti(vm,3,0)+'/'+sti(va,3,0)+'km/h (';
              if c[3]=vlak.mz then begin
               s:=s+sti(vlak.casz div 60,2,0)+':';
               vm:=vlak.casz mod 60;
               case vm of
                0:s:=s+'00)';
                1..9:s:=s+'0'+sti(vm,1,0)+')';
                10..59:s:=s+sti(vm,2,0)+')';
               end;
              end else begin
               va:=0;
               repeat
                inc(va);
               until (vlak.stm[va]=c[3])and(va<mstan+1);
               if va>mstan then begin s:=s+'er:or)';
               end else begin
                s:=s+sti(vlak.stco[va] div 60,2,0)+':';
                vm:=vlak.stco[va] mod 60;
                case vm of
                 0:s:=s+'00)';
                 1..9:s:=s+'0'+sti(vm,1,0)+')';
                 10..59:s:=s+sti(vm,2,0)+')';
                end;
               end;
              end;
             end;
            end else begin
             zlozenie:=viac;
             kus:=zlozenie^[1];s:='';
             while kus<> NIL do begin
              case kus^.cislo shr 24 of
               1:s:=s+' ๏('+sti(kus^.cislo and $FFFFFF,5,0)+')';{Suprava}
               2:s:=s+' ๐('+sti(kus^.cislo and $FFFFFF,5,0)+')';{Lv}
              end;
              kus:=kus^.smer[2];
             end;
            end;
            vlkr;
           end;
       'B':if viac<>nil then begin
            zlozenie:=viac;
            kus:=zlozenie^[1];s:='';
            while kus<> NIL do begin
             case kus^.cislo shr 24 of
              2:s:=s+' ๐('+sti(kus^.cislo and $FFFFFF,5,0)+')';{Lv}
             end;
             kus:=kus^.smer[2];
            end;
            vlkr;
           end;
      end;
 end;
end;

end.