program VLkonv;
uses crt;
const mstan=10;
type vlakk=record
      cv1,cv2:longint;
      casz,mz,mo:word;
      vm,dl:byte;
      sm:shortint;
      stm:array[1..mstan]of word;{cis SB}
      stco:array[1..mstan]of word;{cas odchodu v min}
      stcp:array[1..mstan]of word;{cas prichodu v min}
     end;
     vlakknew=record
      cv1,cv2,clo:longint;
      casz,mz,mo:word;
      vm,dl:byte;
      sm:shortint;
      stm:array[1..mstan]of word;{cis SB}
      stco:array[1..mstan]of word;{cas odchodu v min}
      stcp:array[1..mstan]of word;{cas prichodu v min}
     end;
var i:word;
    vlak:vlakk;
    vlaknew:vlakknew;
    vls:file of vlakk;
    vlsnew:file of vlakknew;
begin
clrscr;
assign(vls,'c:\tp7\male\trschemy\mala.gvd');
assign(vlsnew,'c:\tp7\male\trschemy\mala.gv1');
reset(vls);rewrite(vlsnew);
writeln('Konverzia suboru vlakov mala.gvd');
while not(eof(vls)) do begin
 read(vls,vlak);
 vlaknew.cv1:=vlak.cv1;
 vlaknew.cv2:=vlak.cv2;
 vlaknew.casz:=vlak.casz;
 vlaknew.mz:=vlak.mz;
 vlaknew.mo:=vlak.mo;
 vlaknew.vm:=vlak.vm;
 vlaknew.dl:=vlak.dl;
 vlaknew.sm:=vlak.sm;
 vlaknew.clo:=0;
 for i:=1 to mstan do begin
  vlaknew.stm[i]:=vlak.stm[i];
  vlaknew.stco[i]:=vlak.stco[i];
  vlaknew.stcp[i]:=vlak.stcp[i];
 end;
 write(vlsnew,vlaknew);
end;
close(vls);close(vlsnew);
erase(vls);rename(vlsnew,'c:\tp7\male\trschemy\mala.gvd');
writeln('Koniec');
readln;
end.
