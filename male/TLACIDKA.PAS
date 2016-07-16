unit tlacidka;
interface
type tlac=record
     x,y,dx,dy:word;
     text:string;
     id:byte; {Identifik tor 0-stกskacie tlaกtko
                             1-zadavacie pole
                             2-bodkovacie tlacitko}
     end;
var  vybtl:file of tlac;
     poltl:tlac;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ D E K L A R A C I E ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

procedure itlob(tlob:string); {Priradenie suboru menu}
function hladaj_policko(xf,yf,k1,k2:word):word;
procedure kreslitl_vsetky;
procedure kreslitlf(i:word);
procedure kreslitl(i:word);

implementation

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ Procedury a funkcie ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

uses menus1,graph;
type sst=^string;
var i:word;

procedure itlob(tlob:string); {Priradenie suboru menu}
var dir:sst;
begin
 new(dir);
 getdir(0,dir^);
 assign(vybtl,dir^+'\fonty\'+tlob+'.obt');
 dispose(dir);
end;


function hladaj_policko;
var ok:boolean;
    dxp:word;
begin
 ok:=false;i:=k1;
 reset(vybtl);
 seek(vybtl,k1-1);
 repeat
  read(vybtl,poltl);
  with poltl do begin
   if dx=0 then dxp:=(length(text)+1)*odstup else dxp:=dx;
   if x+dxp>getmaxx then x:=getmaxx-dxp;if y+dy>getmaxy then y:=getmaxy-dy;
   if (x<xf)and(xf<x+dxp)and(y<yf)and(yf<y+dy) then begin
    hladaj_policko:=i;ok:=true;
   end;
  end;
  if not(ok) then
   if not(eof(vybtl)) then i:=i+1 else
    begin hladaj_policko:=0;ok:=true;end;
  if i>k2 then begin hladaj_policko:=0;ok:=true;end;
 until ok=true;
 close(vybtl);
end;

procedure kreslitl_vsetky;
begin
 reset(vybtl);
 while not(eof(vybtl)) do begin
  read(vybtl,poltl);
  with poltl do
   case id of
    0:tlacidko(x,y,dx,dy,false,text);
    1:zadokno(x,y,dx,dy,false);
    2:zaskrt_tl(x,y,dx,dy,false,text);
   end;
 end;
 close(vybtl);
end;

procedure kreslitlf(i:word);
begin
 reset(vybtl);seek(vybtl,i-1);read(vybtl,poltl);
 with poltl do
  case id of
   0:tlacidko(x,y,dx,dy,false,text);
   1:zadokno(x,y,dx,dy,false);
   2:zaskrt_tl(x,y,dx,dy,false,text);
  end;
 close(vybtl);
end;

procedure kreslitl(i:word);
begin
 reset(vybtl);seek(vybtl,i-1);read(vybtl,poltl);
 with poltl do
  case id of
   0:tlacidko(x,y,dx,dy,true,text);
   1:zadokno(x,y,dx,dy,true);
   2:zaskrt_tl(x,y,dx,dy,true,text);
  end;
 close(vybtl);
end;
end.