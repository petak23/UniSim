program navrh;
uses crt;
const dlsub=1200;
type time=record
      h,m,s:word;
     end;
     chu=record
      ch:array[1..2]of char;
      dl,nx0,ty0:word;
      c:array[1..4] of word;
      xs,ys,sm:byte;
       id:integer;
     end;
var charusk:chu;
    usek:file of chu;
    von,von1:text;
    s,m:string;
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

function prev(inp:word;po:byte):string;
var a:string;
begin
a:='';
if inp>0 then begin
 a:=sti(inp,po,0);if length(a)<po then for i:=1 to po-length(a) do a:='0'+a;
              end;
if inp=0 then for i:=1 to po do a:=a+'0';
prev:=a;
end;

begin
with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;
 end;
m:='cesta';
getdir(0,s);
assign(von,s+'\'+m+'.txt');
assign(von1,s+'\'+m+'1.txt');
assign(usek,s+'\'+m+'.dat');s:='';
reset(usek);rewrite(von);rewrite(von1);
if filesize(usek)<dlsub then
 for k:=0 to filesize(usek)-1 do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  read(usek,charusk);
  with charusk do begin
   s:=ch[1]+ch[2];
   s:=s+' '+prev(xs,3)+' '+prev(ys,3);
   for j:=1 to 4 do s:=s+' '+prev(c[j],3);
   s:=s+' '+prev(dl,6)+' '+prev(nx0,5)+' '+prev(ty0,5)+' '+prev(sm,3);
   s:=s+' '+prev(id,3);
                  end;
  writeln(von,s);
 end
else begin
 for k:=0 to dlsub do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  read(usek,charusk);
  with charusk do begin
   s:=ch[1]+ch[2];
   s:=s+' '+prev(xs,3)+' '+prev(ys,3);
   for j:=1 to 4 do s:=s+' '+prev(c[j],3);
   s:=s+' '+prev(dl,6)+' '+prev(nx0,5)+' '+prev(ty0,5)+' '+prev(sm,3);
   s:=s+' '+prev(id,3);
                  end;
  writeln(von,s);
 end;
 for k:=(dlsub+1) to filesize(usek)-1 do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  read(usek,charusk);
  with charusk do begin
   s:=ch[1]+ch[2];
   s:=s+' '+prev(xs,3)+' '+prev(ys,3);
   for j:=1 to 4 do s:=s+' '+prev(c[j],3);
   s:=s+' '+prev(dl,6)+' '+prev(nx0,5)+' '+prev(ty0,5)+' '+prev(sm,3);
   s:=s+' '+prev(id,3); 
                  end;
  writeln(von1,s);
 end;
end;
writeln(m+' OK');
close(usek);close(von);close(von1);
end.