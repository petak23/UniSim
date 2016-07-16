program poprad2;
uses crt,dos,graph,menus,pomocny,deklar,sprites,smerniky;
var IntVec,intvec1:procedure;
    pauz:boolean;

{$F+}
procedure hodinky;interrupt;
var  h:word;
     zaloha:byte;
     FI: FillSettingsType;
begin
asm
 push BP
 push DS
end;
if pripocitaj then begin
 casre:=casre+18{11};
 stav:=stav or 1;pripocitaj:=false;
end else pripocitaj:=true;
if casre-hodiny.cas>99 then begin
 hodiny.cas:=casre;
 if stav and 4=0 then begin
  zaloha:=getcolor;getfillsettings(FI);
  setfillstyle(0,0);bar(1,1,49,11);
  h:=casre div 360000;casre:=casre mod 360000;
  if h<10 then hodiny.text:='0'+sti(h,1,0)+':' else hodiny.text:=sti(h,2,0)+':';
  h:=casre div 6000;casre:=casre mod 6000;
  if h<10 then hodiny.text:=hodiny.text+'0'+sti(h,1,0)+':' else hodiny.text:=hodiny.text+sti(h,2,0)+':';
  h:=casre div 100;
  if h<10 then hodiny.text:=hodiny.text+'0'+sti(h,1,0) else hodiny.text:=hodiny.text+sti(h,2,0);
  setcolor(14);casre:=hodiny.cas;
  outtextxy(3,0,hodiny.text);
  setcolor(zaloha);with FI do setfillstyle(Pattern, Color);
 end;
end;
asm
 pop DS
 pop BP
end;
Intvec;
end;
{$F-}
{$F+}
procedure klavesnica;interrupt;
var key1:word;
begin
asm
 push BP
 push DS
end;
 key1:=port[$60];
 if (key1<128)and(key=0) then
  begin key:=key1;stav:=stav or 8;end;
 case key1 of
  29:begin stavkl:=stavkl or 1;key:=0;stav:=stav and $F7;end;    {Stisk Ctrl}
  56:begin stavkl:=stavkl or 2;key:=0;stav:=stav and $F7;end;    {Stisk Alt}
  42:begin stavkl:=stavkl or 4;key:=0;stav:=stav and $F7;end;    {Stisk Shift}
  157:begin stavkl:=stavkl and $FE;key:=0;stav:=stav and $F7;end;{Pustil Ctrl}
  184:begin stavkl:=stavkl and $FD;key:=0;stav:=stav and $F7;end;{Pustil Alt}
  170:begin stavkl:=stavkl and $FB;key:=0;stav:=stav and $F7;end;{Pustil Shift}
 end;
asm
 pop DS
 pop BP
end;
inline($9C);
Intvec1;
end;
{$F-}

procedure pauza;
begin
 if pauz then begin
  setfillstyle(1,0);bar(105,469,355,479);settextjustify(lefttext,toptext);
  delay(200);
  getintvec($1C,@IntVec);
  setintvec($1C,addr(hodinky));   {int. - cas}
  pauz:=false;
 end else begin
  setfillstyle(1,12);bar(105,469,355,479);settextjustify(lefttext,toptext);
  setcolor(14);
  outtextxy(107,467,'PAUZA');
  setintvec($1C,@IntVec);
  delay(200);pauz:=true;
 end;
end;

procedure error1(s1,s2:string);
begin
 setintvec($1C,@IntVec);
 setintvec($09,@IntVec1);
 writeln('Chyba programu. Stav je v subore pomoc.txt');
 writeln(pomoc,s1);
 writeln(pomoc,s2);
 writeln(pomoc,'Fronta DEJ');hodnoty(1);
 writeln(pomoc,'Fronta POM');hodnoty(2);
 writeln(pomoc,'Fronta vlak');hodnoty(3);
 readln;
 halt(1);
end;

procedure zapis(xz:word;cv:longint);
  {Zapise do zapisovacej bunky cislo vlaku na prvu volnu poziciu}
var pom:boolean;
    i:byte;
begin
 pom:=false;
 with pozicia[xz]^ do begin
  for i:=1 to 3 do if c[i]=cv then pom:=true;
  for i:=1 to 3 do
   if (c[i]=0)and(pom=false) then begin
    c[i]:=cv;pom:=true;end;
 end;
 if pozicia[xz]^.stav=0 then prvky(xz,0);
end;

procedure zmaz(xz:integer;cv:longint);
label er;
  {Zmaze zo zapisovacej bunky vlak (cv) a ostatne posunie}
  {ak cv=0 tak zmaze posledny}
var pom:boolean;
    i:byte;
begin
 if (xz<0)or(xz>(ymax-ymin)*xmax)or(pozicia[xz]=NIL) then
  error1('Error 004 - Nekorekty vstup xs - zmaz','Vstup xz='+sti(xz,5,0)+' Cislo vlaku ='+sti(cv,6,0));
 with pozicia[xz]^ do begin
  if cv>0 then begin
   if c[1]=cv then begin c[1]:=c[2];c[2]:=c[3];c[3]:=0;end;
   if c[2]=cv then begin c[2]:=c[3];c[3]:=0;end;
   if c[3]=cv then c[3]:=0;
  end else begin
   pom:=false;
   for i:=3 downto 1 do if (c[i]>0)and(not pom) then begin c[i]:=0;pom:=true;end;
  end;
  if c[4]=0 then prvky(xz,0);
 end;
end;

procedure rus_cesta(hx:word);
label koniec;
var cisvch:byte;
    typc,sm1,sm2:shortint;
    zac,zaold:word;
begin
 stav:= stav or 4;  {zakaz vypisu casu}
 zac:=hx;typc:=pozicia[hx]^.stav;
 with pozicia[hx]^ do begin
  if ch[2]='H' then typc:=-1*typc; {ak je vchod typ je <0}
  stav:=0;pvlak:=0;rych:=255;zaold:=c[4];end;
 prvky(hx,6);
 case pozicia[hx]^.sm and 3 of
  1:begin inc(zac);cisvch:=4;end;
  2:begin dec(zac);cisvch:=6;end;
 end;
 repeat;
 with pozicia[zac]^ do begin
  stav:=0;pvlak:=0;rych:=255;krstav(zac);  {zrusenie zaveru}
  case ch[2] of {Najdenie nasledujuceho prvku}
    'B','O':begin
             if c[1] shr 8=cisvch then k:=c[1] and 15 else k:=c[1] shr 8;
             zac:=zac+dx[k]+dy[k]*xmax;cisvch:=10-k;
            end;
    'H','D','E','K':
        if ch[1]<>'V' then
         case cisvch of
          4:zac:=c[sm and 3];
          6:zac:=c[3-(sm and 3)];
         end;
    'P':zac:=zac+dx[10-cisvch];
    'S':case cisvch of
         4:zac:=zac+(c[1] and 15)+2;
         6:zac:=zac-(c[1] shr 4)-2;
        end;
   end;
   if ch[1]='V' then
    case pozicia[zac]^.ch[2] of
      'N':begin
           k:=pozicia[zac]^.c[sm] and 4095; {Najdenie nasledujuceho}
           if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
           zac:=zac+dx[k]+dy[k]*xmax;cisvch:=10-k;
          end;
      'K':begin
           case pozicia[hx]^.sm and 3 of
            1:begin sm1:=sm and 3;if (sm and 16)<>16 then sm1:=0;
                    sm2:=(sm shr 2)and 3;if (sm and 32)<>32 then sm2:=0;end;
            2:begin sm1:=(sm shr 2)and 3;if (sm and 32)<>32 then sm1:=0;
                    sm2:=sm and 3;if (sm and 16)<>16 then sm2:=0;end;
           end;
           if sm1>0 then begin {cez tuto cast sa pojde}
            if pozicia[hx]^.sm and 3=2 then sm1:=sm1+2;
            k:=pozicia[zac]^.c[sm1] and 4095; {Najdenie nasledujuceho}
            if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
            cisvch:=10-k;
            if cisvch<>5 then zac:=zac+dx[k]+dy[k]*xmax;
           end;
           if sm2>0 then begin {cez tuto cast sa pojde 2}
            if pozicia[hx]^.sm and 3=1 then sm2:=sm2+2;
            k:=pozicia[zac]^.c[sm2] and 4095; {Najdenie nasledujuceho}
            if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
            cisvch:=10-k;zac:=zac+dx[k]+dy[k]*xmax;
           end;
          end;
    end;
  end;
until zac=zaold;
with pozicia[zac]^ do begin {zrusenie zaveru posledneho}
 if (typc<>5)or((typc=5)and(stav<>3)) then begin
  if (ch[2]='B')and(typc<>5) then zmaz(c[3],0);
  stav:=0;pvlak:=0;rych:=255;krstav(zac);
 end;
end;
if typc=5 then goto koniec; {vynechanie nasledujuceho pri posune}
if (pozicia[zac]^.ch[1]+pozicia[zac]^.ch[2]='KB')and
 (pozicia[zac]^.c[2]>0) then begin
  zac:=pozicia[zac]^.c[2];{uvolnenie TS}
  pozicia[zac]^.c[3]:=pozicia[zac]^.c[3] and 253;
  if pozicia[zac]^.c[3]=0 then prvky(zac,0);
end;
ca:=false;zac:=zaold;
repeat
 case pozicia[zac]^.ch[2] of
  'S':case pozicia[hx]^.sm and 3 of
       1:zac:=zac+(pozicia[zac]^.c[1] and 15)+2;
       2:zac:=zac-(pozicia[zac]^.c[1] shr 4)-2;
      end;
  'B':zac:=pozicia[pozicia[zac]^.c[3]]^.n[pozicia[hx]^.sm and 3];
 end;
 case pozicia[zac]^.ch[2] of
  'H','Z':zmaz(pozicia[zac]^.c[3],0);
  'D','K':begin pozicia[pozicia[zac]^.c[2]]^.c[4]:=0;
       krstav(pozicia[zac]^.c[2]);end;
 end;
 if pozicia[zac]^.stav=2 then begin
  if (pozicia[zac]^.ch[2]='H')and
   (pozicia[pozicia[zac]^.c[3]]^.c[1]<>vlak.cv1)and
   (pozicia[pozicia[zac]^.c[3]]^.c[1]>0)then ca:=true;
  zac:=pozicia[zac]^.c[4]
 end else ca:=true;
until ca;
koniec:
stav:= stav and 251;  {koniec zakazu vypisu casu}
end;

procedure kresli_cesta(cesta:pointer;pre_vlak:longint;vmax:byte);
{vykreslenie cesty}
type cesta_ukaz=^cesta_prvok;
     cesta_prvok=record
       polozka:word;
       dalsi:cesta_ukaz;
     end;
var temp,temp1:cesta_ukaz;
begin
 stav:=stav or 4;  {zakaz vypisu casu}
 temp:=cesta;
 while temp<>NIL do begin
  if vmax<255 then pozicia[temp^.polozka]^.rych:=vmax;
  krstav(temp^.polozka);
  temp1:=temp;
  temp:=temp^.dalsi;
  dispose(temp1);
  temp1:=NIL;
 end;
 stav:= stav and 251;  {koniec zakazu vypisu casu}
end;

procedure prenos_cisla(zaciatok,cislo:longint);
{prenesie "cislo" vlaku az na koniec postavenych vlak. ciest}
var zac:word;
    ca:boolean;
begin
 ca:=false;zac:=zaciatok;
 repeat
  zac:=pozicia[zac]^.c[4]; {kon.cesty}
  case pozicia[zac]^.ch[2] of {najd. najbl. nav.}
   'S':begin
        pozicia[zac]^.c[4]:=cislo;krstav(zac);
        case pozicia[zaciatok]^.sm and 3 of{najdenie najbl. nav.}
         1:zac:=zac+(pozicia[zac]^.c[1] and 15)+2;
         2:zac:=zac-(pozicia[zac]^.c[1] shr 4)-2;
        end;
       end;
   'B':begin
        zac:=pozicia[zac]^.c[3];{najdenie ZB}
        zapis(zac,cislo);
        if pozicia[zac]^.c[1]=cislo then
         zac:=pozicia[zac]^.n[pozicia[zaciatok]^.sm and 3]
        else ca:=true;
       end;
  end;
  if pozicia[zac]^.stav=2 then ca:=false else ca:=true;
 until ca;
end;


procedure test_cesty(chu_testz,chu_testk:word;var vm:byte);
label zas1;
type cesta_ukaz=^cesta_prvok;
     cesta_prvok=record
       polozka:word;
       dalsi:cesta_ukaz;
     end;
var zac,zaold,koold,i,cisvyh,nasl,nasl1:word;
    vmax,vyhpom,cisvch,sm1,sm2,v1:byte;
    ch:char;
    pre_vlak:longint;
    cesta_vrchol,temp:cesta_ukaz;

 procedure obsad;      {neuspesne postavenie cesty}
 begin
  while cesta_vrchol<>NIL do begin {vymazanie zaznamov v prvkoch cesty a fronte}
   with pozicia[cesta_vrchol^.polozka]^ do begin
    stav:=0;pvlak:=0;rych:=255;
    if ch[1]='K' then c[4]:=0;
   end;
   temp:=cesta_vrchol;cesta_vrchol:=temp^.dalsi;
   temp^.dalsi:=NIL;
   dispose(temp);
  end;
  temp:=NIL;
 end;

begin
stav:=stav or 4;  {zakaz vypisu casu}
case pozicia[chu_testz]^.ch[2] of {najdenie vlaku pre ktory je cesta}
 'H':pre_vlak:=pozicia[pozicia[chu_testz]^.c[3]]^.c[1];{vchod}
 'D':pre_vlak:=pozicia[pozicia[chu_testz]^.c[2]]^.c[4];{odchod}
 'E','K':pre_vlak:=0;{posun}
end;
pozicia[chu_testz]^.c[4]:=chu_testk; {zapisanie konca cesty}
vmax:=255;vyhpom:=1;zac:=chu_testz;cisvyh:=1;
zaold:=zac;koold:=chu_testk;{uchovanie zaciatku a konca cesty}
nasl1:=zaold;{poloha predosleho navestidla pri prechodoch}
reset(vlc);ca:=false;
while (not(eof(vlc))) and (not ca) do begin {najdenie vl. cesty, ktora sa stavia}
 read(vlc,vlakc);
 if (vlakc.zc=chu_testz)and(vlakc.kc=chu_testk)and(cha=vlakc.ch) then ca:=true;
end;
if not ca then exit; {nebola najdena cesta}
with pozicia[chu_zac]^ do begin {definovanie stavu navestidla - zac. cesty}
 stav:=vlakc.ch;rych:=255;dl:=255;
 if vlakc.ch=2 then c[4]:=chu_testk;
end;
new(cesta_vrchol);{vytvorenie fronty a vlozenie navestidla do nej}
cesta_vrchol^.polozka:=zac;cesta_vrchol^.dalsi:=NIL;
case pozicia[chu_testz]^.sm and 3 of{najdenie prveho useku}
 1:begin inc(zac);cisvch:=4;end;
 2:begin dec(zac);cisvch:=6;end;
end;
repeat;{zaciatok hlavnej hladacej slucky}
 with pozicia[zac]^ do begin
  case vlakc.ch of{test obsadenia useku}
   1:if (stav<>0)and(ch[2]<>'O')and(ch[1]<>'K') then begin obsad;exit;end;
   2:if (stav<>0)and(ch[2]<>'O')then begin obsad;exit;end;
  end;
  case ch[1] of {Zapisanie usekov do fronty}
   'U':case ch[2] of
        'B','P','U':begin
                     new(temp);temp^.polozka:=zac;temp^.dalsi:=cesta_vrchol;
                     cesta_vrchol:=temp;temp:=NIL;stav:=vlakc.ch;
                    end;
       end;
   'K':begin new(temp);temp^.polozka:=zac;temp^.dalsi:=cesta_vrchol;
             cesta_vrchol:=temp;temp:=NIL;
             if stav=0 then stav:=vlakc.ch {ak je volno napis stav}
             else stav:=stav or (vlakc.ch shl 4);{inak stav do bitov 4-7}
       end;
   'V':begin
        case vlakc.vyh[cisvyh] of
         2..4,6..10:begin vyhpom:=2;if vmax>n[1] then vmax:=n[1];end;
        end;
        stav:=vlakc.ch;new(temp);temp^.polozka:=zac;
        temp^.dalsi:=cesta_vrchol;cesta_vrchol:=temp;temp:=NIL;
       end;
  'N':if (ch[2]='D')and(sm=pozicia[nasl1]^.sm and 3) then begin
       pozicia[zaold]^.dl:=vmax;vmax:=255;
       c[4]:=koold;pozicia[nasl1]^.c[4]:=c[2];nasl1:=zac;{oprava konca cesty}
       stav:=vlakc.ch;new(temp);temp^.polozka:=zac;
       temp^.dalsi:=cesta_vrchol;cesta_vrchol:=temp;temp:=NIL;
      end;
  end;
 end;
 chu_testz:=zac;
 if chu_testz<>chu_testk then
  case pozicia[zac]^.ch[1] of {Najdenie nasledujuceho prvku}
   'U','K','N':
    case pozicia[zac]^.ch[2] of
     'B','O':begin k:=pozicia[zac]^.c[1];
              if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
              zac:=zac+dx[k]+dy[k]*xmax;cisvch:=10-k;
             end;
     'H','D','E','K':with pozicia[zac]^ do case cisvch of
                                            4:zac:=c[sm and 3];
                                            6:zac:=c[3-(sm and 3)];
                                           end;
     'P':zac:=zac+dx[10-cisvch];
     'S':with pozicia[zac]^ do begin
          c[4]:=pre_vlak;
          case cisvch of
           4:zac:=zac+(c[1] and 15)+2;
           6:zac:=zac-(c[1] shr 4)-2;
          end;
         end;
    end;
   'V':case pozicia[zac]^.ch[2] of
        'N':begin
             pomv:=pozicia[zac]^.c[vlakc.vyh[cisvyh]];
             v1:=(pomv shr 12) and 15;pomv:=pomv shr 16;
             if (pomv>0)and((pozicia[pomv]^.sm and v1)=0) then begin{je odvrat a ina cesta?}
              if pozicia[pomv]^.stav in [1..6] then begin obsad;exit;end
              else begin
               if v1>3 then pozicia[pomv]^.sm:=(pozicia[pomv]^.sm and 3) or v1
               else pozicia[pomv]^.sm:=(pozicia[pomv]^.sm and 12) or v1;
               prvky(pomv,0);
              end;
             end;
             pozicia[zac]^.sm:=vlakc.vyh[cisvyh];
             k:=pozicia[zac]^.c[vlakc.vyh[cisvyh]] and 4095; {Najdenie nasledujuceho}
             if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
             zac:=zac+dx[k]+dy[k]*xmax;cisvyh:=cisvyh+1;cisvch:=10-k;
            end;
        'K':begin
             case pozicia[zaold]^.sm and 3 of
              1:begin sm1:=vlakc.vyh[cisvyh] and 3;sm2:=(vlakc.vyh[cisvyh] shr 2) and 3;end;
              2:begin sm1:=(vlakc.vyh[cisvyh] shr 2) and 3;sm2:=vlakc.vyh[cisvyh] and 3;end;
             end;
             if sm1>0 then begin {cez tuto cast sa pojde}
              if pozicia[zaold]^.sm and 3=2 then sm1:=sm1+2;
              pomv:=pozicia[zac]^.c[sm1];{a zisti odvrat}
              v1:=(pomv shr 12) and 15;pomv:=pomv shr 16;
              if (pomv>0)and((pozicia[pomv]^.sm and v1)=0) then begin
               if pozicia[pomv]^.stav in [1..6] then begin obsad;exit;end
               else begin
                if v1<3 then pozicia[pomv]^.sm:=pozicia[pomv]^.sm and 252
                else pozicia[pomv]^.sm:=pozicia[pomv]^.sm and 243;
                pozicia[pomv]^.sm:=pozicia[pomv]^.sm or v1;
                prvky(pomv,0);
               end;
              end;
              with pozicia[zac]^ do {prestavenie vyhybky a zaver}
               if sm1<3 then sm:=(sm and 12) or (vlakc.vyh[cisvyh] and 3) or 16
               else sm:=(sm and 3) or (vlakc.vyh[cisvyh] and 12) or 32;
              k:=pozicia[zac]^.c[sm1] and 4095; {Najdenie nasledujuceho}
              if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
              cisvch:=10-k;if k<>5 then zac:=zac+dx[k]+dy[k]*xmax;
             end;
             if sm2>0 then begin {cez tuto cast sa pojde 2}
              if pozicia[zaold]^.sm and 3=1 then sm2:=sm2+2;
              pomv:=pozicia[zac]^.c[sm2];{a zisti odvrat}
              v1:=(pomv shr 12) and 15;pomv:=pomv shr 16;
              if (pomv>0)and((pozicia[pomv]^.sm and v1)=0) then begin
               if pozicia[pomv]^.stav in [1..6] then begin obsad;exit;end
               else begin
                if v1<3 then pozicia[pomv]^.sm:=pozicia[pomv]^.sm and 252
                else pozicia[pomv]^.sm:=pozicia[pomv]^.sm and 243;
                pozicia[pomv]^.sm:=pozicia[pomv]^.sm or v1;
                prvky(pomv,0);
               end;
              end;
              with pozicia[zac]^ do {prestavenie vyhybky a zaver}
               if sm2<3 then sm:=(sm and 60) or (vlakc.vyh[cisvyh] and 3) or 16
               else sm:=(sm and 51) or (vlakc.vyh[cisvyh] and 12) or 32;
              k:=pozicia[zac]^.c[sm2] and 4095; {Najdenie nasledujuceho}
              if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
              cisvch:=10-k;zac:=zac+dx[k]+dy[k]*xmax;
             end;
             cisvyh:=cisvyh+1;
            end;
       end;
   end;
until chu_testz=chu_testk;    {Koniec cesty}
if (pozicia[chu_testk]^.ch[2]='B')and(vlakc.ch=2) then begin
 k:=pozicia[chu_testk]^.c[1];     {najdenie nasledujuceho}
 if k shr 8=cisvch then k:=k and 15 else k:=k shr 8;
 nasl:=chu_testk+dx[k]+dy[k]*xmax;
 zas1:
 case pozicia[nasl]^.ch[1] of
  'M':if pozicia[nasl]^.ch[2]='O' then begin
       if pozicia[nasl]^.n[1]=chu_testk then nasl:=pozicia[chu_testk]^.n[2]
       else nasl:=pozicia[nasl]^.n[1];goto zas1;
      end else
       if pozicia[nasl]^.stav=3 then begin k:=1;obsad;exit;end;
  'U':if pozicia[nasl]^.ch[2]='O' then begin
       if pozicia[nasl]^.n[1]=chu_testk then begin nasl:=pozicia[chu_testk]^.n[2]
       end else nasl:=pozicia[nasl]^.n[1];goto zas1;
      end;
  'N':begin nasl:=nasl+dx[k]+dy[k]*xmax;goto zas1;end;
 end;
 chu_testk:=pozicia[chu_testk]^.c[2];chu_testz:=zaold;
 if pozicia[chu_testk]^.c[3]>0 then begin {TS obsadeny}
  if pozicia[chu_testk]^.stav=pozicia[chu_testz]^.sm then begin
   if pozicia[chu_testk]^.n[1]=0 then begin obsad;exit;end;{nie je to AB a TS je obsadeny}
  end else begin obsad;exit;end;{TS je obsadeny a opacneho smeru}
 end else {TS volny}
  if pozicia[chu_testk]^.stav<>(pozicia[chu_testz]^.sm and 3) then {TS ma opacny smer}
   if pozicia[chu_testk]^.n[1]=0 then begin {nie je to AB}
    if pozicia[chu_testk]^.stav=1 then begin
     pozicia[chu_testk]^.stav:=2;prvky(chu_testk,0);end
    else begin
     pozicia[chu_testk]^.stav:=1;prvky(chu_testk,0);end;
   end else begin obsad;exit;end; {je to AB a TS je volny ale opacny}
end;
pozicia[zaold]^.viac:=cesta_vrchol;{pre vykreslenie cesty}
if vlakc.ch=2 then begin
 vm:=vmax;pozicia[nasl1]^.dl:=vmax;
 if pre_vlak>0 then prenos_cisla(zaold,pre_vlak);{ak je to vlak.c prenos}
 if stav and 2=2 then begin {diagn. nav.}
  zac:=pozicia[zaold]^.c[4]; {kon.cesty}
  case pozicia[zac]^.ch[2] of {najd. najbl. nav.}
   'S':begin
        case pozicia[zaold]^.sm and 3 of
         1:zac:=zac+(pozicia[zac]^.c[1] and 15)+2;
         2:zac:=zac-(pozicia[zac]^.c[1] shr 4)-2;
        end;
        zac:=pozicia[zac]^.dl;
       end;
   'B':if pozicia[pozicia[zac]^.c[2]]^.n[1]>0 then begin {je to AB}
        if pozicia[nasl]^.c[2]=0 then zac:=255 else zac:=0;
       end else zac:=255; {nie je to AB}
  end;
  kresli_nav(zac,vmax);
 end;
 with pozicia[pozicia[zaold]^.c[4]]^ do rych:=n[2];
end else
begin
 vmax:=40;vm:=40;pozicia[zaold]^.dl:=40;
 if stav and 2=2 then kresli_nav(39,0);
end;
stav:= stav and 251;  {koniec zakazu vypisu casu}
end;

procedure moznosti0(j_i:word);
 {--- Uvolnenie medzistanicneho useku ---}
label end0;
var chu_mo:word;
    vmax,vakt,vpom:byte;
begin
chu_mo:=0;
with pozicia[slpoz[j_i].x]^ do begin
 stav:=0;pvlak:=0;rych:=255; {uvolni prvok pozicie}
 if ch[2]='P' then begin sm:=sm and $F7;{otvorenie PZS}
  if sm and 3>0 then begin
   case sm and 3 of{najdenie suseda}
    1:chu_mo:=slpoz[j_i].x-xmax;
    2:chu_mo:=slpoz[j_i].x+xmax;
   end;
   pozicia[chu_mo]^.sm:=pozicia[chu_mo]^.sm and $EF;{otvorenie suseda}
   if pozicia[chu_mo]^.sm and 24>0 then prvky(chu_mo,0);{vykreslenie suseda ak treba}
  end;
 end;
end;
krstav(slpoz[j_i].x);{vykreslenie uvolnenia}
if pozicia[slpoz[j_i].x]^.ch[2]='A' then begin
 chu_mo:=slpoz[j_i].x-3+2*(pozicia[slpoz[j_i].x]^.sm and 3);{najdenie predosleho}
 while pozicia[chu_mo]^.ch[2]<>'A'do {ak nie je AB znovu}
  case pozicia[chu_mo]^.ch[2] of
   'O':begin
        if pozicia[chu_mo]^.ch[1]<>'M' then goto end0;
        chu_mo:=pozicia[chu_mo]^.n[vlak.sm];
       end;
   'P':chu_mo:=chu_mo-3+2*(pozicia[slpoz[j_i].x]^.sm and 3);
   'Z','H','B':goto end0;
  end;
 with pozicia[chu_mo]^ do {S predoslim pracuj}
  case stav of
   0:begin c[2]:=c[2] and 254;krstav(chu_mo);end; {ak je volny rozsviet volno}
   3:begin {ak tam stoji vlak tak ho rozbehni}
      najd_vlak(pozicia[chu_mo]^.pvlak,vmax,vakt,vpom);
      if vakt=0 then begin
       if vmax>pozicia[chu_mo]^.n[2] then vpom:=pozicia[chu_mo]^.n[2] else vpom:=vmax;
       aktu_vlak(vlak.cv1,vmax,vakt,vpom);prepocet(caslong+70,vlak.cv1);
      end;
     end;
  end;
end;
end0:
chu_mo:=pozicia[slpoz[j_i].x]^.c[3];{najdi TS}
with pozicia[chu_mo]^ do c[3]:=c[3] and (255-moc(pozicia[slpoz[j_i].x]^.y));
if pozicia[chu_mo]^.c[3]=0 then krstav(chu_mo); {Uvolnenie TS}
with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
end;  {--- KONIEC - Uvolnenie medzistanicneho useku ---}

procedure moznosti1(j_i:word);
 {--- Uvolnenie MZ ---}
var chu_mo:word;
begin
zmaz(pozicia[slpoz[j_i].x]^.c[3],slpoz[j_i].y);
pr_body(slpoz[j_i].y,1);
zmaz_vlak(slpoz[j_i].y);kv_vlak;
with pozicia[slpoz[j_i].x]^ do begin
 stav:=0;pvlak:=0;rych:=255;c[2]:=0;chu_mo:=c[1];end;
with pozicia[chu_mo]^ do c[3]:=c[3] and (255-moc(pozicia[slpoz[j_i].x]^.y));
if pozicia[chu_mo]^.c[3]=0 then krstav(chu_mo); {uvolnenie TS}
with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
end;  {--- KONIEC - Uvolnenie MZ ---}

procedure moznosti2(j_i:word);
 {--- Uvolnenie useku v posunovej ceste ---}
begin
 with pozicia[slpoz[j_i].x]^ do begin
  stav:=stav shr 4;pvlak:=0;rych:=255;
  if ch[1]='K' then c[4]:=0;
 end;
 krstav(slpoz[j_i].x);
 with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
end;  {--- KONIEC - Uvolnenie useku v posunovej ceste ---}

procedure moznosti6(j_i:word);
 {--- Obsadenie useku vo vlakovej ceste ---}
var chu_mo,chu_mo1:word;
    vmax,vakt,vpom,cisvch,sm1,sm2:byte;
    l:integer;
begin
chu_mo:=0;chu_mo1:=0;
najd_vlak(slpoz[j_i].y,vmax,vakt,vpom);{najdenie vlaku}
if pozicia[slpoz[j_i].x]^.ch[1]='N' then begin  {Mam "obsadit" navestidlo}
 if pozicia[slpoz[j_i].x]^.stav=2 then begin {postavene nav.}
  with pozicia[slpoz[j_i].x]^ do begin
   stav:=0;pvlak:=0;rych:=255;c[4]:=0;dl:=0;end;
  krstav(slpoz[j_i].x);
  slpoz[j_i].x:=pozicia[slpoz[j_i].x]^.c[1];{Najdi nasledujuci}
 end else begin            {nav. na STOJ}
  pozicia[slpoz[j_i].x]^.pvlak:=slpoz[j_i].y;
  vlozm(slpoz[j_i].cas,j_i);aktu_vlak(vlak.cv1,vmax,vakt,0);{zastavenie vlaku}
  preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
  if pozicia[pozicia[slpoz[j_i].x]^.c[2]]^.ch[2]='S' then begin
   pozicia[pozicia[slpoz[j_i].x]^.c[2]]^.y:=1;
   krstav(pozicia[slpoz[j_i].x]^.c[2]);
  end;
  najd_vlak(vlak.cv1,vmax,vakt,vpom);exit;
 end;
end;
pozicia[slpoz[j_i].x]^.pvlak:=slpoz[j_i].y;
case pozicia[slpoz[j_i].x]^.ch[1] of
 'U','K','V':begin  {obsadenie useku al. vyhybky}
  with pozicia[slpoz[j_i].x]^ do begin
   l:=stav;{Zapamataj predosli stav}stav:=3;
   krstav(slpoz[j_i].x);
   if (ch[2]='B')and(n[1]>0) then begin {uzavri PZS}
    pozicia[n[1]]^.sm:=pozicia[n[1]]^.sm or 8;
    prvky(n[1],0);
    if pozicia[n[1]]^.sm and 3>0 then begin
     case pozicia[n[1]]^.sm and 3 of{najdenie suseda}
      1:chu_mo:=n[1]-xmax;
      2:chu_mo:=n[1]+xmax;
     end;
     pozicia[chu_mo]^.sm:=pozicia[chu_mo]^.sm or 16;
     prvky(chu_mo,0);
    end;
   end;
   if rych=255 then chu_mo:=n[2] {test rychlosti.}
    else begin   {zisti vmax z pohladu useku}
     if rych>n[2] then chu_mo:=n[2] else chu_mo:=rych;
    end;
   if chu_mo>vmax then chu_mo:=vmax; {usek "da" viac ako vlak}
   if chu_mo>vakt then begin {zvysenie z vakt na chu_mo}
    i:=vpol;
    with slpoz[i] do begin
     pomv:=vlak.dl;
     x:=0;y:=vlak.cv1;nst:=14;cas:=prip(slpoz[j_i].cas,15+(360*pomv)div vakt);
    end;
    vlozm(slpoz[i].cas,i);
    aktu_vlak(vlak.cv1,vmax,vakt,chu_mo);
   end;
   if chu_mo<vakt then begin {znizenie z vakt na chu_mo}
    aktu_vlak(vlak.cv1,vmax,vakt,chu_mo);preradenie(vlak.cv1);
    prepocet(caslong,vlak.cv1);najd_vlak(vlak.cv1,vmax,vakt,vpom);
   end;
  end;
  i:=vpol;  {vypocet nasledujuceho}
  with slpoz[i] do begin
   x:=slpoz[j_i].x;y:=vlak.cv1;nst:=6;pomv:=pozicia[x]^.dl;
   cas:=prip(slpoz[j_i].cas,(36*pomv) div vakt);
  end;
  pomv:=vlak.dl;{vypocet casu uvolnenia}
  with slpoz[j_i] do begin
   nst:=5;chu_mo:=x;cas:=prip(slpoz[i].cas,(360*pomv) div vakt);end;
  with pozicia[chu_mo]^ do
   case ch[1] of
    'K','U':case ch[2] of
             'B':begin k:=c[1];
                  if vlak.sm=1 then k:=k and 15 else k:=k shr 8;
                  slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
                 end;
             'S':if vlak.mo=c[3] then begin
                  slpoz[j_i].cas:=slpoz[i].cas;{konciaci vlak}
                  slpoz[j_i].nst:=7;
                  if vlak.clo>0 then {pridaj na odpojenie lv}
                   slpoz[j_i].cas:=prip(slpoz[j_i].cas,300+random(300));
                  vlozm(slpoz[j_i].cas,j_i);
                  slpoz[i].nst:=69;pomv:=vlak.dl;{"rozsv." KS}
                  slpoz[i].cas:=prip(caslong,(360*pomv) div vakt);
                  vlozm(slpoz[i].cas,i);mousezap;stav:= stav and 251;exit;
                 end else begin
                  ca:=false;chu_mo1:=1;
                  if c[3]>0 then
                   while (not ca)and(chu_mo1<11) do
                    if (c[3]=vlak.stm[chu_mo1])and(vlak.stcp[chu_mo1]>0) then
                     ca:=true else inc(chu_mo1);
                  if ca then begin
                   c[2]:=chu_mo1;  {Vlak zastavuje v stanici}
                   slpoz[j_i].cas:=slpoz[i].cas;slpoz[j_i].nst:=70;
                   vlozm(slpoz[j_i].cas,j_i);
                   slpoz[i].nst:=69;pomv:=vlak.dl;{"rozsv." KS}
                   slpoz[i].cas:=prip(caslong,(360*pomv) div vakt);
                   vlozm(slpoz[i].cas,i);mousezap;stav:= stav and 251;exit;
                  end else begin
                   case vlak.sm of
                    1:slpoz[i].x:=slpoz[i].x+(c[1] and 15)+2;
                    2:slpoz[i].x:=slpoz[i].x-(c[1] shr 4)-2;
                   end;
                  end;
                 end;
             'P':slpoz[i].x:=slpoz[i].x+3-(2*(vlak.sm and 3));
            end;
    'V':case ch[2] of
        'N':begin k:=c[sm] and 4095; {Najdenie nasledujuceho}
             if vlak.sm=1 then k:=k and 15 else k:=k shr 8;
             slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
            end;
        'K':begin
             case vlak.sm of
              1:begin sm1:=sm and 3;sm2:=(sm shr 2) and 3;
                 if sm and 16=0 then sm1:=0;
                 if sm and 32=0 then sm2:=0;
                end;
              2:begin sm1:=(sm shr 2) and 3;sm2:=sm and 3;
                 if sm and 32=0 then sm1:=0;
                 if sm and 16=0 then sm2:=0;
                end;
             end;
             if sm1>0 then begin {cez tuto cast sa pojde}
              if vlak.sm=2 then sm1:=sm1+2;
              k:=c[sm1] and 4095; {Najdenie nasledujuceho}
              if vlak.sm=1 then k:=k and 15 else k:=k shr 8;
              if k<>5 then slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
             end;
             if sm2>0 then begin {cez tuto cast sa pojde 2}
              if vlak.sm=1 then sm2:=sm2+2;
              k:=c[sm2] and 4095; {Najdenie nasledujuceho}
              if vlak.sm=1 then k:=k and 15 else k:=k shr 8;
              slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
             end;
            end;
        end;
   end;
  if pozicia[slpoz[i].x]^.ch[1]+pozicia[slpoz[i].x]^.ch[2]='UO' then
   slpoz[i].x:=pozicia[slpoz[i].x]^.n[vlak.sm];
  chu_mo:=slpoz[i].x;
  case pozicia[slpoz[i].x]^.ch[1] of
   'N':with pozicia[chu_mo]^ do
        case ch[2] of
         'E':if l=2 then if vlak.sm=sm and 3 then slpoz[i].x:=c[1] else slpoz[i].x:=c[2];
         'D','H':if sm and 3<>vlak.sm then slpoz[i].x:=c[2];
        end;
  end;
  if pozicia[slpoz[i].x]^.ch[1]='M' then
   case pozicia[slpoz[i].x]^.ch[2] of 'B','R','A':slpoz[i].nst:=3;end;
  vlozm(slpoz[i].cas,i);vlozm(slpoz[j_i].cas,j_i);
 end;       {Koniec obsadenie useku al. vyhybky}
end;
end;  {--- KONIEC - Obsadenie useku vo vlakovej ceste ---}


procedure moznosti3(j_i:word);
 {--- Obsadenie medzistanicneho useku ---}
var chu_mo,chu_mo1:word;
    vmax,vakt,vpom:byte;
begin
chu_mo:=0;chu_mo1:=0;
najd_vlak(slpoz[j_i].y,vmax,vakt,vpom);{najdenie vlaku, ktory obsadil}
if pozicia[slpoz[j_i].x]^.ch[1]='N' then begin  {Mam "obsadit" navestidlo}
 if pozicia[slpoz[j_i].x]^.stav=2 then begin {postavene nav.}
  with pozicia[slpoz[j_i].x]^ do begin {navestidlo na stoj}
   stav:=0;pvlak:=0;rych:=255;c[4]:=0;dl:=0;end;
  with slpoz[j_i] do begin
   krstav(x);zmaz(pozicia[x]^.c[3],y);nst:=6; {vykesli nav. zmaz vlak zo ZB}
  end;
  slpoz[j_i].x:=pozicia[slpoz[j_i].x]^.c[1];{Najdi nasledujuci}
  moznosti6(j_i);exit;
 end else begin            {nav. na STOJ-zastavenie vlaku}
  pozicia[slpoz[j_i].x]^.pvlak:=slpoz[j_i].y; {zapisanie vlaku k navestidlu}
  vlozm(slpoz[j_i].cas,j_i);
  aktu_vlak(vlak.cv1,vmax,vakt,0);
  preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
  najd_vlak(vlak.cv1,vmax,vakt,vpom);exit;
 end;
end;   {Koniec Mam "obsadit" navestidlo}
case pozicia[slpoz[j_i].x]^.ch[1] of
 'M':case pozicia[slpoz[j_i].x]^.ch[2] of
      'B','O','P','A','R':begin  {Obsadzuje sa usek}
        if pozicia[slpoz[j_i].x]^.stav=3 then begin {obsadeny usek na AB}
         aktu_vlak(vlak.cv1,vmax,vakt,0);
         slpoz[j_i].cas:=caslong+1;vlozm(slpoz[j_i].cas,j_i);
         preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
         mousezap;stav:= stav and 251;exit;
        end;
        with pozicia[slpoz[j_i].x]^ do begin
         pvlak:=slpoz[j_i].y;stav:=3; {zmena stavu}
         if ch[2]='A' then c[2]:=c[2] or 1;
         case ch[2] of 'B','A','R':
          if n[1]>0 then begin {uzavri PZS}
           pozicia[n[1]]^.sm:=pozicia[n[1]]^.sm or 8;
           prvky(n[1],0);
           if pozicia[n[1]]^.sm and 3>0 then begin
            case pozicia[n[1]]^.sm and 3 of{najdenie suseda}
             1:chu_mo:=n[1]-xmax;
             2:chu_mo:=n[1]+xmax;
            end;
            pozicia[chu_mo]^.sm:=pozicia[chu_mo]^.sm or 16;
            prvky(chu_mo,0);
           end;
          end;
         end;
        end;
        krstav(slpoz[j_i].x);                  {vykreslenie zmeny}
        chu_mo1:=pozicia[slpoz[j_i].x]^.c[3]; {Obsadenie tr. suhlasu}
        with pozicia[chu_mo1]^ do begin
         if c[3]>0 then ca:=false else ca:=true;{zamedzenie zbytocnemu kresleniu}
         c[3]:=c[3] or (moc(pozicia[slpoz[j_i].x]^.y));
         if ca then krstav(chu_mo1);
        end;
        if pozicia[slpoz[j_i].x]^.n[2]>vmax then chu_mo1:=vmax else chu_mo1:=pozicia[slpoz[j_i].x]^.n[2];
        if chu_mo1>vakt then begin {zvysenie z vakt na chu_mo}
         i:=vpol;
         with slpoz[i] do begin
          x:=0;y:=vlak.cv1;nst:=14;pomv:=vlak.dl;
          cas:=slpoz[j_i].cas+15+(360*pomv)div vakt;
         end;
         vlozm(slpoz[i].cas,i);
         aktu_vlak(vlak.cv1,vmax,vakt,chu_mo1);
        end;
        if chu_mo1<vakt then begin {znizenie z vakt na chu_mo}
         aktu_vlak(vlak.cv1,vmax,vakt,chu_mo1);
         preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
         najd_vlak(vlak.cv1,vmax,vakt,vpom);
        end;
        i:=vpol;   {vypocet casu obsadenia nasledujuceho}
        pomv:=pozicia[slpoz[j_i].x]^.dl;
        with slpoz[i] do begin
         cas:=prip(slpoz[j_i].cas,(36*pomv) div vakt);nst:=3;y:=vlak.cv1;end;
        if (vlak.cv1>1000)and(vlak.cv1<30000)and
         (pozicia[slpoz[j_i].x]^.sm and 240>0)and(typ_vlaku(vlak.cv1)='Os')
         then slpoz[i].cas:=prip(slpoz[i].cas,300+random(300)); {osobak na zastavke}
        chu_mo:=slpoz[j_i].x;
        with pozicia[chu_mo]^ do
         case ch[2] of {vyhladanie nasledujuceho prvku}
          'B':begin k:=c[1];
               if vlak.sm=1 then k:=k and 15 else k:=k shr 8;
               chu_mo:=chu_mo+dx[k]+dy[k]*xmax;
              end;
          'P','R','A':chu_mo:=chu_mo+3-(2*(vlak.sm and 3));
         end;
         if pozicia[chu_mo]^.ch[2]='O' then chu_mo:=pozicia[chu_mo]^.n[vlak.sm and 3];
         slpoz[i].x:=chu_mo;
         vlozm(slpoz[i].cas,i);pomv:=vlak.dl;
         slpoz[j_i].cas:=prip(slpoz[i].cas,(360*pomv)div vakt);{cas uvolnenia}
         slpoz[j_i].nst:=0;
         vlozm(slpoz[j_i].cas,j_i);
        end;   {---- Koniec obsadenie useku ----}
      'Z':begin                      {Obsadenie MZ}
           pozicia[slpoz[j_i].x]^.pvlak:=slpoz[j_i].y;
           chu_mo1:=pozicia[slpoz[j_i].x]^.c[1];{Obsadenie tr. suhlasu}
           with pozicia[chu_mo1]^ do begin
            if c[3]>0 then ca:=false else ca:=true;{zamedzenie zbytocnemu kresleniu}
            c[3]:=c[3] or (moc(pozicia[slpoz[j_i].x]^.y));
           end;
           if ca then krstav(chu_mo1);
           pomv:=vlak.dl;
           with slpoz[j_i] do begin
            cas:=prip(cas,(360*pomv)div vakt);nst:=1;y:=vlak.cv1;end;
           vlozm(slpoz[j_i].cas,j_i)
          end;  {---- Koniec obsadenie MZ ----}
     end;
end;
end;  {--- KONIEC - Obsadenie medzistanicneho useku ---}

procedure moznosti4(j_i:word);
 {--- Obsadenie useku v posunovej ceste ---}
var chu_mo,chu_mo1:word;
    sm1,sm2:byte;
    temp,temp1:kolaj_fr;
begin
chu_mo:=0;chu_mo1:=slpoz[j_i].nst-40;{chu_mo1 urcuje smer pohybu}
if pozicia[slpoz[j_i].x]^.ch[1]='N' then{mam "obsadit" navestidlo}
 if pozicia[slpoz[j_i].x]^.stav=1 then begin{nav. postavene}
  chu_mo:=pozicia[slpoz[j_i].x]^.c[2];     {predosli usek}
  zlozenie:=pozicia[chu_mo]^.viac;  {vymaz na K? lokomotivu}
  sm1:=pozicia[slpoz[j_i].x]^.sm;
  temp:=zlozenie^[3-sm1];
  zlozenie^[3-sm1]:=temp^.smer[sm1];
  temp^.smer[sm1]:=nil;
  if zlozenie^[3-sm1]<>nil then zlozenie^[3-sm1]^.smer[3-sm1]:=nil
  else begin {uz na kolaji nic nie je treba ju uvolnit}
   zlozenie^[sm1]:=nil;
   dispose(zlozenie);
   pozicia[chu_mo]^.viac:=nil;
   i:=vpol;
   with slpoz[i] do begin
    x:=chu_mo;y:=0;nst:=2;cas:=prip(caslong,18);end;
   vlozm(slpoz[i].cas,i);
  end;
  slpoz[j_i].y:=temp^.cislo;        {zapis cislo Lv do slpoz}
  dispose(temp);
  with pozicia[slpoz[j_i].x]^ do begin {obsad a nakresli}
   stav:=0;pvlak:=0;rych:=255;c[4]:=0;dl:=0;sl:=0;end;
  krstav(slpoz[j_i].x);
  slpoz[j_i].x:=pozicia[slpoz[j_i].x]^.c[1];{najdi nasl}
 end else  {nie je postavene nav.}
  with pozicia[slpoz[j_i].x]^ do begin
   pvlak:=slpoz[j_i].y;sl:=j_i;exit;
  end;
case pozicia[slpoz[j_i].x]^.ch[1] of
 'U','V','K':begin {obsadenie useku}
              pozicia[slpoz[j_i].x]^.stav:=3; {obsad a nakresli}
              krstav(slpoz[j_i].x);
  {len "K"}   if pozicia[slpoz[j_i].x]^.ch[1]='K' then begin
               new(temp);
               with temp^ do begin    {vytvor. prvku co sa prida do}
                pomv:=chu_mo1;
                cislo:=slpoz[j_i].y or $02000000; {zlozenia kolaje}
                cislo:=cislo or (pomv shl 26);    {smer pohybu}
                smer[1]:=nil;smer[2]:=nil;
               end;
               zlozenie:=pozicia[slpoz[j_i].x]^.viac;
               case pozicia[slpoz[j_i].x]^.ch[2] of
                'B':if zlozenie=nil then begin {nic nie je na kolaji}
                     new(zlozenie);
                     zlozenie^[1]:=temp;zlozenie^[2]:=temp;
                     with slpoz[j_i] do begin {jazda do pol kolaje}
                      pomv:=pozicia[x]^.dl shr 1;
                      nst:=49;cas:=prip(cas,trunc(0.9*pomv));
                     end;
                     vlozm(slpoz[j_i].cas,j_i);
                     pozicia[slpoz[j_i].x]^.viac:=zlozenie;zlozenie:=nil;
                    end else begin    {je tam nieco}
                     zlozenie^[chu_mo1]^.smer[chu_mo1]:=temp;
                     temp^.smer[3-chu_mo1]:=zlozenie^[chu_mo1];
                     zlozenie^[chu_mo1]:=temp;
                     temp:=nil;
                     pozicia[slpoz[j_i].x]^.viac:=zlozenie;zlozenie:=nil;
                     with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
                    end;
                'S':begin
                    if zlozenie=nil then begin {nie je tam posunujuci diel}
                     new(zlozenie); {vytvor zlozenie}
                     if pozicia[slpoz[j_i].x]^.pvlak=0 then begin {kolaj je prazdna}
                      zlozenie^[1]:=temp;zlozenie^[2]:=temp;
                      with slpoz[j_i] do begin {jazda do pol kolaje}
                       pomv:=pozicia[x]^.dl shr 1;
                       nst:=49;cas:=prip(cas,trunc(0.9*pomv));
                      end;
                      vlozm(slpoz[j_i].cas,j_i);
                      pozicia[slpoz[j_i].x]^.viac:=zlozenie;zlozenie:=nil;
                     end else begin {je tam vlak}
                      new(temp1);
                      with temp1^ do begin    {vytvor. prvku vlaku co stoji}
                       cislo:=pozicia[slpoz[j_i].x]^.pvlak; {na kolaji a vlozenie}
                       smer[1]:=nil;smer[2]:=nil;           {do zlozenia}
                      end;
                      zlozenie^[1]:=temp1;zlozenie^[2]:=temp1;temp1:=nil;
                      zlozenie^[chu_mo1]^.smer[chu_mo1]:=temp;{zarad pos. diel}
                      temp^.smer[3-chu_mo1]:=zlozenie^[chu_mo1];
                      zlozenie^[chu_mo1]:=temp;
                      temp:=nil;
                      pozicia[slpoz[j_i].x]^.viac:=zlozenie;zlozenie:=nil;
                      with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
                     end;
                    end else begin {je tam posunujuci diel}
                     zlozenie^[chu_mo1]^.smer[chu_mo1]:=temp;{zarad pos. diel}
                     temp^.smer[3-chu_mo1]:=zlozenie^[chu_mo1];
                     zlozenie^[chu_mo1]:=temp;
                     temp:=nil;
                     pozicia[slpoz[j_i].x]^.viac:=zlozenie;zlozenie:=nil;
                     with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
                    end;
                    end;
               end;
               exit;
              end;
              i:=vpol;
              with slpoz[i] do begin {parametre obs. nasl.}
               x:=slpoz[j_i].x;y:=slpoz[j_i].y;nst:=slpoz[j_i].nst;
               pomv:=pozicia[x]^.dl;
               cas:=prip(slpoz[j_i].cas,trunc(0.9*pomv));
              end;
              with slpoz[j_i] do begin {parametre uvolnenia}
               nst:=2;cas:=prip(slpoz[i].cas,18);chu_mo:=x;
              end;
              with pozicia[chu_mo]^ do{Najdenie nasledujuceho}
               case ch[1] of
                'U':case ch[2] of
                     'B':begin k:=c[1];
                          if chu_mo1=1 then k:=k and 15 else k:=k shr 8;
                          slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
                         end;
                     'P':slpoz[i].x:=slpoz[i].x+3-(2*(vlak.sm and 3));
                    end;
                'V':case ch[2] of
                    'N':begin k:=c[sm] and 4095;
                         if chu_mo1=1 then k:=k and 15 else k:=k shr 8;
                         slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
                        end;
                    'K':begin
                         case chu_mo1 of
                          1:begin sm1:=sm and 3;sm2:=(sm shr 2) and 3;
                             if sm and 16=0 then sm1:=0;
                             if sm and 32=0 then sm2:=0;
                            end;
                          2:begin sm1:=(sm shr 2) and 3;sm2:=sm and 3;
                             if sm and 32=0 then sm1:=0;
                             if sm and 16=0 then sm2:=0;
                            end;
                         end;
                         if sm1>0 then begin {cez tuto cast sa pojde}
                          if chu_mo1=2 then sm1:=sm1+2;
                          k:=c[sm1] and 4095; {Najdenie nasledujuceho}
                          if chu_mo1=1 then k:=k and 15 else k:=k shr 8;
                          if k<>5 then slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
                         end;
                         if sm2>0 then begin {cez tuto cast sa pojde 2}
                          if chu_mo1=1 then sm2:=sm2+2;
                          k:=c[sm2] and 4095; {Najdenie nasledujuceho}
                          if chu_mo1=1 then k:=k and 15 else k:=k shr 8;
                          slpoz[i].x:=slpoz[i].x+dx[k]+dy[k]*xmax;
                         end;
                        end;
                    end;
               end;
               chu_mo:=slpoz[i].x;
               case pozicia[chu_mo]^.ch[1] of
                'N':with pozicia[chu_mo]^ do
                     case ch[2] of
                      'E','D':if chu_mo1<>sm and 3 then slpoz[i].x:=c[2] else slpoz[i].x:=c[1];
                     end;
                'U':if pozicia[chu_mo]^.ch[2]='O' then slpoz[i].x:=pozicia[chu_mo]^.n[vlak.sm];
               end;
               vlozm(slpoz[i].cas,i);vlozm(slpoz[j_i].cas,j_i);
             end;
end;
end;  {--- KONIEC - Obsadenie useku v posunovej ceste ---}

procedure moznosti49(j_i:word);
 {--- Jazda do pol kolaje pri posune - KB,KS ---}
var temp:kolaj_fr;
    chu_mo,ch_m:word;
begin
 zlozenie:=pozicia[slpoz[j_i].x]^.viac;
 if zlozenie^[1]=zlozenie^[2] then begin {nic nie je na kolaji}
  temp:=zlozenie^[1];
  chu_mo:=(temp^.cislo shr 26) and 3;    {smer pohybu}
  case pozicia[slpoz[j_i].x]^.ch[2] of   {najdi nav. v smere}
   'B':begin k:=pozicia[slpoz[j_i].x]^.c[1];
        if chu_mo=1 then k:=k and 15 else k:=k shr 8;
        ch_m:=slpoz[j_i].x+dx[k]+dy[k]*xmax;
        if pozicia[ch_m]^.ch[2]='O' then ch_m:=pozicia[ch_m]^.n[chu_mo];
       end;
   'S':with slpoz[j_i] do
        case chu_mo of
         1:ch_m:=x+(pozicia[x]^.c[1] and 15)+2;
         2:ch_m:=x-(pozicia[x]^.c[1] shr 4)-2;
        end;
  end;
  if pozicia[ch_m]^.stav=1 then begin {postaveny posun v smere?}
   with slpoz[j_i] do begin    {cas obs. nav.}
    pomv:=pozicia[x]^.dl shr 1;
    x:=ch_m;nst:=40+chu_mo;
    cas:=prip(cas,trunc(0.9*pomv));
   end;
   vlozm(slpoz[j_i].cas,j_i);
  end else begin {postaveny posun proti smeru?}
   chu_mo:=3-chu_mo; {opacny smer}
   case pozicia[slpoz[j_i].x]^.ch[2] of   {najdi nav. v smere}
   'B':begin k:=pozicia[slpoz[j_i].x]^.c[1];
        if chu_mo=1 then k:=k and 15 else k:=k shr 8;
        ch_m:=slpoz[j_i].x+dx[k]+dy[k]*xmax;
        if pozicia[ch_m]^.ch[2]='O' then ch_m:=pozicia[ch_m]^.n[chu_mo];
       end;
   'S':with slpoz[j_i] do
        case chu_mo of
         1:ch_m:=x+(pozicia[x]^.c[1] and 15)+2;
         2:ch_m:=x-(pozicia[x]^.c[1] shr 4)-2;
        end;
   end;
   if pozicia[ch_m]^.stav=1 then begin {postaveny posun v smere?}
    with slpoz[j_i] do begin    {cas obs. nav.}
     pomv:=pozicia[x]^.dl shr 1;
     x:=ch_m;nst:=40+chu_mo;
     cas:=prip(cas,trunc(0.9*pomv));
    end;
    pomv:=chu_mo;temp^.cislo:=(temp^.cislo and $030FFFFF) or (pomv shl 26);
    vlozm(slpoz[j_i].cas,j_i);
   end else temp^.cislo:=temp^.cislo and $030FFFFF;{stoj v strede}
  end;
 end else begin {je na kolaji nieco}
  temp:=zlozenie^[1];chu_mo:=0;{zisti smer mozneho pohybu}
  if (temp^.cislo and $01FFFF)=(slpoz[j_i].y and $01FFFF) then
   chu_mo:=2
  else begin
   temp:=zlozenie^[2];
   if (temp^.cislo and $01FFFF)=(slpoz[j_i].y and $01FFFF) then
    chu_mo:=1
  end;
  case pozicia[slpoz[j_i].x]^.ch[2] of   {najdi nav. v smere}
   'B':begin k:=pozicia[slpoz[j_i].x]^.c[1];
        if chu_mo=1 then k:=k and 15 else k:=k shr 8;
        ch_m:=slpoz[j_i].x+dx[k]+dy[k]*xmax;
        if pozicia[ch_m]^.ch[2]='O' then ch_m:=pozicia[ch_m]^.n[chu_mo];
       end;
   'S':with slpoz[j_i] do
        case chu_mo of
         1:ch_m:=x+(pozicia[x]^.c[1] and 15)+2;
         2:ch_m:=x-(pozicia[x]^.c[1] shr 4)-2;
        end;
  end;
  if pozicia[ch_m]^.stav=1 then begin {postaveny posun v smere?}
   with slpoz[j_i] do begin    {cas obs. nav.}
    pomv:=pozicia[x]^.dl shr 1;
    x:=ch_m;nst:=40+chu_mo;
    cas:=prip(cas,trunc(0.9*pomv));
   end;
   pomv:=chu_mo;temp^.cislo:=(temp^.cislo and $030FFFFF) or (pomv shl 26);
   vlozm(slpoz[j_i].cas,j_i);
  end else temp^.cislo:=temp^.cislo and $030FFFFF;{stoj v strede}
 end;
end;  {--- KONIEC - Jazda do pol kolaje pri posune - KB,KS ---}

procedure moznosti5(j_i:word);
 {--- Uvolnenie useku vo vlakovej ceste ---}
var chu_mo:word;
    v:byte;
begin
najd_vlak(slpoz[j_i].y,v,v,v);{najdenie vlaku}
with pozicia[slpoz[j_i].x]^ do begin
 stav:=stav shr 4;
 pvlak:=0;rych:=255;if ch[1]='K' then c[4]:=0;
 if ch[2]='P' then begin sm:=sm and 247;{otvorenie PZS}
  if sm and 3>0 then begin
   case sm and 3 of{najdenie suseda}
    1:chu_mo:=slpoz[j_i].x-xmax;
    2:chu_mo:=slpoz[j_i].x+xmax;
   end;
   pozicia[chu_mo]^.sm:=pozicia[chu_mo]^.sm and 239;
   prvky(chu_mo,0);
  end;
 end;
end;
with pozicia[slpoz[j_i].x]^ do if ch[1]='V'then sm:=sm and 15;{uvolnenie zaveru vyh.}
krstav(slpoz[j_i].x);
with pozicia[slpoz[j_i].x]^ do
 case ch[2] of
  'H':zmaz(c[3],slpoz[j_i].y); {vymazanie zo ZB}
  'B':if (ch[1]='K')and(sm=vlak.sm) then begin
       pozicia[c[2]]^.c[3]:=pozicia[c[2]]^.c[3] and 253;{Uvolnenie tr. suhlasu}
       if pozicia[c[2]]^.c[3]>0 then krstav(c[2]);
      end;
 end;
with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
end;  {--- KONIEC - Uvolnenie useku vo vlakovej ceste ---}

procedure moznosti7(j_i:word);
 {--- Precislovanie vlaku , Odpojenie lokomotivy---}
var chu_mo:word;
    vmax,vakt,vpom:byte;
    temp:kolaj_fr;
begin
chu_mo:=0;
najd_vlak(slpoz[j_i].y,vmax,vakt,vpom);{najdenie vlaku}
aktu_vlak(vlak.cv1,vmax,vakt,0);{zastavenie vlaku}
preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
if vlak.clo>0 then begin {ak sa odpaja rusen tak data pre zlozenie kolaje}
 if pozicia[slpoz[j_i].x]^.viac=nil then new(zlozenie);{ak tam nic nie je}
 new(temp); {chyba dorobit zaradenie ak tam nieco uz je}
 with temp^ do begin cislo:=vlak.cv2 or $01000000;{je to suprava}
  smer[1]:=nil;smer[2]:=nil;
 end;
 zlozenie^[1]:=temp;zlozenie^[2]:=temp; {zaradenie supravy}
 temp:=nil;new(temp);
 with temp^ do begin cislo:=vlak.clo or $02000000;{je to Lv}
  smer[1]:=nil;smer[2]:=nil;
 end;
 with vlak do begin {zaradenie Lv na kolaji}
  temp^.smer[sm]:=zlozenie^[3-sm];
  zlozenie^[3-sm]^.smer[3-sm]:=temp;
  zlozenie^[3-sm]:=temp;
 end;
 temp:=nil;
 pozicia[slpoz[j_i].x]^.viac:=zlozenie; {info na kolaji}
 zlozenie:=nil;
 with pozicia[slpoz[j_i].x]^ do {najdenie nav. v smere lv}
  case vlak.sm of
   1:k:=slpoz[j_i].x+(c[1] and 15)+2;
   2:k:=slpoz[j_i].x-(c[1] shr 4)-2;
  end;
 if (pozicia[k]^.stav=1)and(pozicia[k]^.pvlak=0) then begin {nav. na posun}
  i:=vpol;slpoz[i].x:=k;pozicia[k]^.pvlak:=vlak.clo;
  with slpoz[i] do begin         {obsadenie navestidla}
   cas:=prip(caslong,random(300)+200);nst:=40+vlak.sm;
  end;
  vlozm(slpoz[i].cas,i);
 end;
end;
zmaz_vlak(vlak.cv1);               {zmazanie stareho}
slpoz[j_i].y:=vlak.cv2;            {zmena cisla}
reset(svlak);ca:=false;            {najdenie noveho}
while not(eof(svlak)) and (not ca) do begin
 read(svlak,vlak);
 if slpoz[j_i].y=vlak.cv1 then ca:=true;
end;
vlozk_vlak(vlak.cv1,vlak.vm,0,0,filepos(svlak)-1); {zapisanie noveho}
kv_vlak;
pr_body(slpoz[j_i].y,2);  {pripocitaj body}
pozicia[slpoz[j_i].x]^.c[4]:=slpoz[j_i].y;
krstav(slpoz[j_i].x);
with pozicia[slpoz[j_i].x]^ do begin pvlak:=vlak.cv1;c[4]:=vlak.cv1;y:=2;end;
if pozicia[slpoz[j_i].x]^.viac=nil then begin  {je to motorka a netreba odpojit Lv}
 chu_mo:=1;
 if vlak.cv1>17000 then chu_mo:=2;
 if vlak.cv1>50000 then chu_mo:=3;
 if vlak.cv1>80000 then chu_mo:=4;
 pomv:=chu_mo*pozicia[vlak.mz]^.n[1]; {min cas statia}
 with slpoz[j_i] do begin
  nst:=8;cas:=vlak.casz-1;cas:=600*cas;
  caspom:=vlak.casz;caspom:=caspom*600;
  if caspom<caslong then cas:=caslong+pomv;{ak casz<akt cas tak pripoc min statie}
  if cas<caslong then begin cas:=caslong;
   pozicia[slpoz[j_i].x]^.y:=3;krstav(slpoz[j_i].x);
   with slpoz[j_i] do begin nst:=9;cas:=prip(cas,600);end;
  end;
 end;
 slpoz[j_i].cas:=prip(slpoz[j_i].cas,0);
 vlozm(slpoz[j_i].cas,j_i);
end;
end;  {--- KONIEC - Precislovanie vlaku , Odpojenie lokomotivy---}

procedure moznosti8_100(j_i:word);
 {podla kodu v slpoz rozhoduje o dalsom deji v bunkach}
label znova,pok21;
var chu_mo,chu_mo1:word;
    vmax,vakt,vpom,cisvch,sm1,sm2:byte;
    l:integer;
begin
znova:
chu_mo:=0;chu_mo1:=0;
case slpoz[j_i].nst of
 8:begin {--- Minuta do odchodu ---}
    pozicia[slpoz[j_i].x]^.y:=3;
    krstav(slpoz[j_i].x);
    with slpoz[j_i] do begin nst:=9;cas:=prip(cas,600);end;
    vlozm(slpoz[j_i].cas,j_i);
   end;  {--- KONIEC - Minuta do odchodu ---}
 9:begin {--- Odchod vlaku ---}
    i:=vpol;
    najd_vlak(slpoz[j_i].y,vmax,vakt,vpom);
    with pozicia[slpoz[j_i].x]^ do  {najde odch. nav.}
     case vlak.sm of
      1:slpoz[i].x:=slpoz[j_i].x+(c[1] and 15)+2;
      2:slpoz[i].x:=slpoz[j_i].x-(c[1] shr 4)-2;
     end;
    pozicia[slpoz[i].x]^.pvlak:=vlak.cv1;
    pozicia[slpoz[j_i].x]^.pvlak:=vlak.cv1;
    if pozicia[slpoz[i].x]^.stav=2 then begin{postavene odchodove navestidlo}
     pozicia[slpoz[j_i].x]^.y:=0; {na KS zmazanie far. podkladu}
     krstav(slpoz[j_i].x);
     if pozicia[slpoz[i].x]^.dl=255 then begin {zistenie rychlosti}
      if vmax>pozicia[pozicia[slpoz[i].x]^.c[1]]^.n[2] then
       vakt:=pozicia[pozicia[slpoz[i].x]^.c[1]]^.n[2]
      else vakt:=vmax;
     end else vakt:=pozicia[slpoz[i].x]^.dl;
     aktu_vlak(vlak.cv1,vmax,vakt,vakt);
     {vypocet casu uvolnenia}
     with slpoz[i] do begin y:=vlak.cv1;nst:=6;cas:=prip(slpoz[j_i].cas,100);end;
     with slpoz[j_i] do begin
      pomv:=vlak.dl;
      nst:=5;cas:=prip(slpoz[i].cas,(360*pomv) div vakt);end;
     vlozm(slpoz[i].cas,i);vlozm(slpoz[j_i].cas,j_i);
    end else begin
     with slpoz[i] do begin y:=vlak.cv1;nst:=56;cas:=1000;end;
     with slpoz[j_i] do begin nst:=55;cas:=1000+36*vlak.dl;end;
     pozicia[slpoz[j_i].x]^.y:=1; {na KS zmena far. podkladu}
     krstav(slpoz[j_i].x);
    end;
   end;  {--- KONIEC - Odchod vlaku ---}
 10:begin{--- Rusenie cesty ---}
     rus_cesta(slpoz[j_i].x);
     with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
    end; {--- KONIEC - Rusenie cesty ---}
 14:begin{--- Zmena rychlosti ---}
     preradenie(slpoz[j_i].y);prepocet(caslong,slpoz[j_i].y);
     with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
    end; {--- KONIEC - Zmena rychlosti ---}
 20:begin{--- Zaradenie dalsieho vlaku ---}
     reset(svlak);seek(svlak,slpoz[j_i].x);{najdenie vlaku}
     read(svlak,vlak);
     chu_mo1:=pozicia[vlak.mz]^.c[3];  {najdenie ZB}
     chu_mo:=pozicia[vlak.mz]^.c[1];   {najdenie TS}
     if (pozicia[chu_mo1]^.c[4]=0)and(pozicia[chu_mo]^.dl=0) then
      begin {v ZB nie je dotaz a TS nie je blokovany}
      pozicia[chu_mo1]^.c[4]:=vlak.cv1;prvky(chu_mo1,1);{vypis dotazu do ZB}
      pozicia[chu_mo1]^.stav:=j_i;      {v ZB je dotaz}
     end else begin
      slpoz[j_i].cas:=prip(slpoz[j_i].cas,300);
      vlozm(slpoz[j_i].cas,j_i);
     end;
    end; {--- KONIEC Zaradenie dalsieho vlaku ---}
 21:begin{--- Vchod prijateho vlaku ---}
     reset(svlak);seek(svlak,slpoz[j_i].x);{najdenie vlaku}
     read(svlak,vlak);chu_mo1:=pozicia[vlak.mz]^.c[3];
     with pozicia[chu_mo1]^ do begin
      c[4]:=0;stav:=0;end;      {zmazanie dotazu zo ZB}
     chu_mo1:=pozicia[vlak.mz]^.c[1];{najdenie TS}
     if (pozicia[chu_mo1]^.c[3]>0) then begin   {obsadeny TS(VT)}
      if pozicia[chu_mo1]^.n[1]>0 then begin
       if pozicia[chu_mo1]^.stav=vlak.sm then
        goto pok21     {trat je AB a TS ma spravny smer}
       else begin      {Trat je AB ale smer TS je opacny}
        pozicia[chu_mo1]^.dl:=1;krstav(chu_mo1);{blok TS}
        with slpoz[j_i] do begin nst:=21;cas:=cas+50;end;
        vlozm(slpoz[j_i].cas,j_i);
       end;
      end else begin   {trat nie je AB}
       pozicia[chu_mo1]^.dl:=1;krstav(chu_mo1);{blok TS}
       with slpoz[j_i] do begin nst:=21;cas:=prip(cas,50);end;
       vlozm(slpoz[j_i].cas,j_i);
      end;
     end else begin                   {volnyTS(VT)}
      pok21:
      if pozicia[chu_mo1]^.stav<>vlak.sm then begin {Otocenie TS}
       pozicia[chu_mo1]^.stav:=vlak.sm;krstav(chu_mo1);end;
      slpoz[j_i].nst:=3;                {nasledujuci stav}
      chu_mo1:=vlak.mz+3-2*(vlak.sm and 3);{najdenie nasleduj.}
      if pozicia[chu_mo1]^.pvlak=0 then begin
       if pozicia[chu_mo1]^.n[2]>vlak.vm then {urc. rychl. vlaku}
        chu_mo:=vlak.vm else chu_mo:=pozicia[chu_mo1]^.n[2];
       vlozk_vlak(vlak.cv1,vlak.vm,chu_mo,chu_mo,slpoz[j_i].x);{zapis vlaku}
       slpoz[j_i].x:=chu_mo1;
       kv_vlak;
       pomv:=pozicia[chu_mo1]^.dl;
       slpoz[j_i].cas:=prip(caslong,(36*pomv) div vlak.vm);{vyp. obsad. nasl.}
       pozicia[chu_mo1]^.pvlak:=vlak.cv1;{cislo pre nasl. usek}
       zapis(pozicia[vlak.mz]^.c[3],vlak.cv1);
       ca:=false;
       chu_mo1:=pozicia[pozicia[vlak.mz]^.c[3]]^.n[vlak.sm];{najdenie 1. nav.}
       if pozicia[chu_mo1]^.stav=2 then begin
        if (pozicia[chu_mo1]^.ch[2]='H')and
         (pozicia[pozicia[chu_mo1]^.c[3]]^.c[1]=vlak.cv1)
         then prenos_cisla(chu_mo1,vlak.cv1);
       end;
       i:=slpoz[j_i].x;{zapisanie do ZB}
       chu_mo1:=pozicia[i]^.c[3]; {Obsadenie tr. suhlasu}
       with pozicia[chu_mo1]^ do begin
        if c[3]>0 then ca:=false else ca:=true;
        c[3]:=c[3] or (moc(pozicia[i]^.y)); dl:=0;{zrusenie blokovania}end;
       krstav(chu_mo1);
       vlozm(slpoz[j_i].cas,j_i);
      end else begin
       with slpoz[j_i] do begin nst:=21;cas:=cas+50;x:=chu_mo1;end;
       vlozm(slpoz[j_i].cas,j_i);
      end;
     end;
    end; {--- KONIEC Vchod prijateho vlaku ---}
 22:begin{--- Zaradenie novych vlakov podla GVD ---}
     reset(svlak);seek(svlak,slpoz[j_i].x);read(svlak,vlak);
     ca:=false;caspom:=slpoz[j_i].cas div 600;i:=vpol;
     repeat
      if pozicia[vlak.mz]^.ch[2]='Z' then begin
       with slpoz[i] do  begin
        nst:=20;x:=filepos(svlak)-1;y:=vlak.cv1;cas:=vlak.casz;
        cas:=prip(cas*600,random(300));
       end;
       vlozm(slpoz[i].cas,i);chu_mo:=vlak.casz;
      end;
      read(svlak,vlak);
      if chu_mo=vlak.casz then i:=vpol else ca:=true;
     until ca;
     with slpoz[j_i] do begin
      x:=filepos(svlak)-1;cas:=vlak.casz;cas:=prip(cas*600,0);
     end;
     vlozm(slpoz[j_i].cas,j_i);
    end; {--- KONIEC Zaradenie novych vlakov podla GVD ---}
 30:begin{--- Rozsvietenie AB po zmene TS ---}
     with pozicia[slpoz[j_i].x]^ do
      if sm and 8=0 then sm:=sm and 251 {alebo rozsviet}
      else sm:=sm and 247;{alebo nechaj zhasnute}
     krstav(slpoz[j_i].x); {rozsviet AB}
     chu_mo1:=pozicia[slpoz[j_i].x]^.c[3];
     with pozicia[chu_mo1]^ do {uvolnenie a odbl. TS}
      c[3]:=c[3] and (255-moc(pozicia[slpoz[j_i].x]^.y));
      if pozicia[chu_mo1]^.c[3]=0 then begin {uvolni blokovanie TS}
       with pozicia[chu_mo1]^ do stav:=stav and 251;
       prvky(chu_mo1,0);
      end;
     end;{--- KONIEC Rozsvietenie AB po zmene TS ---}
 69:     {--- Presvetlenie cisla KS na cerveno ---}
    with slpoz[j_i] do begin {presvetlenie cisla KS na cerveno}
     pozicia[x]^.y:=2;krstav(x);x:=0;y:=0;cas:=0;nst:=-1;
    end; {--- KONIEC Presvetlenie cisla KS na cerveno ---}
 70:begin{--- Zastavenie vlaku v stanici ---}
     najd_vlak(slpoz[j_i].y,vmax,vakt,vpom);{najdenie vlaku, co obsadil}
     aktu_vlak(vlak.cv1,vmax,vakt,0);{zastavenie vlaku}
     preradenie(vlak.cv1);prepocet(caslong,vlak.cv1);
     with pozicia[slpoz[j_i].x]^ do begin
      y:=2;pomv:=vlak.stco[c[2]];i:=c[2];c[2]:=pomv*600;
     end;
     chu_mo:=1;
     if vlak.cv1>17000 then chu_mo:=2;
     if vlak.cv1>50000 then chu_mo:=3;
     if vlak.cv1>80000 then chu_mo:=4;
     pomv:=chu_mo*pozicia[vlak.stm[i]]^.n[1];
     with slpoz[j_i] do begin
      nst:=8;cas:=pozicia[x]^.c[2]-600;
      if pozicia[x]^.c[2]<caslong then cas:=caslong+pomv-600;
      if cas<caslong then begin
       cas:=caslong+pomv;pozicia[x]^.y:=3;nst:=9;
      end;
      krstav(x);
      cas:=prip(cas,0);
     end;
     vlozm(slpoz[j_i].cas,j_i);
    end; {--- KONIEC Zastavenie vlaku v stanici ---}
 100:begin{--- Zmazanie okienka diag. nav ---}
      setfillstyle(0,0);bar(217,0,247,95);
      with okno_nav do begin slid:=0;cisn:=0;end;
      with slpoz[j_i] do begin x:=0;y:=0;cas:=0;nst:=-1;end;
     end; {--- KONIEC Zmazanie okienka diag. nav ---}
 end;
end;

procedure cesty_st;      {obsluha stavania ciest}
var chu_kon,chu_1:word;
    v2,vmax,vakt,vpom:byte;
    i,j:integer;
begin
chu_kon:=0;chu_1:=0; {vymazanie}
chu_1:=kx;
stav:= stav or 4;  {zakaz vypisu casu}
 case pozicia[chu_1]^.ch[1] of
  'N':if (chu_zac=0)and(pozicia[chu_1]^.stav=0) then begin{prvy bod cesty}
       chu_zac:=chu_1;
       case pozicia[chu_zac]^.ch[2] of
        'H':begin prvky(chu_zac,1);cha:=2;end;
        'D':if stavkl and 1=1 then begin prvky(chu_zac,2);cha:=1;{posun}end
            else begin prvky(chu_zac,1);cha:=2;{vlak}end;
        'E','N':begin prvky(chu_zac,2);cha:=1;end;
       end;
       with okno_nav do begin
        if slid>0 then begin
         if cisn<>chu_zac then mazidx(slid);
        end else slid:=vpol;
        cisn:=chu_zac;
        with slpoz[slid] do begin
         x:=cisn;cas:=caslong+300;nst:=100;
        end;
       end;
       vlozm(slpoz[okno_nav.slid].cas,okno_nav.slid);
       if stav and 2=2 then kresli_nav(1,0);
       case cha of
        2:setfillstyle(1,2);
        1:setfillstyle(1,7);
       end;
       bar(0,469,100,479);setcolor(0);
       outtextxy(2,467,'od '+sti(chu_zac,4,0));
      end;
  'K':if chu_zac>0 then begin {druhy bod cesty}
       chu_kon:=chu_1;
       {----- Vlakova cesta -----}
       if (cha=2)and(pozicia[chu_1]^.stav=0) then begin {koniec pre vlakovu cestu}
        test_cesty(chu_zac,chu_kon,v2);
        if pozicia[chu_zac]^.viac<>nil then begin {cestu je mozne postavit}
         with pozicia[chu_zac]^ do begin
          kresli_cesta(viac,pvlak,v2);{vykreslenie cesty}
          viac:=nil;
          pozicia[chu_zac]^.dl:=v2;        {zapisanie rychl. pri nav}
         end;
         case pozicia[chu_kon]^.ch[2] of
          'S':if pozicia[chu_zac]^.pvlak>0 then begin {vlak je pred navestidlom}
               najd_vlak(pozicia[chu_zac]^.pvlak,vmax,vakt,vpom);{najdenie vlaku}
               pozicia[pozicia[chu_zac]^.c[2]]^.y:=0;
               krstav(pozicia[chu_zac]^.c[2]);
               if v2=255 then v2:=pozicia[pozicia[chu_zac]^.c[1]]^.n[2];
               vpom:=v2;  {urcenie vmax pre cestu - rozbeh vlaku}
               aktu_vlak(vlak.cv1,vmax,vakt,vpom);
               prepocet(caslong+50,vlak.cv1);
               najd_vlak(vlak.cv1,vmax,vakt,vpom);
              end else begin {vlak nie je pred navestidlom}
               if pozicia[pozicia[chu_zac]^.c[2]]^.ch[2]='A' then begin
                with pozicia[pozicia[chu_zac]^.c[2]]^ do c[2]:=c[2] and 254;
                krstav(pozicia[chu_zac]^.c[2]);
               end;
              end;
          'B':if pozicia[chu_zac]^.pvlak>0 then begin {vlak je pred navestidlom a stoji}
               najd_vlak(pozicia[chu_zac]^.pvlak,vmax,vakt,vpom);
               zapis(pozicia[chu_kon]^.c[3],vlak.cv1);
               chu_1:=pozicia[chu_kon]^.c[2]; {Obsadenie tr. suhlasu}
               pozicia[chu_1]^.c[3]:=pozicia[chu_1]^.c[3] or 2;
               krstav(chu_1);
               pozicia[pozicia[chu_zac]^.c[2]]^.y:=0;
               krstav(pozicia[chu_zac]^.c[2]);
               if v2=255 then v2:=pozicia[pozicia[chu_zac]^.c[1]]^.n[2];
               vpom:=v2;  {urcenie vmax pre cestu - rozbeh vlaku}
               aktu_vlak(vlak.cv1,vmax,vakt,vpom);
               prepocet(caslong+50,vlak.cv1);
               najd_vlak(vlak.cv1,vmax,vakt,vpom);
              end else begin   {vlak nie je pred nav.}
               zapis(pozicia[chu_kon]^.c[3],pozicia[pozicia[chu_zac]^.c[2]]^.c[4]);
               chu_1:=pozicia[chu_kon]^.c[2]; {Obsadenie tr. suhlasu}
               pozicia[chu_1]^.c[3]:=pozicia[chu_1]^.c[3] or 2;
               krstav(chu_1);
               if pozicia[pozicia[chu_zac]^.c[2]]^.ch[2]='A' then begin
                with pozicia[pozicia[chu_zac]^.c[2]]^ do c[2]:=c[2] and 254;
                krstav(pozicia[chu_zac]^.c[2]);
               end;
              end;
         end;
        end else begin {cesta sa neda postavit}
         with pozicia[chu_zac]^ do begin stav:=0;pvlak:=0;rych:=255;end;
         with pozicia[chu_kon]^ do begin stav:=0;pvlak:=0;rych:=255;c[4]:=0;end;
         krstav(chu_zac);krstav(chu_kon);
        end;
       end;
       {----- KONIEC - Vlakova cesta -----}
       {----- Posunova cesta -----}
       if cha=1 then begin {koniec cesty pre posunovu cestu}
        test_cesty(chu_zac,chu_kon,v2);
        if pozicia[chu_zac]^.viac<>nil then begin {cestu je mozne postavit}
         with pozicia[chu_zac]^ do begin
          kresli_cesta(viac,pvlak,v2);{vykreslenie cesty}
          viac:=nil;
          pozicia[chu_zac]^.dl:=40;        {zapisanie rychl. pri nav}
         end;
         chu_kon:=pozicia[chu_zac]^.c[2];  {predosli usek}
         zlozenie:=pozicia[chu_kon]^.viac;
         k:=pozicia[chu_zac]^.sm;          {smer cesty}
         if zlozenie<>nil then begin {ak je tam nieco}
          if (zlozenie^[3-k]^.cislo shr 24)=2 then begin{pred nav. je Lv}
           i:=vpol;
           with slpoz[i] do begin {obsad navestidlo po case}
            x:=chu_zac;y:=zlozenie^[3-k]^.cislo;
            nst:=40+k;cas:=prip(caslong,random(100)+50);
           end;
           vlozm(slpoz[i].cas,i);
           zlozenie:=nil;
          end;
         end;
        end else begin      {cesta sa neda postavit}
         with pozicia[chu_zac]^ do begin stav:=0;pvlak:=0;rych:=255;end;
         with pozicia[chu_kon]^ do begin stav:=0;pvlak:=0;rych:=255;c[4]:=0;end;
         krstav(chu_zac);krstav(chu_kon);
        end;
        {----- KONIEC - Posunova cesta -----}
       end;
       chu_zac:=0;chu_kon:=0;
       setfillstyle(0,0);bar(0,469,100,479);
      end;
  'M','U','V':kr_info(chu_1);{vypisanie info o useku}
  'T':{otocenie TS}
      if (pozicia[chu_1]^.n[2]>0)and(pozicia[chu_1]^.c[3]=0) then{TS vidno a je volny}
       if pozicia[chu_1]^.n[1]=0 then begin {trat nie je AB}
        with pozicia[chu_1]^ do if stav=1 then stav:=2 else stav:=1;
        krstav(chu_1);
       end else begin                            {trat je AB}
        with pozicia[chu_1]^ do begin
         case stav of  {pozadovana zmena TS}
          1:stav:=2;
          2:stav:=1;
         end;
         stav:=stav or 4;
        end;
        prvky(chu_1,0);
        chu_kon:=pozicia[chu_1]^.n[1]; {najdenie nav}
        case pozicia[chu_kon]^.sm of {smer zmeny}
         1:i:=-1;
         2:i:=1;
        end;
        chu_kon:=chu_kon+i; {najdenie nasl.}
        repeat
         case pozicia[chu_kon]^.ch[2] of
          'A':begin j:=vpol;
               with slpoz[j] do  begin
                x:=chu_kon;nst:=30;cas:=caslong+10+random(20);y:=0;
               end;
               vlozm(slpoz[j].cas,j);
               with pozicia[chu_kon]^ do begin
                sm:=sm or 4;                   {zhasnutie AB}
                krstav(chu_kon);
                sm:=sm and 252;                {vynulovanie smeru}
                sm:=sm or pozicia[chu_1]^.stav;{novy smer+zhasnutie AB}
               end;
               pozicia[chu_1]^.c[3]:=pozicia[chu_1]^.c[3] or moc(pozicia[chu_kon]^.y);
               krstav(chu_1); { "obsadenie" TS}
               chu_kon:=chu_kon+i;
              end;
          'P':chu_kon:=chu_kon+i;
          'O':begin j:=pozicia[chu_kon]^.c[1];
               if i=1 then j:=j and 15 else j:=j shr 8;
               chu_kon:=chu_kon+dx[j]+dy[j]*xmax;
              end;
         end;
        until pozicia[chu_kon]^.ch[1]='N';
        if (pozicia[chu_kon]^.sm and 15)=pozicia[chu_1]^.stav and 3 then begin
         with pozicia[pozicia[chu_kon]^.c[2]]^ do c[2]:=c[2] or 1;
         chu_kon:=pozicia[pozicia[chu_kon]^.c[3]]^.n[3-pozicia[chu_1]^.stav and 3];{vystraha na Pr}
         with pozicia[pozicia[chu_kon]^.c[2]]^ do sm:=sm or 8;{poz. na zhasnutie}
        end else begin
         with pozicia[pozicia[chu_kon]^.c[2]]^ do sm:=sm or 8;{poz. na zhasnutie}
         chu_kon:=pozicia[pozicia[chu_kon]^.c[3]]^.n[pozicia[chu_1]^.stav and 3];{vystraha na Pr}
         with pozicia[pozicia[chu_kon]^.c[2]]^ do c[2]:=c[2] or 1;
        end;
       end;
  'Z':begin {vyber vlaku v ZB}
       chu_1:=pozicia[chu_1]^.dl; {zmena sur. na povodnu ZB}
       if (pozicia[chu_1]^.stav>0)and(pozicia[chu_1]^.sm shr 1>0) then begin
        v2:=4;
        case pozicia[chu_1]^.sm and 1 of
         0:begin
            if kx=chu_1+xmax then begin    {Prijatie}
             with slpoz[pozicia[chu_1]^.stav] do begin nst:=21;cas:=caslong+10;end;
             v2:=5; end;
            if kx=chu_1+xmax+2 then begin {Odmietnutie}
             with slpoz[pozicia[chu_1]^.stav] do begin nst:=20;cas:=caslong+400;end;
             v2:=6; end;
           end;
         1:begin
            if kx=chu_1 then begin    {Prijatie}
             with slpoz[pozicia[chu_1]^.stav] do begin nst:=21;cas:=caslong+10;end;
             v2:=5; end;
            if kx=chu_1+2 then begin {Odmietnutie}
             with slpoz[pozicia[chu_1]^.stav] do begin nst:=20;cas:=caslong+400;end;
             v2:=6; end;
           end;
        end;
        pozicia[chu_1]^.c[4]:=0; {v ZB uz nie je dotaz}
        if v2>4 then begin prvky(chu_1,0);
         case v2 of
          5:moznosti8_100(pozicia[chu_1]^.stav);{nst=20,21}
          6:vlozm(slpoz[pozicia[chu_1]^.stav].cas,pozicia[chu_1]^.stav);
         end;
         pozicia[chu_1]^.stav:=0;
        end;
       end;
      end;
 end;
stav:= stav and 251;  {koniec zakazu vypisu casu}
end;

procedure key_obsl;
begin
mousevyp;
getmousepos(mx,my);
stav:= stav or 4;  {zakaz vypisu casu}
kx:=cis((mx div krokx)+1,(my div kroky)+1);
case key of
 59{F1}:kr_info(kx);
 60{F2}:kr_infovlak(kx);
 68{F10}:pauza;
end;
key:=0;
stav:= stav and 251;  {koniec zakazu vypisu casu}
mousezap;
end;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ--------- Z A C I A T O K   H L A V N E H O   P R O G R A M U ----------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

begin
randomize;
dej_vrchol:=NIL;vlak_vrchol:=NIL; {Vycistenie Front}
igraph;imys;imenu('vybmen'); {Inicializacia grafiky, mysi a menu}
uvod;
{naz:=popen;}naz:='mala';pauz:=false;
cleardevice;setbkcolor(0);logo(215,305);
setlinestyle(0,0,1);settextstyle(2,0,4);setfillstyle(0,0);setcolor(5);
line((xmin-1)*krokx,(ymin-1)*kroky-1,xmax*krokx,(ymin-1)*kroky-1);{hranice plochy}
line((xmin-1)*krokx,ymax*kroky+1,xmax*krokx,ymax*kroky+1);
setfillstyle(0,0);bar(0,20,40,80);
kv_vlak;setcolor(5);rectangle(250,0,630,80);    {pragtron}
rectangle(0,16,50,80);{Volby}rectangle(54,0,120,80);{menu}
rectangle(124,0,213,80);{nasl.vlaky}rectangle(0,0,50,12);{cas}
setcolor(15);outtextxy(3,16,'๖');
tlacidko(596,463,false,'Koniec');tlacidko(550,463,false,'Debug');
setcolor(14);outtextxy(3,66,sti(body,5,0));
settextjustify(centertext,toptext);
setcolor(6);
outtextxy(getmaxx div 2,240,'Inicializujem subory. Prosim cakajte.');
setcolor(9);
outtextxy(getmaxx div 2,190,'ฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒ');
outtextxy(getmaxx div 2,200,'ฒฒฒ  þ Ing. Peter VOJTECH ml. ๘  ฒฒฒ  v. 1.2  ฒฒฒ Edition 3 ฒฒฒ');
outtextxy(getmaxx div 2,210,'ฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒฒ');
setcolor(14);
outtextxy(getmaxx div 2,150,'Simulator elektronickeho stavadla. Subor: '+naz);
settextjustify(lefttext,toptext);
casre:=8*60+05;{zaciatocny cas v minutach h*60+m}
casre:=casre*6000;hodiny.cas:=casre;caszac:=casre div 10;
pripocitaj:=false;caslong:=caszac;
delay(1000);setfillstyle(0,0);bar(0,130,getmaxx,400);
setcolor(8);vycisti;reset(usek);
 {--- Nacitanie a vykreslenie plochy ---}
for i:=0 to filesize(usek)-1 do begin
 seek(usek,i);read(usek,charusk);
 if charusk.ch[1]<>'X' then begin
  new(pozicia[charusk.xs]);
  with pozicia[charusk.xs]^ do begin  {vyplnenie prvku pozicie}
   if charusk.ch[1]='T' then stav:=charusk.sm else stav:=0;
   pvlak:=0;rych:=255;ch[1]:=charusk.ch[1];ch[2]:=charusk.ch[2];
   y:=charusk.y;dl:=charusk.dl;n[1]:=charusk.nx0;n[2]:=charusk.ty0;
   sm:=charusk.sm;odk:=charusk.odk;viac:=nil;
   for j:=1 to 4 do c[j]:=charusk.c[j];
  end;
  krstav(charusk.xs);
  case charusk.ch[1] of
   'Z':case charusk.sm and 1 of
        0:for j:=0 to (charusk.sm shr 1) do
           for k:=0 to 2 do begin
            kx:=charusk.xs+k+xmax*j;
            pozicia[kx]:=pozicia[charusk.xs];
            pozicia[kx]^.dl:=charusk.xs;
           end;
        1:for j:=0 to (charusk.sm shr 1) do
           for k:=0 to 2 do begin
            kx:=charusk.xs+k-xmax*j;
            pozicia[kx]:=pozicia[charusk.xs];
            pozicia[kx]^.dl:=charusk.xs;
           end;
       end;
   'T':prvky(charusk.xs,pozicia[charusk.xs]^.stav);
  end;
 end;
end;
 {---- Vypisanie textov ----}
reset(strsu);new(txt);
setcolor(11);
while not(eof(strsu)) do begin
 read(strsu,txt^);
 if txt^.tex[1]='#' then begin
  delete(txt^.tex,1,1);
  outtextxy(sux(txt^.xs)*krokx-5,suy(txt^.xs)*kroky-7,txt^.tex);
 end else
  outtextxy(sux(txt^.xs)*krokx-5,suy(txt^.xs)*kroky-9,txt^.tex);
end;
close(strsu);dispose(txt);
 {---- Nacitanie vlaku -----}
reset(svlak);caspom:=caslong div 600;ca:=false;
while (not(eof(svlak)))and(not ca) do begin
 read(svlak,vlak); {najdenie vlaku, co prvy vojde do oblasti}
 if vlak.casz>caspom then ca:=true;
end;
i:=1;ca:=false;
repeat             {zaradenie vlaku a najdenie vlakov s rovnakym casom}
 if pozicia[vlak.mz]^.ch[1]+pozicia[vlak.mz]^.ch[2]='MZ' then begin
  with slpoz[i] do begin
   nst:=20;x:=filepos(svlak)-1;
   cas:=vlak.casz;cas:=prip(cas*600,random(300));y:=vlak.cv1;
  end;
  vlozm(slpoz[i].cas,i);
 end;
 kx:=vlak.casz;
 read(svlak,vlak);
 if kx=vlak.casz then inc(i) else ca:=true;
until ca;
with slpoz[i+1] do begin
 nst:=22;x:=filepos(svlak)-1;y:=0;cas:=vlak.casz;cas:=cas*600;
end;
vlozm(slpoz[i+1].cas,i+1);
reset(svlak);      {vlaky uz v oblasti}
repeat
 read(svlak,vlak);
 ca:=false;mx:=0;i:=1;
 while (not ca)and(i<mstan) do begin
  chu_zac:=0;
  if (vlak.stco[i]>0)and(vlak.stco[i]>=caspom)and(vlak.casz<=caspom)and
     (pozicia[vlak.stm[i]]^.ch[1]='S')and(vlak.stm[i]<>vlak.mo) then begin
   ca:=true;mx:=1;
   repeat
    chu_zac:=0;pomv:=pozicia[vlak.stm[i]]^.c[mx] and 4095;
    if pomv=vlak.stm[i+1] then begin
     pomv:=pozicia[vlak.stm[i]]^.c[mx] shr 16;chu_zac:=pomv;end
    else inc(mx);
   until chu_zac>0;
   if pozicia[chu_zac]^.pvlak>0 then begin {je uz kolaj obsadena vlakom?}
    if pozicia[vlak.stm[i]]^.c[mx] shr 15 and 1=1 then inc(chu_zac,xmax)
    else dec(chu_zac,xmax);
    k:=pozicia[vlak.stm[i]]^.c[mx] shr 12 and 3;
    if pozicia[vlak.stm[i]]^.c[mx] shr 14 and 1=1 then inc(chu_zac,k)
    else dec(chu_zac,k);
   end;
   with pozicia[chu_zac]^ do begin
    stav:=3;pvlak:=vlak.cv1;c[4]:=vlak.cv1;y:=2;
    vlozk_vlak(vlak.cv1,vlak.vm,0,0,filepos(svlak)-1); {zapisanie noveho}
    j:=vpol;
    with slpoz[j] do begin
     x:=chu_zac;nst:=8;cas:=vlak.stco[i]-1;cas:=600*cas;y:=vlak.cv1;
     pomv:=vlak.stco[i];pomv:=pomv*600;
     if cas<caslong then begin
      cas:=pomv;pozicia[x]^.y:=3;nst:=9;
      if cas<caslong then cas:=caslong+100;
     end;
    end;
    krstav(slpoz[j].x);slpoz[j].cas:=prip(slpoz[j].cas,random(100));
    vlozm(slpoz[j].cas,j);
   end;
  end;
  inc(i);
 end;
 if (vlak.cv1<>vlak.cv2)and(chu_zac=0)and(vlak.casz<=caspom) then begin     {precislovanie v oblasti}
  kx:=filepos(svlak)-1;pomv:=vlak.cv2;slcas:=vlak.cv1;
  reset(svlak);ca:=false;i:=1;
  while not(eof(svlak)) and (not ca) do begin
   read(svlak,vlak);
   if pomv=vlak.cv1 then ca:=true;
  end;
  if not(ca) then error1('Error 003 - Precislovanie v oblasti','Chybne zadanie v subore '+naz+'.gvd');
  pomv:=vlak.casz;pomv:=pomv*600;
  {if pomv>caslong then begin
   mx:=1;
   repeat
     chu_zac:=0;pomv:=pozicia[vlak.mz]^.c[mx] and 4095;
    if pomv=vlak.stm[1] then begin
     pomv:=pozicia[vlak.mz]^.c[mx] shr 16;chu_zac:=pomv;end
    else inc(mx);
   until chu_zac>0;
   with pozicia[chu_zac]^ do begin
    stav:=3;pvlak:=vlak.cv1;c[4]:=vlak.cv1;y:=2;
    vlozk_vlak(vlak.cv1,vlak.vm,0,0,filepos(svlak)-1); {zapisanie noveho}
    {j:=vpol;
    with slpoz[j] do begin
     x:=chu_zac;nst:=8;cas:=vlak.casz-1;cas:=600*cas;y:=vlak.cv1;
     if cas<caslong then begin
      cas:=prip(cas,600);pozicia[x]^.y:=3;nst:=9;
      if cas<caslong then cas:=caslong+100;
     end;
    end;
    krstav(slpoz[j].x);slpoz[j].cas:=prip(slpoz[j].cas,0);
    vlozm(slpoz[j].cas,j);
   end;
  end;}
  seek(svlak,kx);
  read(svlak,vlak);
 end;
until vlak.casz>caspom;
kv_vlak;chu_zac:=0;
{!!!!}
 {---- Zavedenie prerusenia -----}
getintvec($1C,@IntVec);
setintvec($1C,addr(hodinky));   {int. - cas}
getintvec($09,@IntVec1);
setintvec($09,addr(klavesnica));{int. - klavesnica}
mousezap;key:=0;
 {---- Zaciatok hlavnej slucky ----}
repeat
 if tlacitka(dvoj)>0 then mys_stl:=1 else mys_stl:=0;
 tlac:=0;
 repeat         {Zasc. ciklu pre mys a cas}
  if (tlacitka(dvoj)>0)and(mys_stl=1) then mys_stl:=1 else mys_stl:=0;
  case mys_stl of
   0:begin tlac:=tlacitka(dvoj);
      if tlac>0 then mys_stl:=1;end;
   1:tlac:=0;
  end;
  if stav and 1=1 then begin
   stav:=stav and 254;
   caslong:=casre div 10;
   while (caslong>=dej_vrchol^.cas)and(dej_vrchol<>NIL) do begin
    {hodnoty(1);}
    slind:=mazf;                     {kontrola dejov}
    if slind>0 then begin
     mousevyp;stav:=stav or 4;{zakaz vypisu casu a mysi}
     case slpoz[slind].nst of
      0:moznosti0(slind);
      1:moznosti1(slind);
      2:moznosti2(slind);
      3:moznosti3(slind);
      41,42:moznosti4(slind);
      49:moznosti49(slind);
      5:moznosti5(slind);
      6:moznosti6(slind);
      7:moznosti7(slind);
      8..40,50..100:moznosti8_100(slind);
     end;
     mousezap;stav:= stav and 251;{koniec zakazu vypisu casu a mysi}
    end;
   end;
  end;
  if stav and 8=8 then begin
   stav:=stav and $F7;{vynulovanie}
   key_obsl;
  end;
 until (tlac=1)or(tlac=2);  {Koniec ciklu pri stlac. tlac. mysi}
mousevyp;
getmousepos(mx,my);
if tlac=1 then
case my of
 0..80:case mx of
        3..21:case my of
               21..30:begin
                  if stav and 2=2 then stav:=stav and 253 else stav:=stav or 2;
                  setcolor(15);
                  if stav and 2=2 then begin
                   setcolor(0);line(3,19,9,28);line(9,19,3,28);setcolor(15);
                   outtextxy(3,16,'๖');kresli_nav(0,0);
                  end else begin
                   setcolor(8);outtextxy(3,16,'๖');
                   setcolor(12);line(3,19,9,28);line(9,19,3,28);
                   setfillstyle(0,0);bar(217,0,247,95);
                  end;
                 end;
              end;
        58..116:if cis_menu>0 then begin
                 case cis_menu of
                  1:case my of
                     16..24:if pozicia[kx]^.stav in [1..2] then begin   {rus cestu}
                             with okno_nav do begin
                              if slid>0 then begin
                               if cisn<>kx then mazidx(slid);
                              end else slid:=vpol;
                              cisn:=kx;
                              with slpoz[slid] do begin
                               x:=cisn;cas:=caslong+300;nst:=100;
                              end;
                              vlozm(slpoz[slid].cas,slid);
                             end;
                             if stav and 2=2 then kresli_nav(1,0);
                             pozicia[kx]^.stav:=pozicia[kx]^.stav+4;
                             i:=vpol;
                             with pozicia[kx]^ do
                              if pozicia[c[2]]^.stav=3 then {je predosli obsadny}
                               case stav of
                                5:begin y:=1;k:=600;end;
                                6:begin y:=3;k:=1800;end;
                               end
                              else begin y:=5;k:=50;end;
                             with slpoz[i] do begin
                              nst:=10;x:=kx;
                              cas:=prip(caslong,k);
                             end;
                             prvky(kx,5);{vykresli nav+doba rusenia}
                             vlozm(slpoz[i].cas,i);
                             kr_menu(0,0);{zmaz menu}
                            end;
                     25..33:begin {rus volbu}
                             if chu_zac>0 then prvky(chu_zac,0);
                             chu_zac:=0;setfillstyle(0,0);bar(0,469,100,479);
                             cha:=0;kr_menu(0,0);{zmaz menu}
                            end;
                     34..42:if pozicia[kx]^.stav in [5..6] then begin    {spat DN}
                             i:=1;ca:=false;
                             while (i<(slmax+1))and(not ca) do begin
                              if (slpoz[i].nst=10)and(slpoz[i].x=kx) then begin
                               with slpoz[i] do begin nst:=-1;x:=0;y:=0;cas:=0;end;
                               pozicia[kx]^.stav:=pozicia[kx]^.stav-4;
                               krstav(kx);setfillstyle(0,0);bar(0,420,30,435);
                               ca:=true;
                              end;
                              i:=i+1;
                             end;
                             kr_menu(0,0);{zmaz menu}
                            end;
                    end;
                  2:begin
                     case my of
                      16..24:begin
                              with pozicia[kx]^ do begin
                               c[3]:=0;c[4]:=0;dl:=0;
                              end;
                              krstav(kx);
                             end;
                     end;
                     kr_menu(0,0);{zmaz menu}
                    end;
                 end;
                end;
       end;
 100..455:begin
           kx:=cis((mx div krokx)+1,(my div kroky)+1);tlac:=1;
           cesty_st;
           charusk.ch[1]:=' ';charusk.ch[2]:=' ';
          end;
 463..478:begin
           if (mx>=596)and(mx<=639) then tlacidko(596,463,true,'Koniec');
           if (mx>=550)and(mx<=595) then begin
            tlacidko(550,463,true,'Debug');
            writeln(pomoc,'Fronta DEJ');hodnoty(1);
            writeln(pomoc,'Fronta POM');hodnoty(2);
            writeln(pomoc,'Fronta vlak');hodnoty(3);
           end;
           if (my>468)and(mx>=105)and(mx<=355) then kr_info(0);
          end;
end;
if tlac=2 then
if cis_menu>0 then begin kr_menu(0,0);end
else begin
 kx:=cis((mx div krokx)+1,(my div kroky)+1);
 mysx:=mx;mysy:=my;
 if kx>0 then {klik mimo plochu existencie pozicie}
  case pozicia[kx]^.ch[1] of
   'N':kr_menu(1,0);
   'T':kr_menu(2,0);
  end;
end;
mousezap;
until (mx>=588)and(mx<=640)and(my>=458)and(my<=480)and(tlac=1);
setintvec($1C,@IntVec);setintvec($09,@IntVec1);
mousevyp;
closegraph;
writeln(' ');textcolor(11);
writeln('          ษอออออออออออออออออออออออออออออหออออออออหออออออออป');
writeln('          บ (c) Ing. Peter Vojtech 2005 บ UnIsiM บ (R) Vฆ บ');
writeln('          ศอออออออออออออออออออออออออออออสออออออออสออออออออผ');
textcolor(7);vycisti;
for i:=xmin to ((ymax-ymin)*xmax) do pozicia[i]:=NIL;
reset(vlc);close(vlc);reset(svlak);close(svlak);
delay(2000);
end.