program navrh;
uses crt,deklar,pomocny,menus;
const dlsub=1000;
var von,von1:text;
    ch:char;


function prev(input:word;po:byte):string;
var a:string;   {Prevod cisla input na retazec dlzky po}
begin
a:='';
if input>0 then begin
 a:=sti(input,po,0);
 if length(a)<po then for i:=1 to po-length(a) do a:='0'+a;
              end;
if input=0 then for i:=1 to po do a:=a+'0';
prev:=a;
end;

begin
with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
 for i:=1 to 4 do c[i]:=0;sm:=0;
 end;
writeln('Subor?(M-mala,C-cesta):');ch:=readkey;
case ch of
 'm','M':naz:='mala';
 'c','C':naz:='cesta';
end;
assign(von,ss+naz+'.txt');
assign(von1,ss+naz+'1.txt');
assign(usek,ss+naz+'.dat');s:='';
reset(usek);
rewrite(von);
rewrite(von1);
if filesize(usek)<dlsub then
 for k:=0 to filesize(usek)-1 do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;ys:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  read(usek,charusk);
  with charusk do begin
   s:=ch[1]+ch[2];
   s:=s+' '+prev(xs,3)+' '+prev(ys,3);
   for j:=1 to 4 do s:=s+' '+prev(c[j],4);
   s:=s+' '+prev(dl,6)+' '+prev(nx0,5)+' '+prev(ty0,5)+' '+prev(sm,3);
   s:=s+' '+prev(id,1)+' '+prev(odk,1)+' '+sti(cis(xs,ys),4,0);
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
   s:=s+' '+prev(id,3)+' '+prev(odk,1);
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
   s:=s+' '+prev(id,3)+' '+prev(odk,1);
                  end;
  writeln(von1,s);
 end;
end;
writeln(naz+' OK');
delay(1000);
close(usek);close(von);close(von1);
end.