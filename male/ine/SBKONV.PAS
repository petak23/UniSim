program SBkonv;
uses crt;
label zac;
const xmax=63;
var pok,pok1:longint;
    sm,sm1,sb,ck1,ck2,sma:word;
    pokus:text;
    ch:char;
begin
clrscr;
assign(pokus,'c:\tp7\male\ine\SBk.txt');
rewrite(pokus);
zac:
write('Zadaj SB: ');readln(sb);writeln(pokus,'Zaznam pre SB: ',sb:4);
writeln(pokus,' Sm  Ck1  Ck2   OUT');
repeat
 pok:=0;
 write('Zadaj smer (ak 0 tak koniec): ');readln(pok);sma:=pok;
 if pok>0 then begin
  write('Zadaj cislo kolaje: ');readln(pok1);ck1:=pok1;
  write('Zadaj cislo 2. kolaje: ');readln(sm1);ck2:=sm1;
  if sm1=0 then sm:=0
  else begin
   if sm1>pok1 then sm:=8 else sm:=0;
   sm1:=abs(pok1-sm1);
   if sm1>xmax then sm:=sm or 4;
   sm1:=abs(sm1-xmax);
  end;
  if sm1<4 then begin
   sm:=sm or sm1;
   pok1:=pok1 shl 4;
   pok1:=pok1 or sm;
   pok1:=pok1 shl 12;
   pok:=pok or pok1;
   writeln('Vysledok pre SB je: ',pok);
   writeln(pokus,sma:4,' ',ck1:4,' ',ck2:4,' ',pok:9);
  end else writeln('ERORR!!!!!!!!!!!!!!!!!!!!!!!!!!!');
 end;
until pok=0;
write('Dalsiu SB (a/n)');ch:=upcase(readkey);
if ch='A' then goto zac;
close(pokus);
end.
