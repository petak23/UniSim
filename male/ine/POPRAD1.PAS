program navrh;
uses crt,dos,graph,menus,dswmouse,pomocny,deklar,sprites,smerniky;
var pocitadlo:longint;

procedure zz(c:word;s:string);
begin
with slpoz[c] do
writeln(pomoc,c,'/',x,'/',sux(x),'/',suy(x),'/',cas,'/',nst,'/',s,'/',pozicia[x].vlak,'/',caslong);
end;


procedure zapis(x:word;cv:longint);
  {Zapise do zapisovacej bunky cislo vlaku na prvu volnu poziciu}
var chu_za:chup;
    pom:boolean;
begin
 new(chu_za);pom:=false;
 hl_prvok(x,chu_za^);
 for i:=1 to 4 do
  if (chu_za^.c[i]=0)and(pom=false) then
   begin
    chu_za^.c[i]:=cv;
    pom:=true;
   end;
 seek(usek,filepos(usek)-1);write(usek,chu_za^);
 prvky(chu_za^,0,0);dispose(chu_za);
end;

procedure zmaz(x:word);
  {Zmaze zo zapisovacej bunky z 1. pozicie vlak a ostatne posunie}
var chu_zm:chup;
begin
 new(chu_zm);
 hl_prvok(x,chu_zm^);
 with chu_zm^ do begin
  c[1]:=c[2];c[2]:=c[3];c[3]:=c[4];c[4]:=0;
 end;
 seek(usek,filepos(usek)-1);write(usek,chu_zm^);
 prvky(chu_zm^,0,0);dispose(chu_zm);
end;

procedure rus_cesta(hx:byte);
var chu_hl,chu_hl1:chup;
begin
 new(chu_hl);hl_prvok(hx,chu_hl^);  {navestidlo stoj}
 pozicia[chu_hl^.xs].stav:=0;
 krstav(chu_hl^);
 if chu_hl^.ch[1]='N' then begin
  reset(cesta);new(chu_hl1);ca:=false;
  while (not(eof(cesta))) and (not ca) do begin
   read(cesta,chu_hl1^);
   if chu_hl1^.xs=chu_hl^.xs then ca:=true;
  end;
  k:=chu_hl1^.id;
  while k=chu_hl1^.id do begin
   pozicia[chu_hl1^.xs].stav:=0;
   if chu_hl1^.ch[2]='S' then begin
    hl_prvok(chu_hl1^.xs,chu_hl^);
    krstav(chu_hl^);
   end
   else krstav(chu_hl1^);
   chu_hl1^.id:=-1;seek(cesta,filepos(cesta)-1);
   write(cesta,chu_hl1^);
   if not(eof(cesta)) then read(cesta,chu_hl1^);
  end;
  ci_cesta;
 end;
 dispose(chu_hl);dispose(chu_hl1);
end;

procedure cesta_p(idc:word);
var fa:byte;
    chu_cesp:chup;

begin
reset(cesta);new(chu_cesp);
while not(eof(cesta)) do begin
 read(cesta,chu_cesp^);
 if chu_cesp^.id=idc then
 begin
  krstav(chu_cesp^);
 end;
end;
dispose(chu_cesp);
end;

function test_cesty(chu_testz,chu_testk:chu;var vm:byte):integer;
label koniec,obsad;
var zac,zaold:word;
    vmax,vyhpom:byte;
    smer,st1,stold:integer;
    i,cisvyh,pre_vlak:word;
    ch:char;
    chu_pom:chup;

begin
new(chu_pom);
hl_prvok(chu_testz.c[3],chu_pom^);
pre_vlak:=chu_pom^.c[1];
dispose(chu_pom);
test_cesty:=-1;vmax:=255;vyhpom:=1;
zac:=chu_testz.xs;cisvyh:=1;
reset(vlc);ca:=false;
while (not(eof(vlc))) and (not ca) do begin {najdenie vl. cesty, ktora sa stava}
 read(vlc,vlakc);
 if (vlakc.zc=chu_testz.xs)and(vlakc.kc=chu_testk.xs) then
  if cha=vlakc.ch then begin ca:=true;id:=filepos(vlc);end;
end;
if not ca then begin
 test_cesty:=-1;
 goto koniec;
end;
case chu_testz.sm of
 1,11:smer:=1;
 2,12:smer:=-1;
end;
case vlakc.ch of
 'V':st1:=2;
 'P':st1:=1;
end;
stold:=pozicia[zac].stav;
pozicia[zac].stav:=st1;
zaold:=zac;
chu_testz.id:=id;
reset(usek);reset(cesta);
polh:=filesize(cesta);seek(cesta,polh);
if chu_testz.ch[2]<>'O' then write(cesta,chu_testz);
zac:=zac+smer;
repeat;
hl_prvok(zac,chu_testz);
if (pozicia[zac].stav<>0)and(chu_testz.ch[2]<>'O') then begin
 obsad:
 reset(cesta);
 while not(eof(cesta)) do begin
  read(cesta,chu_testz);
  if chu_testz.id=id then begin
   chu_testz.id:=-1;seek(cesta,filepos(cesta)-1);write(cesta,chu_testz);
  end;
 end;
 pozicia[zaold].stav:=stold;
 goto koniec;
end;
if chu_testz.ch[2]='S' then chu_testz.nx0:=pre_vlak;
if (chu_testz.ch[2]='D') or (chu_testz.ch[2]='E') then chu_testz.ty0:=1;
chu_testz.id:=id;
case chu_testz.ch[1] of {vynechanie ak je odkaz, alebo nav.(to nema vpliv)}
 'U':case chu_testz.ch[2] of
      'B','P','U':begin write(cesta,chu_testz);pozicia[zac].stav:=st1;
                  end;
     end;
 'K':begin write(cesta,chu_testz);pozicia[zac].stav:=st1;end;
end;
case chu_testz.ch[2] of {Najdenie nasledujuceho prvku}
 'B':begin
      if vmax>chu_testz.ty0 then vmax:=chu_testz.ty0;
      k:=chu_testz.c[1];
      if smer=1 then k:=k mod 10 else k:=k div 100;
      zac:=zac+dx[k]+dy[k]*xmax;
     end;
 'O':begin
      case smer of
       1:zac:=chu_testz.nx0;
      -1:zac:=chu_testz.ty0;
      end;
     end;
 'H','D','E','K':
     case smer of
       1:case chu_testz.sm of
          1:zac:=chu_testz.c[1];
          2:zac:=chu_testz.c[2];
         end;
      -1:case chu_testz.sm of
          1:zac:=chu_testz.c[2];
          2:zac:=chu_testz.c[1];
         end;
     end;
 'P':begin zac:=zac+smer;
      if vmax>chu_testz.ty0 then vmax:=chu_testz.ty0;
     end;
 'S':begin
      case smer of
       1:zac:=zac+(chu_testz.c[4] mod 10)+2;
      -1:zac:=zac+(chu_testz.c[4] div 10)-2;
      end;
     end;
end;
if chu_testz.ch[1]='V' then begin
 chu_testz.sm:=vlakc.vyh[cisvyh];
 if chu_testz.sm>1 then vyhpom:=2;
 chu_testz.id:=id;
 if vmax>chu_testz.nx0 then
  if chu_testz.sm>1 then vmax:=chu_testz.nx0 else vmax:=chu_testz.ty0;
 write(cesta,chu_testz);pozicia[zac].stav:=st1;
 k:=chu_testz.c[vlakc.vyh[cisvyh]];
 if smer=1 then k:=k mod 10 else k:=k div 100;
 zac:=zac+dx[k]+dy[k]*xmax;cisvyh:=cisvyh+1;
end;
until chu_testz.xs=chu_testk.xs;
seek(cesta,polh);
if vyhpom>1 then begin
 while not(eof(cesta)) do begin
  read(cesta,chu_testz);
  if chu_testz.ch[1]='N' then chu_testz.dl:=vmax;
  case chu_testz.ch[2] of
   'B','P','S','A','R':chu_testz.ty0:=vmax;
  end;
  if chu_testz.ch[1]='V' then chu_testz.ty0:=vmax;
  seek(cesta,filepos(cesta)-1);write(cesta,chu_testz);
 end;
end else begin
 read(cesta,chu_testz);chu_testz.dl:=255;
 seek(cesta,filepos(cesta)-1);write(cesta,chu_testz);
end;
if chu_testk.ch[2]<>'S' then begin
 k:=chu_testk.c[1];
 if smer=1 then k:=k mod 10 else k:=k div 100;
 chu_testk.xs:=chu_testk.xs+dx[k]+dy[k]+xmax;
 if pozicia[chu_testk.xs].stav=3 then goto obsad;
end;
close(cesta);
vm:=vmax;
test_cesty:=id;
koniec:
end;

procedure hl_vlak(cas_akt:longint;var n_vlak:vlakk;var pos:word);
{Vyhladanie najblizsieho vlaku}
var cas_pom:longintp;
    vlak_pom:vlakkp;
begin
new(cas_pom);cas_pom^:=864000;pos:=0;
reset(svlak);new(vlak_pom);
with vlak_pom^ do begin
cv1:=0;cv2:=0;casz:=0;mz:=0;mo:=0;vm:=0;dl:=0;sm:=0;
end;
while not(eof(svlak)) do begin   {Hladanie do polnoci}
 read(svlak,vlak_pom^);
 if (cas_akt<vlak_pom^.casz)and(vlak_pom^.casz<cas_pom^) then begin
  n_vlak:=vlak_pom^;pos:=filepos(svlak)-1;
  cas_pom^:=vlak_pom^.casz;
 end;
end;
if vlak_pom^.cv1=0 then begin    {Hladanie po polnoci}
 reset(svlak);cas_pom^:=864000;
 while not(eof(svlak)) do begin
  read(svlak,vlak_pom^);
  if vlak_pom^.casz<cas_pom^ then begin
   n_vlak:=vlak_pom^;pos:=filepos(svlak)-1;
   cas_pom^:=vlak_pom^.casz;
  end;
 end;
end;
dispose(vlak_pom);dispose(cas_pom);
end;

procedure vyp_cesta(casz:longint;vlak1:vlakk;vlc:integer);
{Vypocita vlakovu cestu v stanici}
label zaciatok;
var chu_vc:chup;
    i,p,j,k:word;
begin
reset(cesta);new(chu_vc);
ca:=false;                       {najdenie prveho prvku cesty}
while (not(eof(cesta)))and(not ca) do begin
 read(cesta,chu_vc^);
 if chu_vc^.id=vlc then ca:=true;
end;
writeln(pomoc,'/',chu_vc^.xs,'/ / /',casz,'/ /','vyp.cesty pre>','/',vlak1.cv1,'/',caslong);
zaciatok:
repeat
 p:=filepos(cesta)-1;
 i:=vpol;
 slpoz[i].x:=chu_vc^.xs;
 slpoz[i].cas:=casz;
 pozicia[chu_vc^.xs].vlak:=vlak1.cv1;
 case chu_vc^.ch[1] of
  'N':slpoz[i].nst:=5;
  'U':case chu_vc^.ch[2] of
       'B','P':begin slpoz[i].nst:=6;
                casz:=slpoz[i].cas+((36*chu_vc^.dl)div chu_vc^.ty0);end;
      end;
  'K','V':begin slpoz[i].nst:=6;
            casz:=slpoz[i].cas+((36*chu_vc^.dl)div chu_vc^.ty0);end;
 end;
 if eof(cesta) then chu_vc^.id:=-1 else
  if chu_vc^.id=vlc then read(cesta,chu_vc^);
 vlozm(slpoz[i].cas,i);
 zz(i,'vyp.cesty');
until chu_vc^.id<>vlc;
seek(cesta,p);read(cesta,chu_vc^);
case chu_vc^.ch[2] of
 'S':begin
      case vlak1.sm of
       1:chu_vc^.xs:=chu_vc^.xs+(chu_vc^.c[4] mod 10)+2;
       2:chu_vc^.xs:=chu_vc^.xs-(chu_vc^.c[4] div 10)-2;
      end;
      k:=chu_vc^.xs;
      if pozicia[chu_vc^.xs].stav in[1..2] then begin
       reset(cesta);ca:=false;    {nasl. nav je postavene}
       while (not(eof(cesta)))and(not ca) do begin
        read(cesta,chu_vc^);
        if k=chu_vc^.xs then ca:=true;
       end;
       vlc:=chu_vc^.id;
       zz(i,'vyp.c.stk dalsia');
       goto zaciatok;
      end
      else slpoz[i].nst:=33;
      zz(i,'vyp.c.stk');
     end;
 'B':begin
      if chu_vc^.c[3]>0 then zapis(chu_vc^.c[3],vlak1.cv1);
      k:=chu_vc^.c[1];
      if vlak1.sm=1 then k:=k mod 10 else k:=k div 100;
      chu_vc^.xs:=chu_vc^.xs+dx[k]+dy[k]*xmax;
      hl_prvok(chu_vc^.xs,chu_vc^);
      if chu_vc^.ch[2]='O' then begin  {Ak je nasledujuci "UO" potom}
       case chu_vc^.sm of              {hladam jeho sekundarny odkaz}
        1:chu_vc^.xs:=chu_vc^.ty0;
        2:chu_vc^.xs:=chu_vc^.nx0;
       end;
       hl_prvok(chu_vc^.xs,chu_vc^);
       if chu_vc^.ch[1]='N' then
        if vlak1.sm=1 then chu_vc^.xs:=chu_vc^.xs+1
         else chu_vc^.xs:=chu_vc^.xs-1;
      hl_prvok(chu_vc^.xs,chu_vc^);
      end;
      pozicia[chu_vc^.xs].vlak:=vlak1.cv1;
      j:=vpol;
      slpoz[j].x:=chu_vc^.xs;
      slpoz[j].cas:=casz;slpoz[j].nst:=3;
      vlozm(slpoz[j].cas,j);
      zz(j,'vyp.c. B');
     end;
end;
dispose(chu_vc);
end;

procedure moznosti(j:word);
 {podla kodu v slpoz rozhoduje o delsom deji v bunkach}
var chu_mo,chu_mo1:chup;
    vmax,vakt,vpom:byte;
begin
mousevyp;new(chu_mo);new(chu_mo1);
with chu_mo^ do begin
 xs:=0;y:=0;for i:=1 to 4 do c[i]:=0;dl:=0;nx0:=0;ty0:=0;sm:=0;odk:=0;
end;
chu_mo1^:=chu_mo^;
case slpoz[j].nst of
   0..2,4:begin   {Uvolnenie medzistanicneho useku}
           hl_prvok(slpoz[j].x,chu_mo^);
           pozicia[chu_mo^.xs].stav:=slpoz[j].nst;
           caspom:=pozicia[chu_mo^.xs].vlak; {caspom len ako pomocna prem.}
           pozicia[chu_mo^.xs].vlak:=0;      {tu nema suvis s casom}
           krstav(chu_mo^);
           if slpoz[j].nst=1 then begin {ak je to miesto zmiznutia}
            zmaz(chu_mo^.c[3]);
            zmaz_vlak(caspom);
           end;
           slpoz[j].nst:=-1;zz(j,'uv kod 0..2,4');
          end;
   5:begin        {uvolnenie useku vo vlakovej ceste.}
           ca:=false;reset(cesta);    {najdenie prvku, co sa uvolnuje}
           while not(eof(cesta)) and (not ca) do begin
            read(cesta,chu_mo^);
            if chu_mo^.xs=slpoz[j].x then ca:=true;
           end;
           pozicia[chu_mo^.xs].stav:=0;
           seek(cesta,filepos(cesta)-1);chu_mo^.id:=-1;write(cesta,chu_mo^);
           if chu_mo^.ch[2]='S' then hl_prvok(chu_mo^.xs,chu_mo^);
           krstav(chu_mo^);slpoz[j].nst:=-1;ci_cesta;
           if chu_mo^.ch[2]='H' then begin ca:=false; {najdenie vlaku, co uvolnuje}
            reset(svlak);
            while not(eof(svlak)) and (not ca) do begin
             read(svlak,vlak);
             if pozicia[chu_mo^.xs].vlak=vlak.cv1 then ca:=true;
            end;
            hl_prvok(chu_mo^.c[3],chu_mo^); {vymazanie zo ZB}
            zmaz(chu_mo^.xs);
            zz(j,'uv kod 5');
           end;
          end;

   3:begin        {obsadenie medzistanicneho useku}
           hl_prvok(slpoz[j].x,chu_mo^);   {najdenie prvku co sa ma obsadit}
           pozicia[chu_mo^.xs].stav:=3;    {zmena stavu a jej vykreslenie}
           krstav(chu_mo^);
           reset(svlak);ca:=false;         {najdenie vlaku, ktory obsadil}
           while not(eof(svlak)) and (not ca) do begin
            read(svlak,vlak);
            if pozicia[chu_mo^.xs].vlak=vlak.cv1 then ca:=true;
           end;
           if (chu_mo^.ch[2]='B') and (chu_mo^.nx0=1) then begin
            reset(usek);                   {uzavretie priecestia}
            while not(eof(usek)) do begin  {ak je usek pribl. usekom}
             read(usek,chu_mo1^);
             if (chu_mo1^.ch[2]='P') then
              case vlak.sm of
               1:if chu_mo^.xs=chu_mo1^.c[2] then prvky(chu_mo1^,7,11);
               2:if chu_mo^.xs=chu_mo1^.c[1] then prvky(chu_mo1^,7,11);
              end;
            end;
           end;
           najd_vlak(vlak.cv1,vmax,vakt,vpom); {nacitanie rychl.vlaku}
           if (chu_mo^.ty0>=vmax)and(vmax<>vakt) then begin {test rychlosti.}
            {priprava na zmenu rychl. z vakt -> vmax}{zvysenie rychl.}
           end;
           if chu_mo^.ty0<vmax then begin
            if chu_mo^.ty0>vakt then begin {zvysenie rychl.}
             {priprava na zmenu rychl. z vakt -> chu_mo^.ty0}
            end;
            if chu_mo^.ty0<vakt then begin {znizenie rychl.}
             vpom:=vakt;vakt:=chu_mo^.ty0;caspom:=0;
             aktu_vlak(vlak.cv1,vmax,vakt,vpom);
             prepocet(caslong,vlak.cv1);
            end;
           end;
              {vypocet casu obsadenia nasledujuceho}
           slpoz[j].cas:=slpoz[j].cas+((36*chu_mo^.dl) div vakt);
           with chu_mo^ do
            case ch[2] of {vyhladanie nasledujuceho prvku}
             'B':begin koe:=c[1];
                  if vlak.sm=1 then koe:=koe mod 10 else koe:=koe div 100;
                  xs:=xs+dx[koe]+dy[koe]*xmax;
                 end;
         'P','R':case vlak.sm of
                  1:xs:=xs+1;
                  2:xs:=xs-1;
                 end;
            end;
           hl_prvok(chu_mo^.xs,chu_mo^); {najdenie nasledujuceho}
           pozicia[chu_mo^.xs].vlak:=vlak.cv1;{cislo pre nasledujuci}
           if (chu_mo^.ch[1]+chu_mo^.ch[2]='NH') then begin {ak je NH}
            if pozicia[chu_mo^.xs].stav=2 then begin{ak je postavena cesta}
             reset(cesta);ca:=false;          {najdenie cesty v sub. cesta}
             while (not(eof(cesta))) and (not ca) do begin
              read(cesta,chu_mo1^);
              if chu_mo^.xs=chu_mo1^.xs then ca:=true
             end;
             vyp_cesta(slpoz[j].cas,vlak,chu_mo1^.id);{vypocet cesty}
             slpoz[j].cas:=slpoz[j].cas+((360*vlak.dl)div vakt);{cas uvolnenia}
             slpoz[j].nst:=0;
             vlozm(slpoz[j].cas,j);
             zz(j,'j-ob kod 3 je VN post.');
            end
            else begin         {ak nie je postavena cesta-zalozi odkaz 25}
             slpoz[j].nst:=25; {na neskorsi vypocet}
             zz(j,'j-ob kod 3 je VN nepost.');
            end;
           end
           else begin  {ak nie je NH}
            if (chu_mo^.ch[1]+chu_mo^.ch[2]='MZ') then begin {ak je MZ}
             i:=vpol;
             slpoz[i].cas:=slpoz[j].cas+((360*vlak.dl) div k);
             slpoz[i].x:=chu_mo^.xs;slpoz[i].nst:=1;
             slpoz[j].cas:=slpoz[i].cas;
             slpoz[j].nst:=0;
             zz(i,'i-ob kod 3 je MZ');zz(j,'j-ob kod 3 je MZ');
            end
            else begin               {ak nie je MZ}
             i:=vpol;
             slpoz[i].cas:=slpoz[j].cas;slpoz[i].x:=chu_mo^.xs;
             slpoz[i].nst:=3;
             slpoz[j].cas:=slpoz[j].cas+((360*vlak.dl)div k);
             slpoz[j].nst:=0;zz(i,'i-ob kod 3 nie je VN');zz(j,'j-ob kod 3 nie je VN');
            end;
            vlozm(slpoz[i].cas,i);vlozm(slpoz[j].cas,j);
           end;
     end;
   6,33:begin     {Obsadenie useku vo vlakovej ceste}
           ca:=false;reset(cesta);  {najdenie prvku,co sa ma obsadit a obsluha obsadenia}
           while not(eof(cesta)) and (not ca) do begin
            read(cesta,chu_mo^);
            if chu_mo^.xs=slpoz[j].x then ca:=true;
           end;
           pozicia[chu_mo^.xs].stav:=3;
           krstav(chu_mo^);
           if (chu_mo^.ch[2]='B') and (chu_mo^.nx0=1) then begin
            reset(usek);         {spustenie priecestia}
            while not(eof(usek)) do begin
             read(usek,chu_mo1^);
             if (chu_mo1^.ch[2]='P') then
              case vlak.sm of
               1:if chu_mo^.xs=chu_mo1^.c[2] then prvky(chu_mo1^,7,11);
               2:if chu_mo^.xs=chu_mo1^.c[1] then prvky(chu_mo1^,7,11);
              end;
            end;
           end;
           ca:=false;reset(svlak);             {najdenie vlaku, co obsadil}
           while not(eof(svlak)) and (not ca) do begin
            read(svlak,vlak);
            if pozicia[chu_mo^.xs].vlak=vlak.cv1 then ca:=true;
           end;
           if chu_mo^.ch[2]='O' then begin
            case chu_mo^.sm of
             1:hl_prvok(chu_mo^.nx0,chu_mo^);
             2:hl_prvok(chu_mo^.ty0,chu_mo^);
            end;
            zz(j,'nahr "O" obs kod 6,33');
           end;
           if chu_mo^.ty0<=vlak.vm then      {vypocet casu uvolnenia}
            slpoz[j].cas:=slpoz[j].cas+(36*chu_mo^.dl div chu_mo^.ty0)
           else
            slpoz[j].cas:=slpoz[j].cas+(36*chu_mo^.dl div vlak.vm);
           if slpoz[j].nst=33 then slpoz[j].nst:=25
           else begin              {ak nst=33 tak cas kedy sa ma obsadit nasl.}
            slpoz[j].nst:=5;       {usek ak nst=5 kedy sa ma uvolnit tento}
            if chu_mo^.ty0<=vlak.vm then
             slpoz[j].cas:=slpoz[j].cas+(360*vlak.dl div chu_mo^.ty0)
            else
             slpoz[j].cas:=slpoz[j].cas+(360*vlak.dl div vlak.vm);
           end;
           if slpoz[j].nst=5 then vlozm(slpoz[j].cas,j);
           zz(j,'obs kod 6,33');
     end;
   10:begin       {rusenie cesty}
       rus_cesta(slpoz[j].x);slpoz[j].nst:=-1;
       setfillstyle(1,0);bar(0,420,30,435);zz(j,'rus-kod 10');
      end;
   20:begin       {zaradenie dalsieho vlaku a najdenie noveho}
       reset(svlak);seek(svlak,slpoz[j].x);{najdenie vlaku}
       read(svlak,vlak);
       hl_prvok(vlak.mz,chu_mo^);      {najdenie miesta "zjavenia"}
       slpoz[j].nst:=3;                {nasledujuci stav}
       case vlak.sm of                 {najdenie nasleduj.}
        1:slpoz[j].x:=chu_mo^.xs+1;
        2:slpoz[j].x:=chu_mo^.xs-1;
       end;
       hl_prvok(slpoz[j].x,chu_mo1^);
       if chu_mo1^.ty0>vlak.vm then chu_mo1^.ty0:=vlak.vm;{urc. rychl. vlaku}
       vlozk_vlak(vlak.cv1,vlak.vm,chu_mo1^.ty0,chu_mo1^.ty0);{zapis rychl.}
       slpoz[j].cas:=caslong+((36*chu_mo^.dl)div vlak.vm);{vyp. obsad. nasl.}
       pozicia[chu_mo^.xs].vlak:=vlak.cv1;{cislo pre nasl. usek}
       hl_prvok(chu_mo^.c[3],chu_mo1^);{najdenie a zapisanie do ZB}
       zapis(chu_mo1^.xs,vlak.cv1);
       hl_vlak(caslong+1,vlak,k);      {najdenie nasledujuceho vlaku}
       i:=vpol;                        {zaradenie do fronty}
       slpoz[i].nst:=20;slpoz[i].x:=k;       {sl.[i] - nasled. vlak}
       slpoz[i].y:=0;slpoz[i].cas:=vlak.casz;{sl.[j] - obs. nasl. useku}
       vlozm(slpoz[j].cas,j);vlozm(slpoz[i].cas,i);
       zz(j,'j-kod 20');zz(i,'i-kod 20(nasl.vlak)');
      end;
   30,31:begin       {Neviem}
       if pozicia[slpoz[j].x].stav=0 then begin
        hl_prvok(slpoz[j].x,chu_mo^);
        case slpoz[j].nst of
         30:prvky(chu_mo^,8,0);
         31:prvky(chu_mo^,8,2);
        end;
       end;
       slpoz[j].nst:=-1;
       zz(j,'kod 30,31');
       end;
  end;
mousezap;dispose(chu_mo);dispose(chu_mo1);
end;

procedure cesty_st;
var chu_kon:chup;
begin
new(chu_kon);
chu_kon^.ch[1]:=' ';
hl_prvok(kx,charusk);
 case charusk.ch[1] of
  'N':if chu_zac^.ch[1]=' ' then begin
       chu_zac^:=charusk;
       case chu_zac^.ch[2] of
        'H':begin prvky(chu_zac^,2,1);cha:='V';end;
        'D':begin
             vmenum(mx,my,4,5,1,v1);nulmenu(mx,my,4,5,1);
             case v1 of
              4:begin prvky(chu_zac^,2,1);cha:='V';end;
              5:begin prvky(chu_zac^,1,2);cha:='P';end;
             end;
            end;
        'E','N':begin prvky(chu_zac^,1,2);cha:='P';end;
       end;
      end;
  'K':if chu_kon^.ch[1]=' ' then begin
       chu_kon^:=charusk;
       case chu_kon^.ch[2] of
        'S':begin
             cisc:=test_cesty(chu_zac^,chu_kon^,v2);chu_zac^.dl:=v2;
             if cisc>=0 then begin
              cesta_p(cisc);
              writeln(pomoc,'/',chu_zac^.xs,'/',chu_kon^.xs,'/ / / /','Postavenie vlc.','/ /',caslong);
              if pozicia[chu_zac^.c[2]].vlak>0 then begin
               ca:=false;reset(svlak);     {ak je vlak pred nav. najdenie ktory}
               while not(eof(svlak)) and (not ca) do begin
                read(svlak,vlak);        {najdenie vlaku}
                if pozicia[chu_zac^.c[2]].vlak=vlak.cv1 then ca:=true;
               end;
               k:=1;ca:=false;pozicia[chu_zac^.xs].vlak:=vlak.cv1;
               while (k<(slmax+1))and(not ca) do begin  {najdenie prvku}
                if slpoz[k].x=chu_zac^.c[2] then        {pred navestidlom}
                 case slpoz[k].nst of 25,33:ca:=true;end;
                if not ca then k:=k+1;
               end;
               caspom:=slpoz[k].cas;
               hl_prvok(chu_zac^.c[2],chary);
               case slpoz[k].nst of
                25:begin
                    slpoz[k].nst:=0;
                    if slpoz[k].cas<caslong then
                     slpoz[k].cas:=slpoz[k].cas+50+(caslong-caspom);
                    caspom:=slpoz[k].cas;
                   end;
                33:begin
                    slpoz[k].nst:=6;
                    if chary.ty0<vlak.vm then
                     slpoz[k].cas:=slpoz[k].cas+((36*chary.dl)div chary.ty0)
                    else
                     slpoz[k].cas:=slpoz[k].cas+((36*chary.dl)div vlak.vm);
                    caspom:=slpoz[k].cas;
                   end;
               end;
               if chary.ty0<vlak.vm then
                slpoz[k].cas:=slpoz[k].cas+((360*vlak.dl)div chary.ty0)
               else
                slpoz[k].cas:=slpoz[k].cas+((360*vlak.dl)div vlak.vm);
               zz(k,'usek pred nav. uv');
               vlozm(slpoz[k].cas,k);
               vyp_cesta(caspom,vlak,cisc);
              end;
             end
             else begin krstav(chu_zac^);ci_cesta;end;
             chu_zac^.ch[1]:=' ';chu_kon^.ch[1]:=' ';chu_kon^.sm:=0;
            end;
        'B':if chu_kon^.sm>=10 then begin
             if cha='P' then prvky(chu_kon^,1,2) else prvky(chu_kon^,2,1);
             cisc:=test_cesty(chu_zac^,chu_kon^,v2);chu_zac^.dl:=v2;
             if cisc>=0 then begin
              cesta_p(cisc);
              if pozicia[chu_zac^.c[2]].vlak>0 then begin
               ca:=false;reset(svlak);       {ak je vlak pred nav. najdenie ktory}
               while not(eof(svlak)) and (not ca) do begin
                read(svlak,vlak);
                if pozicia[chu_zac^.c[2]].vlak=vlak.cv1 then ca:=true;
               end;
               k:=1;ca:=false;pozicia[chu_zac^.xs].vlak:=vlak.cv1;
               while (k<(slmax+1))and(not ca) do begin
                if slpoz[k].x=chu_zac^.c[2] then
                 case slpoz[k].nst of 25,33:ca:=true;end;
                if not ca then k:=k+1;
               end;
               caspom:=slpoz[k].cas;
               hl_prvok(chu_zac^.c[2],chary);
               case slpoz[k].nst of
                25:begin
                    slpoz[k].nst:=0;
                    if slpoz[k].cas<caslong then
                     slpoz[k].cas:=slpoz[k].cas+50+(caslong-caspom);
                    caspom:=slpoz[k].cas;
                   end;
                33:begin
                    slpoz[k].nst:=6;
                    if chary.ty0<vlak.vm then
                     slpoz[k].cas:=slpoz[k].cas+((36*chary.dl)div chary.ty0)
                    else
                     slpoz[k].cas:=slpoz[k].cas+((36*chary.dl)div vlak.vm);
                    caspom:=slpoz[k].cas;
                   end;
               end;
               if chary.ty0<vlak.vm then
                slpoz[k].cas:=slpoz[k].cas+((360*vlak.dl)div chary.ty0)
               else
                slpoz[k].cas:=slpoz[k].cas+((360*vlak.dl)div vlak.vm);
               zz(k,'usek pred nav. uv');
               vlozm(slpoz[k].cas,k);
               vyp_cesta(caspom,vlak,cisc);
              end;
             end
             else begin krstav(chu_zac^);ci_cesta;end;
             chu_zac^.ch[1]:=' ';chu_kon^.ch[1]:=' ';chu_kon^.sm:=0;
            end;
       end;
      end;
  'T':if pozicia[charusk.xs].stav=1 then begin
       pozicia[charusk.xs].stav:=2;krstav(charusk);end
      else begin
       pozicia[charusk.xs].stav:=1;krstav(charusk);end;
 end;
dispose(chu_kon);
end;


{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ--------- Z A C I A T O K   H L A V N E H O   P R O G R A M U ----------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

begin
dej_vrchol:=NIL; {Vycistenie Front}
vlak_vrchol:=NIL;
igraph;imys;imenu('vybmen'); {Inicializacia grafiky, mysi a menu}
{uvod;delay(1000);
setlinestyle(0,0,1);
settextstyle(2,0,4);setfillstyle(0,0);
logo(235,305);
delay(1500);
naz:=popen;}naz:='mala';cleardevice;setbkcolor(0);
rewrite(cesta);close(cesta);reset(cesta);
logo(0,449);
setfillstyle(0,0);bar(0,129,639,401);setfillstyle(0,0);
setcolor(5);line(0,129,630,129);line(0,401,630,401);
setfillstyle(1,8);bar(250,0,630,100);setcolor(5);rectangle(250,0,630,100);
line(440,0,440,100);
tlacidko(588,458,false,'Koniec');
settextjustify(centertext,toptext);
setcolor(6);
outtextxy(getmaxx div 2,240,'Inicializujem subory. Prosim cakajte.');
setcolor(14);
outtextxy(getmaxx div 2,150,'Simulator elektronickeho stavadla. Subor: '+naz);
settextjustify(lefttext,toptext);
volba:=false;caszac:=288000;{8:00}
reset(usek);
while not(eof(usek)) do begin
 read(usek,charusk);
 if charusk.ch[1]='Z' then begin
  with charusk do for i:=1 to 4 do c[i]:=0;
  seek(usek,filepos(usek)-1);write(usek,charusk);
 end;
end;
reset(usek);
caslong:=caszac;
hl_vlak(caslong,vlak,j);  {Nacitanie prveho vlaku}
slpoz[1].nst:=20;slpoz[1].x:=j;slpoz[1].cas:=vlak.casz;
slpoz[1].y:=vlak.cv1;
vloz(slpoz[1].cas,1,1);     {Zaradenie prveho prvku do fronty}
zz(1,'zac 1.vlak');
delay(2500);setfillstyle(0,0);bar(0,130,639,400);setcolor(8);
for i:=0 to filesize(usek)-1 do begin
 read(usek,charusk);
 pozicia[charusk.xs].poz:=i;
 if charusk.ch[1]='T' then pozicia[charusk.xs].stav:=1
 else pozicia[charusk.xs].stav:=0;
end;
sfs(0);bar(239,239,getmaxx,260);
s:='';reset(usek);
for i:=0 to filesize(usek)-1 do begin
 seek(usek,i);read(usek,charusk);
 krstav(charusk);
 if charusk.ch[2]='A'then begin
  if charusk.sm=1 then charusk.xs:=charusk.xs+1
   else charusk.xs:=charusk.xs-1;
  hl_prvok(charusk.xs,charusk);
  if charusk.ch[2]='H'then begin
   seek(usek,i);read(usek,charusk);
   prvky(charusk,8,2);
  end;
 end;
end;
reset(usek);
for i:=0 to filesize(usek)-1 do begin
 seek(usek,i);read(usek,charusk);
 if charusk.ch[1]='T' then
  prvky(charusk,0,pozicia[charusk.xs].stav);
end;
reset(strsu);new(txt);  {Vypisanie textov}
while not(eof(strsu)) do begin
 read(strsu,txt^);
 if txt^.tex[1]='#' then begin
  delete(txt^.tex,1,1);
  pismo(sux(txt^.xs)*10-5,suy(txt^.xs)*10-3,txt^.tex,1,11);
 end
 else
  pismo(sux(txt^.xs)*10-5,suy(txt^.xs)*10-5,txt^.tex,1,11);
end;
close(strsu);dispose(txt);
sfs(1);bar(1,1,52,11);setcolor(12);rectangle(0,0,53,12);caspom:=caslong;
told.h:=caspom div 36000;caspom:=caspom mod 36000;told.m:=caspom div 600;
caspom:=caspom mod 600;told.s:=caspom div 10;told.d:=caspom mod 10;
setcolor(15);outtextxy(3,1,prcas(told.h,told.m,told.s));
mousezap;
po:=0;
with told do begin gettime(h,m,s,d);d:=d div 10;end;
pocitadlo:=0;

repeat         {Zac.  hlavnej slucky}
if tlacitka(dvoj)=1 then mys_stl:=1 else mys_stl:=0;
tlac:=0;
repeat         {Zasc. ciklu pre mys a cas}
getmousepos(mx,my);
if (tlacitka(dvoj)=1)and(mys_stl=1) then mys_stl:=1 else mys_stl:=0;
case mys_stl of
 0:begin tlac:=tlacitka(dvoj);
    if tlac>0 then mys_stl:=1;end;
 1:tlac:=0;
end;
gettime(tnew.h,tnew.m,tnew.s,tnew.d);tnew.d:=tnew.d div 10;
inc(pocitadlo);
if not((tnew.h=told.h)and(tnew.m=told.m)and(tnew.s=told.s)and(tnew.d=told.d)) then
 begin
  if tnew.s<told.s then
   caslong:=prip(caslong,((tnew.s+60)*10+tnew.d)-(told.s*10+told.d))
  else
   caslong:=prip(caslong,(tnew.s*10+tnew.d)-(told.s*10+told.d));
  if not((tnew.h=told.h)and(tnew.m=told.m)and(tnew.s=told.s)) then
   begin
   caspom:=caslong;told.h:=caspom div 36000;caspom:=caspom mod 36000;told.m:=caspom div 600;
   caspom:=caspom mod 600;told.s:=caspom div 10;told.d:=caspom mod 10;sfs(1);bar(1,1,{52}110,11);
   setcolor(15);outtextxy(3,1,prcas(told.h,told.m,told.s)+'   '+sti(caslong,5,0));
   setfillstyle(0,0);bar(1,19,150,29);
   outtextxy(2,20,'pocitadlo:'+sti(pocitadlo,7,0));
   pocitadlo:=0;
  end;
  told:=tnew;
 end;
while (caslong>=dej_vrchol^.cas){and(caslong-500<dej_vrchol^.cas)}and(dej_vrchol<>NIL) do begin
 slind:=mazf;                     {kontrola dejov}
 if slind>0 then moznosti(slind);
end;
until (tlac=1) or (tlac=2);  {Koniec ciklu pri stlac. tlac. mysi}

mousevyp;
if tlac=1 then
case my of
130..400:begin
 kx:=cis((mx div 10)+1,(my div 10)+1);tlac:=1;
 cesty_st;
 charusk.ch[1]:=' ';charusk.ch[2]:=' ';
end;
 458..478:if (mx>=588)and(mx<=640) then tlacidko(588,458,true,'Koniec');
end;
if tlac=2 then begin
 vmenum(mx,my,1,3,1,v1);nulmenu(mx,my,1,3,1);
 if (my>=130)and(my<=400) then begin
  kx:=cis((mx div 10)+1,(my div 10)+1);tlac:=1;delay(200);
  case v1 of
   1:begin prvky(chu_zac^,8,0);
      chu_zac^.ch[1]:=' ';
      cha:=' ';end;
   2:if pozicia[kx].stav in [1..2] then begin
      pozicia[kx].stav:=pozicia[kx].stav+4;
      hl_prvok(kx,charusk);krstav(charusk);i:=vpol;
      slpoz[i].nst:=10;slpoz[i].cas:=prip(caslong,50);
      slpoz[i].x:=kx;sfs(4);bar(0,420,30,435);
      setcolor(14);outtextxy(8,422,'5s');
      vlozm(slpoz[i].cas,i);zz(i,'rus cas pripr');
     end;
   3:if pozicia[kx].stav in [5..6] then begin
      i:=1;ca:=false;
      while (i<(slmax+1))and(not ca) do begin
       if (slpoz[i].nst=10)and(slpoz[i].x=kx) then begin
        slpoz[i].nst:=-1;pozicia[kx].stav:=pozicia[kx].stav-4;
        hl_prvok(kx,charusk);krstav(charusk);sfs(0);bar(0,420,30,435);
        ca:=true;zz(i,'rus na DN');
       end;
       i:=i+1;
      end;
     end;
  end;
 end;
end;
mousezap;
until (mx>=588)and(mx<=640)and(my>=458)and(my<=480)and(tlac=1);

mousevyp;
closegraph;
writeln(' ');
writeln('    ษอออออออออออออออออออออออออออออหออออออออหออออออออป');
writeln('    บ (c) Ing. Peter Vojtech 2002 บ UnIsiM บ (R) Vฆ บ');
writeln('    ศอออออออออออออออออออออออออออออสออออออออสออออออออผ');
reset(usek);
while not(eof(usek)) do begin
 read(usek,charusk);
 if charusk.ch[1]='Z' then begin
  with charusk do for i:=1 to 4 do c[i]:=0;
  seek(usek,filepos(usek)-1);write(usek,charusk);
 end;
end;
dispose(chu_zac);
close(usek);reset(cesta);close(cesta);reset(vlc);
close(vlc);reset(svlak);close(svlak);close(pomoc);
delay(2000);
end.