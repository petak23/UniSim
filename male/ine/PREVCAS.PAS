program prevod;
uses crt,dos;
type time=record
      h,m,s,d:word;
     end;
var i:word;
    menodir:string;
    ch,ch1:char;
    caslong:longint;
    cas:time;

procedure napis;
begin
writeln('Smer long->normal l/L');
writeln('Smer normal->long n/N');
writeln('Koniec - k');
end;

begin
cas.h:=0;cas.m:=0;cas.s:=0;cas.d:=0;
clrscr;
napis;
repeat
ch:=readkey;
case ch of
 'l','L':with cas do begin
          write('Cas long: ');readln(caslong);
          h:=caslong div 36000;caslong:=caslong mod 36000;m:=caslong div 600;
          caslong:=caslong mod 600;s:=caslong div 10;
          writeln('Cas normal: ',h:2,':',m:2,':',s:2);
          napis;
         end;
 'n','N':with cas do begin
          write('Cas normal hod: ');readln(h);
          write('           min: ');readln(m);
          write('           sek: ');readln(s);
          write('           des: ');readln(d);
          caslong:=h;caslong:=caslong*36000+m*600+s*10+d;
          writeln('Cas long: ',caslong);
          napis;
         end;

end;
until ch='k';
end.