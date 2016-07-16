program VlaToTxt;       {Prevod suboru MENO.dvl (vlak.cesty) do textoveho}
uses crt,deklar,menus;  {suboru MENOvl.txt - Momentalne MENO=mala}
const dlsub=1200;
var von:text;

function prev(input:word;po:byte):string;
var a:string;    {Prevod cisla input na retazec dlzky po}
begin
a:='';
if input>0 then begin
 a:=sti(input,po,0);
 if length(a)<po then
  for i:=1 to po-length(a) do a:='0'+a;
              end;
 if input=0 then for i:=1 to po do a:=a+'0';
prev:=a;
end;

{--- Zaciatok Hlavneho Programu ---}

begin
naz:='mala';
assign(von,ss+naz+'vl.txt');s:='';
reset(vlc);rewrite(von);
for k:=0 to filesize(vlc)-1 do begin
 with vlakc do begin
  ch:=' ';zc:=0;kc:=0;
  for i:=1 to 20 do begin vyh[i]:=0;odv[i]:=0;end;
 end;
 s:='';
 read(vlc,vlakc);
 with vlakc do begin
  s:=ch+' '+prev(zc,4)+' '+prev(kc,4)+' '+prev(ts,3)+' ';
  for j:=1 to 20 do begin
   if prev(vyh[j],1)='0' then s:=s+'_' else s:=s+prev(vyh[j],1);
   if prev(odv[j],1)='0' then s:=s+'_' else s:=s+prev(odv[j],1);
  end;
 end;
 writeln(von,s);
end;
writeln(naz+'vl  OK');
close(vlc);close(von);
delay(1000);
end.