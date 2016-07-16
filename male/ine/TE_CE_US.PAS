program test_cesty_usek;
uses crt,deklar;
var upr:boolean;
    s:string;
begin
reset(usek);k:=0;
while not(eof(usek)) do begin
 upr:=false;
 read(usek,charusk);
 with charusk do begin
  case ch[1] of
   'U','K':case ch[2] of
        'B','O':begin
             i:=c[1];str(i:3,s);
             case s[1] of
              '3','6','9':begin cha:=s[3];s[3]:=s[1];s[1]:=cha;
                                val(s,c[1],po);upr:=true;
                          end;
              '2','8':if (s[3]='1')or(s[3]='4')or(s[3]='7') then begin
                       val(s,c[1],po);upr:=true;
                       cha:=s[3];s[3]:=s[1];s[1]:=cha;end;
             end;
             case s[3] of
              '1','4','7':begin cha:=s[3];s[3]:=s[1];s[1]:=cha;
                                val(s,c[1],po);upr:=true;
                          end;
              '2','8':if (s[3]='3')or(s[3]='6')or(s[3]='9') then begin
                       val(s,c[1],po);upr:=true;
                       cha:=s[3];s[3]:=s[1];s[1]:=cha;end;
             end;
            end;
       end;
   'V':for j:=1 to 4 do begin
        i:=c[j];str(i:3,s);
             case s[1] of
              '3','6','9':begin cha:=s[3];s[3]:=s[1];s[1]:=cha;
                                val(s,c[j],po);upr:=true;
                          end;
              '2','8':if (s[3]='1')or(s[3]='4')or(s[3]='7') then begin
                       val(s,c[j],po);upr:=true;
                       cha:=s[3];s[3]:=s[1];s[1]:=cha;end;
             end;
             case s[3] of
              '1','4','7':begin cha:=s[3];s[3]:=s[1];s[1]:=cha;
                                val(s,c[j],po);upr:=true;
                          end;
              '2','8':if (s[3]='3')or(s[3]='6')or(s[3]='9') then begin
                       val(s,c[j],po);upr:=true;
                       cha:=s[3];s[3]:=s[1];s[1]:=cha;end;
             end;
       end;
  end;
 end;
 if upr then begin
  seek(usek,filepos(usek)-1);write(usek,charusk);k:=k+1;
 end;
end;
writeln('Koniec. Prevedenych ',k,' zmien.');readln;
end.