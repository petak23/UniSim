program prevod;
uses crt,dos;
type time=record
      h,m,s,d:word;
     end;
var i:word;
    menodir:string;
    ch,ch1:char;
    casvst,casout,casin:longint;
    dlvl,dlus,v:word;
    cas:time;

begin
cas.h:=0;cas.m:=0;cas.s:=0;cas.d:=0;
clrscr;
repeat
write('Cas vstup-long(0-koniec):');readln(casvst);
if casvst>0 then begin
 write('Dlzka useku:');readln(dlus);
 write('Dlzka vlaku:');readln(dlvl);
 write('Rychlost:');readln(v);
 casout:=casvst+trunc(36*(dlus+dlvl)/v);
 casin:=casvst+trunc(36*dlus/v);
 writeln('Dlzka useku: ',dlus,'m  Dlzka vlaku: ',dlvl,'m  Rychlost vlaku: ',v,'km/h');
 write('Cas VSTUPU : ',casvst,' = ');
 with cas do begin
  h:=casvst div 36000;casvst:=casvst mod 36000;m:=casvst div 600;
  casvst:=casvst mod 600;s:=casvst div 10;
  writeln(h:2,':',m:2,':',s:2);
 end;
 write('    ODCHODU : ',casout,' = ');
 with cas do begin
  h:=casout div 36000;casout:=casout mod 36000;m:=casout div 600;
  casout:=casout mod 600;s:=casout div 10;
  writeln(h:2,':',m:2,':',s:2);
 end;
 write('    VSTUP DALEJ : ',casin,' = ');
 with cas do begin
  h:=casin div 36000;casin:=casin mod 36000;m:=casin div 600;
  casin:=casin mod 600;s:=casin div 10;
  writeln(h:2,':',m:2,':',s:2);
 end;
 end;
until casvst=0;
end.