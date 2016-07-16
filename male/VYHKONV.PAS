program vyhkonv;
uses crt,deklar,pomocny,menus;
var ch1:char;
    sce:string;
    spoc:array[1..4] of string[4];
    sces:array[1..4] of string[3];
begin
 clrscr;
 writeln('Konverzia ciest pre vyhybky');
 reset(usek);
 while not(eof(usek)) do begin
  read(usek,charusk);
  if charusk.ch[1]='V' then begin
   with charusk do begin
    for i:=1 to 4 do begin
     pomv:=c[i] and 4095;
     sces[i]:=sti((pomv shr 8) and 15,1,0)+sti((pomv shr 4) and 15,1,0)+sti(pomv and 15,1,0);
     pomv:=(c[i] shr 12) and 15;spoc[i]:='';
     if pomv>0 then begin
      for j:=1 to 4 do begin
       if pomv and 1=1 then spoc[i]:=spoc[i]+'1'
        else spoc[i]:=spoc[i]+'0';
       pomv:=pomv shr 1;
      end;
     end else spoc[i]:='x';
    end;
    writeln(ch[1],ch[2],'-',xs:4,' Cesty:'
        ,sces[1]:3,'-',c[1] shr 16,'-',spoc[1],
     ',',sces[2]:3,'-',c[2] shr 16,'-',spoc[2],
     ',',sces[3]:3,'-',c[3] shr 16,'-',spoc[3],
     ',',sces[4]:3,'-',c[4] shr 16,'-',spoc[4],
     '  Upr.-a:');
    ch1:=upcase(readkey);
    if ch1='K' then exit;
    if ch1='A' then begin
     case ch[2] of
      'N':v1:=2;
      'K':v1:=4;
     end;
     for i:=1 to v1 do if c[i]>0 then begin
      write('Cislo odvr. vyh pre c. ',sces[i],' : ');readln(pomv);
      if pomv>0 then begin
       write('Odvr. cesty (XXXX X=0/1): ');readln(sce);
       pomv:=pomv shl 4;
       for j:=1 to 4 do if sce[j]='1' then pomv:=pomv or moc(j-1);
       pomv:=pomv shl 12;
       c[i]:=(c[i] and 4095)or pomv;
       writeln(c[i]);
      end;
     end;
     seek(usek,filepos(usek)-1);write(usek,charusk);
    end;
   end;
  end;
 end;
 close(usek);
 writeln('!!!!!!!!!!!!!!!!! K  O  N  I  E  C !!!!!!!!!!!!!!!!!!');
 readln;
end.