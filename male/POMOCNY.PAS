unit pomocny;
interface
uses deklar;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ D E K L A R A C I E ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

function prip(c:longint;a:longint):longint;
    {pripocita k c hodnotu a a zisti prekrocenie "24-tej" hodiny}
function prcas(hz,mz,sz:word):string;
    {Premiena cas v hz(hod) mz(min) sz(sek) na retazec s dlzkou udajov 2}
function cis(X,Y:integer):word;
    {vypocita zo suradnic dlhe cislo}
function sux(cis:word):word;
    {vypocita z dlheho cisla suradnicu x}
function suy(cis:word):word;
    {vypocita z dlheho cisla suradnicu y}
function vpol:integer;
    {Vracia prvu volnu poziciu v slpoz. Ak nenajde -1}
function typ_vlaku(cislo:longint):string;
    {Urci typ vlaku (R,Os,LV...) z cisla vlaku}
function moc(mocnina:byte):word;
    {Celociselna mocnina}
procedure vycisti;
    {vymaze pozostatky simulacie zo suboru usek}
procedure pr_body(vlak:longint;kod:byte);
    {pripocita podla cisla vlaku a kodu body}

implementation

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ Procedury a funkcie ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}


uses menus,dos,graph,crt;

function prip(c:longint;a:longint):longint;
{pripocita k c hodnotu a a zisti prekrocenie "24-tej" hodiny}
begin
if a<0 then begin
 writeln('Error 002 - กslo je menej ako 0 (',a,')-prip');
 writeln('Stlac "Enter"');
 readln;
 HALT(1);
end;
c:=c+a;
repeat
 if c>864000 then c:=c-864000;
until c<864000;
if c<0 then c:=864000+c;
prip:=c;
end;

function prcas(hz,mz,sz:word):string;
{Premiena cas v hz(hod) mz(min) sz(sek) na retazec s dlzkou udajov 2}
var s:string;
begin
if hz<10 then s:='0'+sti(hz,1,0)+':' else s:=sti(hz,2,0)+':';
if mz<10 then s:=s+'0'+sti(mz,1,0)+':' else s:=s+sti(mz,2,0)+':';
if sz<10 then s:=s+'0'+sti(sz,1,0) else s:=s+sti(sz,2,0);
prcas:=s;
end;

function cis(x,y:integer):word;
{vypocita zo suradnic dlhe cislo mimo hranic je to 0}
begin
 if (y>=ymin)and(y<=ymax) then cis:=x+(y-ymin)*xmax else cis:=0;
end;

function sux(cis:word):word;
{vypocita z dlheho cisla suradnicu x}
begin
sux:=cis mod xmax;
end;

function suy(cis:word):word;
{vypocita z dlheho cisla suradnicu y}
begin
suy:=(cis div xmax)+ymin;
end;

function vpol:integer;
{Vracia prvu volnu poziciu v slpoz. Ak nenajde -1}
var a:integer;
begin
 a:=1;
 while (slpoz[a].nst>=0)and(a<(slmax+1)) do inc(a);
 if a=(slmax+1) then begin
  writeln('Error 001 - nen jden  vo–n  poloha pre slpoz (i>',slmax,')');
  writeln('Stlac "Enter"');
  readln;
  HALT(1);
 end;
 vpol:=a;
end;

function typ_vlaku(cislo:longint):string;
 {Urci typ vlaku (R,Os,LV...) z cisla vlaku}
var dlzka:integer;
    cs:string[5];
begin
cs:=sti(cislo,5,0);dlzka:=length(cs);
case dlzka of
 1,2:typ_vlaku:='EC';
   3:if cs[1] in ['1'..'5'] then typ_vlaku:='IC' else typ_vlaku:='R';
   4:begin
      if (cs[1]='1')and(cs[2] in['0'..'6']) then typ_vlaku:='Rp'
      else
       if (cs[1]='1')and(cs[2] in['7'..'9']) then typ_vlaku:='Zr'
       else typ_vlaku:='Os';
      if (cs[1]='2')and(cs[2]='8')and(cs[3]='8') then typ_vlaku:='Sv';
     end;
   5:case cs[1] of
      '1':if cs[3] in['0'..'6'] then typ_vlaku:='R' else typ_vlaku:='Os';
      '2':typ_vlaku:='Os';
      '3','4':typ_vlaku:='Pn';
      '5':case cs[4] of
           '0':typ_vlaku:='Nex';
           '1','2':typ_vlaku:='Rn';
           '3','4':typ_vlaku:='KPS';
           '5','6','7':typ_vlaku:='Sn';
           '8','9':typ_vlaku:='Vn';
          end;
      '6':typ_vlaku:='Pn';
      '7':typ_vlaku:='Lv';
      '8':if cs[4] in['0'..'7'] then typ_vlaku:='Mn' else typ_vlaku:='Vl';
      '9':typ_vlaku:='Pv';
     end;
end;
end;

function moc(mocnina:byte):word;
    {Celociselna mocnina moc=2^mocnina}
begin
 moc:=1 shl (mocnina and $F);
end;

procedure vycisti;
    {vymaze cisla vlakov zo ZB}
begin
 reset(usek);
 while not(eof(usek)) do begin
  read(usek,charusk);
  case charusk.ch[1] of
   'Z':begin
        with charusk do for i:=1 to 4 do c[i]:=0;
        seek(usek,filepos(usek)-1);write(usek,charusk);
       end;
   'T':begin
        charusk.c[3]:=0;
        seek(usek,filepos(usek)-1);write(usek,charusk);
       end;
   'N':begin
        with charusk do begin c[4]:=0;dl:=0;nx0:=0;ty0:=0;end;
        seek(usek,filepos(usek)-1);write(usek,charusk);
       end;
   'V':if charusk.sm=0 then begin
        if charusk.ch[2]='K' then charusk.sm:=5
         else charusk.sm:=1;
        seek(usek,filepos(usek)-1);write(usek,charusk);
       end;
  end;
 end;
 close(usek);
end;

procedure pr_body(vlak:longint;kod:byte);
    {pripocita podla cisla vlaku a kodu body}
begin
 case kod of
  1:begin
     if vlak<99 then inc(body,20);
     if (vlak>100)and(vlak<999) then inc(body,15);
     if (vlak>1000)and(vlak<39999) then inc(body,10);
     if (vlak>40000)and(vlak<59999) then inc(body,7);
     if (vlak>60000)and(vlak<69999) then inc(body,5);
     if (vlak>70000)and(vlak<89999) then inc(body,3);
     if (vlak>90000)and(vlak<99999) then inc(body,1);
    end;
  2:begin
     if vlak<99 then inc(body,10);
     if (vlak>100)and(vlak<999) then inc(body,7);
     if (vlak>1000)and(vlak<39999) then inc(body,5);
     if (vlak>40000)and(vlak<59999) then inc(body,3);
     if (vlak>60000)and(vlak<69999) then inc(body,2);
     if (vlak>70000)and(vlak<99999) then inc(body,1);
    end;
 end;
 setfillstyle(0,0);bar(1,65,49,79);
 setcolor(14);outtextxy(3,66,sti(body,5,0));
end;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------------  Koniec  --------------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
end.
