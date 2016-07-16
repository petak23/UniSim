program SBkonv;
uses crt;
type vlcesta=record
      ch:char;
      zc,kc:word;
      vyh:array[1..20]of byte;
     end;
     vlcestanew=record
      ch:byte;
      zc,kc:word;
      vyh:array[1..20]of byte;
     end;
var i:word;
    vlakc:vlcesta;
    vlakcnew:vlcestanew;
    vlc:file of vlcesta;
    vlcnew:file of vlcestanew;
begin
clrscr;
assign(vlc,'c:\tp7\male\trschemy\mala.dvl');
assign(vlcnew,'c:\tp7\male\trschemy\mala.dv1');
reset(vlc);rewrite(vlcnew);
writeln('Konverzia suboru vlakovej cesty mala.dvl');
while not(eof(vlc)) do begin
 read(vlc,vlakc);
 vlakcnew.zc:=vlakc.zc;
 vlakcnew.kc:=vlakc.kc;
 case vlakc.ch of
  'V':vlakcnew.ch:=2;
  'P':vlakcnew.ch:=1;
 end;
 for i:=1 to 20 do vlakcnew.vyh[i]:=vlakc.vyh[i];
 write(vlcnew,vlakcnew);
end;
close(vlc);close(vlcnew);
erase(vlc);rename(vlcnew,'c:\tp7\male\trschemy\mala.dvl');
writeln('Koniec');
readln;
end.
