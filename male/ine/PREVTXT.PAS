program navrhtext;
uses crt,deklar,pomocny;
type tte=record       {Text}
      xs:word;
      tex:string;
      skr:string[3];
     end;
var ch:char;
    ttext:file of tte;
    ttex:tte;
begin
s:='s';clrscr;
writeln('Editor textov pre UnIsiM. Texty v subore:'+ss+naz+'.dtx');
new(txt);
with txt^ do begin xs:=0;ys:=0;tex:='';end;
reset(strsu);i:=0;
assign(ttext,ss+'mala.ntx');
rewrite(ttext);
repeat
if not(eof(strsu)) then read(strsu,txt^) else txt^.xs:=0;
ttex.xs:=cis(txt^.xs,txt^.ys);ttex.tex:=txt^.tex;
write('XS=',txt^.xs,' YS=',txt^.ys,' Pozicia=',ttex.xs,' txt^=',ttex.tex,' Skratka:');
readln(ttex.skr);
writeln('-------');
writeln('XS=',txt^.xs,' YS=',txt^.ys,' Pozicia=',ttex.xs,' txt^=',ttex.tex,' Skratka:',ttex.skr);
writeln('-------');
i:=i+1;
write(ttext,ttex);
until txt^.xs=0;
close(strsu);
reset(ttext);i:=1;
while not(eof(ttext)) do begin
 read(ttext,ttex);
 with ttex do
  writeln('XS=',xs,' TXT=',tex,' Skr=',skr);
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