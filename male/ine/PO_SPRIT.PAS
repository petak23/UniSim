program pokus;
uses crt,deklar,smerniky,pomocny;

procedure hodnoty1(volba:byte);
 {vypisanie hodnot fronty. Volba urci frontu:1 - DEJ; 2 - POM}
var temp:dej_ukaz;
    poc:word;
begin
 clrscr;
 poc:=1;gotoxy(74,1);write(caslong);
 if volba=1 then temp:=dej_vrchol else temp:=pom_vrchol;
 if temp=NIL then begin
  gotoxy(20,12);
  textcolor(12);writeln('Zoznam je prazdny');textcolor(7);
 end else
  while temp<>NIL do begin
   gotoxy(1,poc);
   writeln(poc,'. cislo:',temp^.cislo:3,' <> cas:',temp^.cas:6,' NST:',slpoz[temp^.cislo].nst:3);
   temp:=temp^.dalsi;inc(poc);
  end;
end;


begin
 clrscr;
 write('caslong ?=');readln(caslong);
 hodnoty1(1);
 repeat
  i:=vpol;
  gotoxy(60,23);
  write('Zadaj cas:');readln(slpoz[i].cas);
  if slpoz[i].cas>0 then begin
   gotoxy(60,24);
   write('Zadaj nst:');readln(slpoz[i].nst);
   vlozm(slpoz[i].cas,i);
   hodnoty1(1);
  end;
 until slpoz[i].cas=0;
end.