unit menus;
interface
{Const InstalM: Boolean = False;
      PocTlac: Byte    = 0;      PoslTlac:Byte    = 0;
      CasStlac:LongInt = 0;      CasPauza:Byte    = 5;
      Zap:     Boolean = False;  Tlac:Byte        = 0;
Var Casovac:LongInt Absolute $0:$046C;  { Interny casovac pre INTEL 80x86 }
Var    MX,MY:Word;                         { S£radnice mysi                  }

{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª}
{∫------------------------ D E K L A R A C I E ---------------------------∫}
{»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}

Procedure MouseInst;                    { Zaktivuje driver pre mys v pamÑti }
Procedure MouseZap;                { Zapne mysac° kurzor v aktu†lnom rezime }
Procedure MouseVyp;                { Vypne mysac° kutzor v aktu†lnom rezime }
Procedure GetMousePos(Var X,Y:Word);          { Vr†ti okamzit£ poz°ciu mysi }
Procedure SetMousePos(X,Y:Word);         { Nastav° mys na stanoven£ poz°ciu }
Procedure SetX(Xmin,Xmax:Word);         { Nastav° rozsah horizont. s£radn°c }
Procedure SetY(Ymin,Ymax:Word);         { Nastav° rozsah vertik†l. s£radn°c }
Procedure MouseCitl(Kx,Ky:Word);                { Nastav° mysaciu citlivost }
Function Tlacitka(Var Dvojklik:Boolean):Word;     { Zist° stlacenÇ tlac°tka }

procedure imys;
procedure igraph;
procedure imenu(menu:string);  {Priradenie suboru menu}
function  hladaj(ms:string):boolean;
procedure kbd(var a:integer);
procedure vmenum(x,y:word;k1,k2,po:byte;var vyb:byte);
procedure nulmenu(x,y:word;k1,k2,po:byte);
function  vybe(i:integer):string;
procedure von(x,y,co,c,d:integer;cis:real);
function  red(s:string):string;
function  sti(r:real;c,d:byte):string;
procedure vstl(x1,y1,x2,y2:integer;tl:boolean;s:string);
procedure tlacidko(x,y:word;tl:boolean;s:string);

}
implementation
{
{…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª}
{∫------------------------ Procedury a funkcie ---------------------------∫}
{»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº}

uses crt,graph,dos{,sgraph};
type sst=^string;
var vel:array[1..3] of word;
    miesto:array[1..3]of pointer;
    vybmen:file of string;
    regs:Registers;

Procedure MouseInst;
Begin
  Regs.AX:=0;Intr($33,Regs);PocTlac:=Regs.BX;
  If Regs.AX>0 Then InstalM:=True;
End;


Procedure MouseZap;
Begin
 If (InstalM) and (Not Zap) Then
 Begin Regs.AX:=1; Intr($33,Regs); Zap:=True; End;
End;

Procedure MouseVyp;
Begin
 If (InstalM) and (Zap) Then
 Begin Regs.AX:=2; Intr($33,Regs); Zap:=False; End;
End;

Procedure GetMousePos(Var X,Y:Word);
Begin
 Regs.AX:=3; Intr($33,Regs); X:=Regs.CX; Y:=Regs.DX;
End;

Procedure SetMousePos(X,Y:Word);
Begin
 If InstalM Then Begin Regs.AX:=4; Regs.CX:=X; Regs.DX:=Y; Intr($33,Regs);
End; End;

Procedure SetX(Xmin,Xmax:Word);
Begin
 Regs.AX:=7; Regs.CX:=Xmin; Regs.DX:=Xmax; Intr($33,Regs);
End;

Procedure SetY(Ymin,Ymax:Word);
Begin
 Regs.AX:=8; Regs.CX:=Ymin; Regs.DX:=Ymax; Intr($33,Regs);
End;

Procedure MouseCitl(Kx,Ky:Word);
Begin
 Regs.AX:=15; Regs.CX:=Kx; Regs.DX:=Ky; Intr($33,Regs);
End;

Function Tlacitka(Var Dvojklik:Boolean):Word;
Var Buttons:Byte;
Begin
 If InstalM Then Begin
  Regs.AX:=3; Intr($33,Regs); Buttons:=Regs.BX;
  Tlacitka:=Buttons; Dvojklik:=False;
  Case Buttons Of 1:Buttons:=0;     2:Buttons:=1;
                  4:Buttons:=2;  Else Buttons:=3; End;
  If Buttons<3 Then Begin
   Regs.AX:=6; Regs.BX:=Buttons; Intr($33,Regs);
   If (Buttons=PoslTlac) And (Regs.BX>0) And (Casovac<CasStlac+CasPauza)
    Then Dvojklik:=True
    Else Begin CasStlac:=Casovac; PoslTlac:=Buttons; End;
  End;
 End Else Tlacitka:=0;
End;

procedure imys;
begin
mouseinst;
if instalm then begin
 mousezap;setx(0,getmaxx);sety(0,getmaxy);
 setmousepos(getmaxx div 2,getmaxy div 2);
 mousecitl(8,8);mousevyp;end
else begin
 writeln('Nie je v pamÑti zavedenÏ driver myÁi !!!');halt(1);end;
end;

procedure igraph;
var gd,gm:integer;
begin
gd:=InstallUserDriver('egavga',nil);gm:=2;
 {gr.dr = vesa256,bgi256,uni256      egavga
    gm  = 0   319*199                0  639*199
          1   639*399                1  639*349
          2   639*479                2  639*479
          3   799*599
          4  1023*767}

initGraph(gd,gm,'egavga');
gd:=graphresult;{gd-ako pom. premenna}
if graphresult <> grOK then begin
 writeln('Program konü° chybou: ',gd,'. Moßn† pr°üina :',grapherrormsg(gd));
 readln;
 HALT(1);end;

cleardevice;
end;

procedure imenu(menu:string); {Priradenie suboru menu}
var dir:sst;
begin
 new(dir);
 getdir(0,dir^);
 assign(vybmen,dir^+'\fonty\'+menu+'.mnu');
 dispose(dir);
end;

function hladaj(ms:string):boolean;
 var f:file;
 begin
  {$I-}
  assign(f,ms);reset(f);close(f);
  {$I+}
  hladaj:=(ioresult=0)and(ms<>'');
end;


procedure kbd(var a:integer);
var ch:char;
begin
a:=0;ch:=readkey;
if ord(ch)=0 then begin ch:=readkey;
                       a:=ord(ch)+256;end
                       else a:=ord(ch);
end;

procedure vmenum(x,y:word;k1,k2,po:byte;var vyb:byte);
var xmx,ymx,i,b,mx,my:word;     {menu s mysou}
    aa,mm:integer;
    dvoj:boolean;
    xold,yold:word; {zapametanie polohy mysi}

 procedure nulit;
 var i:byte;
 begin
  setfillstyle(1,7);bar(x+1,y+1,xmx-1,ymx-1);
  {setcolor(2);line(x,ymx,x,y);line(x,y,xmx-1,y);
  setcolor(3);line(xmx,y,xmx,ymx);line(xmx,ymx,x+1,ymx);}
  setcolor(4);
  for i:=k1 to k2 do outtextxy(x+10,y+(i-k1)*12+3,vybe(i));
 end;

begin
repeat
until tlacitka(dvoj)=0;
settextstyle(2,0,4);xmx:=0;x:=x-5;y:=y-5;
for i:=k1 to k2 do if (length(vybe(i))*8)>xmx then xmx:=length(vybe(i))*8;
if (xmx+x+20)>getmaxx then x:=getmaxx-xmx-20;
xmx:=x+xmx+20;
if (y+(k2-k1)*12+18)>getmaxy then y:=getmaxy-((k2-k1)*12)-18;
ymx:=y+(k2-k1)*12+18;
vel[po]:=imagesize(x,y,xmx,ymx);getmem(miesto[po],vel[po]);
getimage(x,y,xmx,ymx,miesto[po]^);nulit;
getmousepos(xold,yold);
setx(x+3,xmx-2);sety(y+2,ymx-2);
setmousepos(x+5,y+5);
b:=0;setfillstyle(1,4);bar(x+1,y+3,xmx-1,y+15);
setcolor(11);outtextxy(x+10,y+3,vybe(k1));
mousezap;
repeat
 getmousepos(mx,my);
 tlac:=tlacitka(dvoj);mm:=my;
 aa:=mm-y-5;
 if aa<0 then aa:=0;
 aa:=aa div 12;
 if aa>(k2-k1) then aa:=k2-k1;
 if aa<>b then begin
  mousevyp;nulit;setfillstyle(1,4);bar(x+1,y+3+aa*12,xmx-1,y+15+aa*12);
  setcolor(11);outtextxy(x+10,y+3+aa*12,vybe(aa+k1));b:=aa;mousezap;end;
until tlac=1;
mousevyp;
tlac:=0;
vyb:=aa+k1;
setmousepos(xold,yold);
end;

procedure pohy(i,j,k1,m,y,cpp,co,koe:integer);
var b,a,c,d:integer;
    q:sst;
begin
a:=y+(i-k1+1)*13;b:=y+(j-k1+1)*13;
new(q);
for c:=0 to koe-1 do begin
setcolor(co);d:=j+c;q^:=vybe(d);
if q^[length(q^)]='û' then delete(q^,length(q^),1);
outtextxy(m,b+13*c,q^);setcolor(cpp);d:=i+c;q^:=vybe(d);
if q^[length(q^)]='û' then delete(q^,length(q^),1);
outtextxy(m,a+13*c,q^);
                      end;
dispose(q);
end;


procedure nulmenu(x,y:word;k1,k2,po:byte);
var xmx,ymx,i:word;    {Pre menu s mysov}
begin
xmx:=0;x:=x-5;y:=y-5;
for i:=k1 to k2 do if (length(vybe(i))*8)>xmx then xmx:=length(vybe(i))*8;
if (xmx+x+20)>getmaxx then x:=getmaxx-xmx-20;
xmx:=x+xmx+20;
if (y+(k2-k1)*13+10)>getmaxy then y:=getmaxy-((k2-k1)*13)-10;
ymx:=y+(k2-k1)*13+10;
setfillstyle(1,0);bar(x,y,xmx,ymx);
putimage(x,y,miesto[po]^,0);
setx(0,getmaxx);sety(0,getmaxy);
end;

function vybe(i:integer):string;
var q:sst;
begin
new(q);
reset(vybmen);
seek(vybmen,i-1);
read(vybmen,q^);
close(vybmen);
vybe:=q^;dispose(q);
end;

procedure von(x,y,co,c,d:integer;cis:real);
begin
 setcolor(co);outtextxy(x,y,sti(cis,c,d));
end;


function red(s:string):string;
begin
while(s[1]=' ') do delete(s,1,1);
red:=s;
end;

function sti(r:real;c,d:byte):string;
var q:sst;
    a:boolean;
begin
 new(q);
 str(r:c:d,q^);c:=length(q^);
 if d>0 then begin
  repeat;
   a:=false;
   case q^[c] of
    '0':begin delete(q^,c,1);a:=true;c:=length(q^);end;
    '.':delete(q^,c,1);
   end;
  until a=false;
             end;
 sti:=red(q^);dispose(q);
end;

procedure vstl(x1,y1,x2,y2:integer;tl:boolean;s:string);
type farb=array[1..2,1..4]of byte;
const f:farb=((7,15,8,0),(8,0,15,7));
var fa:byte;
begin
if tl then fa:=2 else fa:=1;
setfillstyle(1,f[fa,1]);bar(x1,y1,x2,y2);
setcolor(f[fa,2]);line(x1-1,y1-1,x2,y1-1);line(x1-1,y1-1,x1-1,y2);
setcolor(f[fa,3]);line(x1-1,y2+1,x2+1,y2+1);line(x2+1,y2+1,x2+1,y1-1);
settextstyle(2,0,4);setcolor(f[fa,4]);settextjustify(centertext,centertext);
outtextxy((x1+x2)div 2,(y1+y2)div 2,s);settextjustify(lefttext,toptext);
end;

procedure tlacidko(x,y:word;tl:boolean;s:string);
begin
if tl then begin vstl(x,y,x+42,y+15,tl,s);delay(200);tl:=false;end;
vstl(x,y,x+42,y+15,tl,s);
end;
}
end.
