program navrh;
uses crt;
type chu=record
      ch:array[1..2]of char;
      dl,nx0,ty0:longint;
      c:array[1..4] of longint;
      xs,ys,sm:byte;
      id:integer;
      odk:byte;
     end;
var charusk:chu;
    usek:file of chu;
    von,von1:text;
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

function prev(odka,dok:byte):word;
var a:string;
begin
a:='';for i:=odka to dok do a:=a+s[i];
val(a,j,i);prev:=j;
end;

begin
with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;
 end;
getdir(0,s);s:=s+'\trschemy';
assign(von,s+'\mala.txt');
assign(von1,s+'\mala1.txt');
assign(usek,s+'\mala.dat');s:='';
reset(von);reset(von1);rewrite(usek);
while not(eof(von)) do begin
with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;
 end;
 readln(von,s);
 with charusk do begin
  ch[1]:=s[1];ch[2]:=s[2];
  xs:=prev(4,6);ys:=prev(8,10);
  for k:=1 to 4 do c[k]:=prev(7+k*5,10+k*5);
  dl:=prev(32,37);nx0:=prev(39,43);ty0:=prev(45,49);
  sm:=prev(51,53);id:=prev(55,55);odk:=prev(57,57);
                 end;
 write(usek,charusk);
end;
writeln('Poprad  OK');
while not(eof(von1)) do begin
with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;
 end;
 readln(von1,s);
 with charusk do begin
  ch[1]:=s[1];ch[2]:=s[2];
  xs:=prev(4,6);ys:=prev(8,10);
  for k:=1 to 4 do c[k]:=prev(8+k*4,10+k*4);
  dl:=prev(28,33);nx0:=prev(35,39);ty0:=prev(41,45);
  sm:=prev(47,49);id:=prev(51,53);odk:=prev(55,55);
                 end;
 write(usek,charusk);
end;
writeln('mala OK');
delay(500);
close(usek);close(von);close(von1);
end.