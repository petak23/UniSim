program navrh;
uses crt;
type chu=record
      ch:char;
      zc,kc,ts:word;
      vyh,odv:array[1..20] of byte;
     end;
var charusk:chu;
    usek:file of chu;
    von:text;
    s:string;
    i,j,k:word;

function red(s:string):string;
begin
while(s[1]=' ') do delete(s,1,1);
red:=s;
end;

function sti(r:real;c,d:byte):string;
var s:string;
    a:boolean;
begin
 str(r:c:d,s);c:=length(s);
 if d>0 then begin
  repeat;a:=false;
  if s[c]='0' then begin delete(s,c,1);a:=true;c:=length(s);end;
  if s[c]='.' then delete(s,c,1);
  until a=false;
             end;
 sti:=red(s);
end;

function prev(odk,dok:byte):word;
var a:string;
begin
a:='';
for i:=odk to dok do a:=a+s[i];
 if (a='') or (a=' ') or (a='_') then a:='0';
val(a,j,i);prev:=j;
end;

begin
with charusk do begin ch:=' ';zc:=0;kc:=0;
 for i:=1 to 20 do begin vyh[i]:=0;odv[i]:=0;end;
 end;
getdir(0,s);
assign(von,s+'\malavl.txt');
assign(usek,s+'\malavl.dat');s:='';
reset(von);rewrite(usek);
while not(eof(von)) do begin
 with charusk do begin
  ch:=' ';zc:=0;kc:=0;
  for i:=1 to 20 do begin vyh[i]:=0;odv[i]:=0;end;
 end;
 s:='';
 readln(von,s);
 with charusk do begin
  ch:=s[1];
  zc:=prev(3,6);kc:=prev(8,11);ts:=prev(13,15);
  for k:=1 to 20 do begin
   vyh[k]:=prev(15+k*2,15+k*2);
   odv[k]:=prev(16+k*2,16+k*2);
  end;
 end;
 write(usek,charusk);
end;
writeln('Poprad  OK');
writeln('OK');
close(usek);close(von);
end.