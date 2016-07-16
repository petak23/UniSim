program navrhtext;
uses crt,deklar;
type tte=record       {Text}
      xs:word;
      tex:string;
      skr:string[3];
     end;
var ch:char;

begin
s:='s';clrscr;
writeln('Editor textov pre UnIsiM. Texty v subore:'+ss+naz+'.dtx');
new(txt);
with txt^ do begin xs:=0;ys:=0;tex:='';end;
if (s='N') or (s='n') then begin
 rewrite(strsu);
 repeat
  write('XS= ');readln(txt^.xs);
  if txt^.xs>0 then begin
   write('YS= ');readln(txt^.ys);
   write('TEXT= ');readln(txt^.tex);
   writeln('-----------------------');
   write(strsu,txt^);
  end;
 until txt^.xs=0;
 end
else begin
 reset(strsu);i:=0;
repeat
if not(eof(strsu)) then read(strsu,txt^);
writeln('XS=',txt^.xs,' YS=',txt^.ys,' txt^=',txt^.tex);
writeln('Zmena? Ano / Nie / Koniec ');
ch:=readkey;
case ch of
 'a','A':begin
          write('XS= ',txt^.xs,' =>');readln(txt^.xs);
          if txt^.xs>0 then begin
           write('YS= ',txt^.ys,' =>');readln(txt^.ys);
           write('TEXT= ',txt^.tex,' =>');readln(txt^.tex);
           writeln('-----------------------');
           seek(strsu,i);write(strsu,txt^);
          end;
         end;
 'k','K':txt^.xs:=0;
end;
i:=i+1;
until txt^.xs=0;
close(strsu);
end;
reset(strsu);i:=1;
while not(eof(strsu)) do begin
 read(strsu,txt^);
 writeln('XS=',txt^.xs,' YS=',txt^.ys,' TXT=',txt^.tex);
 inc(i);
 if i=26 then begin i:=1;readln;clrscr;end;
end;
dispose(txt);
writeln('V์pis ukonen์');
writeln('ษอออออออออออออออออออออออออออออหออออออออหออออออออป');
writeln('บ (c) Ing. Peter Vojtech 2002 บ UnIsiM บ (R) Vฆ บ');
writeln('ศอออออออออออออออออออออออออออออสออออออออสออออออออผ');
delay(2000);
end.