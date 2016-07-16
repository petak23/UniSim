unit menus1;
interface
Const odstup:byte=6;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ D E K L A R A C I E ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

procedure imys;                     {Inicializacia mysi}
procedure igraph;                   {Inicializacia grafiky}
procedure imenu(menu:string);       {Priradenie suboru menu}
procedure ihelp(menu:string);       {Priradenie suboru helpu}
procedure oldnastavsave;            {Zapametanie povodnych nast. grafiky}
procedure oldnastavload;            {Nacitanie povodnych nast. grafiky}
function hladaj(ms:string):boolean;
procedure kbd(var a:integer);
procedure vmenum(x,y:word;k1,k2,po:byte;var vyb:byte);
procedure vmenu(k1,k2,x,y,cp,co,cpp:integer;var vbr:byte);
procedure nulmenu(x,y:word;k1,k2,po:byte);
procedure nullmenu(k1,k2,x,y:integer);
function vybe(i:integer):string;
function help(i:integer):string;
procedure dnustr(x,y,cp,co,dlzka:word;nastav:string;riad:word;var vystup:string);
procedure von(x,y,co,c,d:integer;cis:real);
procedure vonz(x,y,cp,cm,c,d:integer;cis:real);
procedure dnu(x,y,cp,co,dlzka:integer;s:string;var dnu:real);
procedure vondnu(x,y,cp,co,cv,dlzka:word;vypis,nastav:string;var vondnu:real);
procedure vondnus(x,y,cp,co,cv,dlzka:word;vypis,nastav:string;var vondnu:string);
function red(s:string):string;
function sti(r:real;c,d:byte):string;
procedure chybhl(index:byte);
procedure zadokno(x,y,dx,dy:integer;typ:boolean);
procedure tab(x1,y1,x2,y2,c1,c2:word);
procedure vstl(x,y,dx,dy:integer;tl:boolean;s:string);
procedure zaskrt_tl(x,y,dx,dy:word;tl:boolean;s:string);
procedure tlacidko(x,y,dx,dy:word;tl:boolean;s:string);
procedure tlacsip(x,y:word;tl:boolean;ch:char);
function popen(dir,konc:string;var novy:boolean):string;
          {Nahrava data zo suboru s menom v premennej menosub+'.dat'}
function tret(x:real):real;
function cakaj(var key:integer):byte;
function ano_nie(s:string):boolean;
implementation

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ Procedury a funkcie ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

uses crt,graph,dos,dswmouse,tlacidka;
type sst=^string;
     ii=^integer;
var directory:string;
    vyb,tlac:byte;
    vel:array[1..5] of word;
    miesto:array[1..5]of pointer;
    q:sst;
    x,y,z:integer;
    dvoj:boolean;
    vybmen,shelp:file of string;
    oldsc:byte;
    oldts:TextSettingsType;
    oldFill: FillSettingsType;
    regs:registers;

procedure imys;
begin
mouseinst;
if instalm then begin
 mousezap;setmousepos(getmaxx div 2,getmaxy div 2);setx(0,getmaxx);
 sety(0,getmaxy);mousecitl(8,8);mousevyp;end
else begin
 writeln('Nie je v pamti zaveden์ driver my็i !!!');halt(1);end;
end;

procedure igraph;
var gd,cy:integer;
    hla,ptd:sst;
begin
new(hla);new(ptd);
hla^:='';ptd^:='egavga';
gd:=InstallUserDriver(ptd^,nil);
 {ptd = vesa256,bgi256,uni256      egavga
  cy  = 0   319*199                0  639*199
        1   639*399                1  639*349
        2   639*479                2  639*479
        3   799*599
        4  1023*767}
cy:=2;
initGraph(gd,cy,ptd^);dispose(ptd);
if graphresult <> grOK then begin
 writeln('Program konก chybou: ',graphresult,'. Moงn  prกina :',hla^);readln;
 HALT(1);end;
cleardevice;
dispose(hla);
end;

procedure imenu(menu:string); {Priradenie suboru menu}
var dir:sst;
begin
 new(dir);
 getdir(0,dir^);
 assign(vybmen,dir^+'\fonty\'+menu+'.mnu');
 dispose(dir);
end;

procedure ihelp(menu:string); {Priradenie suboru helpu}
var dir:sst;
begin
 new(dir);
 getdir(0,dir^);
 assign(shelp,dir^+'\fonty\'+menu+'.hlp');
 dispose(dir);
end;

procedure oldnastavsave;            {Zapametanie povodnych nast. grafiky}
begin
gettextsettings(oldts);
oldsc:=getcolor;
getfillsettings(oldfill);
end;

procedure oldnastavload;            {Nacitanie povodnych nast. grafiky}
begin
 with oldts do begin
  settextjustify(horiz,vert);settextstyle(font,direction,charsize);end;
 setcolor(oldsc);
 with oldfill do setfillstyle(Pattern, Color);

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

function vybe(i:integer):string;
var qo:sst;
begin
new(qo);
reset(vybmen);
seek(vybmen,i-1);
read(vybmen,qo^);
close(vybmen);
vybe:=qo^;dispose(qo);
end;

function help(i:integer):string;
var qo:sst;
begin
new(qo);
reset(shelp);
seek(shelp,i-1);
read(shelp,qo^);
close(shelp);
help:=qo^;dispose(qo);
end;

procedure vmenum(x,y:word;k1,k2,po:byte;var vyb:byte);
var xmx,ymx,mx,my,i,b:word;     {menu s mysou}
    aa:integer;

 procedure nulit;
 var i:byte;
 begin
  setfillstyle(1,7);bar(x+1,y+1,xmx-1,ymx-1);
  setcolor(2);line(x,ymx,x,y);line(x,y,xmx-1,y);
  setcolor(3);line(xmx,y,xmx,ymx);line(xmx,ymx,x+1,ymx);
  setcolor(4);
  for i:=k1 to k2 do outtextxy(x+10,y+(i-k1)*12+5,vybe(i));
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
getimage(x,y,xmx,ymx,miesto[po]^);nulit;setx(x+1,xmx-1);sety(y+1,ymx-1);
b:=0;setfillstyle(1,4);bar(x+1,y+3,xmx-1,y+15);
setcolor(11);outtextxy(x+10,y+5,vybe(k1));
mousezap;
repeat
 getmousepos(mx,my);
 tlac:=tlacitka(dvoj);
 if (mx>x)and(mx<xmx)and(my>y)and(my<ymx) then begin
  aa:=my-y-5;if aa<0 then aa:=0;
  aa:=aa div 12;
  if aa>(k2-k1) then aa:=k2-k1;
  if aa<>b then begin
   mousevyp;nulit;setfillstyle(1,4);bar(x+1,y+3+aa*12,xmx-1,y+15+aa*12);
   setcolor(11);outtextxy(x+10,y+5+aa*12,vybe(aa+k1));b:=aa;mousezap;end;
 end;
until tlac=1;
mousevyp;
tlac:=0;
vyb:=aa+k1;
end;

procedure pohy(i,j,k1,m,y,cpp,co,koe:integer);
var b,a,c,d:integer;
begin
a:=y+(i-k1+1)*13;b:=y+(j-k1+1)*13;
new(q);
for c:=0 to koe-1 do begin
setcolor(co);d:=j+c;q^:=vybe(d);
if q^[length(q^)]='' then delete(q^,length(q^),1);
outtextxy(m,b+13*c,q^);setcolor(cpp);d:=i+c;q^:=vybe(d);
if q^[length(q^)]='' then delete(q^,length(q^),1);
outtextxy(m,a+13*c,q^);
                      end;
dispose(q);
end;


procedure vmenu(k1,k2,x,y,cp,co,cpp:integer;var vbr:byte);
var m,max,key,j,i:integer;      {menu bez mysi}
    a:ii;

begin
oldnastavsave;
settextstyle(0,0,1);
setcolor(co);setlinestyle(0,0,1);
 setfillstyle(1,cp);max:=0;new(q);
 for i:=k1 to k2 do begin
  j:=length(vybe(i));if j>max then max:=j;
                    end;
 bar(x,y,x+max*8+20,y+13*(k2-k1+2)+3);
 rectangle(x+5,y+5,x+max*8+15,y+13*(k2-k1+2)-2);
 if (co-8)<0 then setcolor(co) else setcolor(co-8);
 rectangle(x,y,x+max*8+20,y+13*(k2-k1+2)+3);
 setcolor(cpp);new(a);
 for i:=k1 to k2 do begin
  q^:=vybe(i);
  if i=k1 then a^:=13 else a^:=a^+13;
  outtextxy(x+9,y+a^,q^);
                   end;
 setcolor(co);dispose(a);
 outtextxy(x+9,y+13,vybe(k1));dispose(q);
 i:=k1;m:=x+9;j:=1;
 repeat;kbd(key);
 if key=336 then begin j:=i;i:=i+1;if i=(k2+1) then i:=k1;pohy(i,j,k1,m,y,co,cpp,1);end;
 if key=328 then begin j:=i;i:=i-1;if i=(k1-1) then i:=k2;pohy(i,j,k1,m,y,co,cpp,1);end;
 until (key=13) or (key=27);vbr:=i;
 if key=27 then vbr:=255;
oldnastavload;
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

procedure nullmenu(k1,k2,x,y:integer);
var max,j,i:integer;    {Pre Menu bez mysi}
begin
max:=getbkcolor;
setfillstyle(0,max);max:=0;new(q);
 for i:=k1 to k2 do begin
  j:=length(vybe(i));if j>max then max:=j;
                    end;
 bar(x,y,x+max*8+40,y+13*(k2-k1+2)+3);
end;



procedure dnustr(x,y,cp,co,dlzka:word;nastav:string;riad:word;var vystup:string);
var ch:char;
    key,i,dly:integer;
    na:string;
    svit,c:boolean;
    
begin
oldnastavsave;
if dlzka>255 then dlzka:=255;
na:=nastav;c:=true;settextstyle(2,0,4);
setfillstyle(1,co);bar(x-1,y+2,x+length(na)*odstup,y+12);
setcolor(cp);svit:=true;
for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
x:=x+odstup*length(na);setfillstyle(1,cp);setcolor(co);
dly:=length(na);
repeat;
 if dly<dlzka then rectangle(x+2,y+3,x+6,y+11);
 if (c=true) and (riad>0) then begin key:=riad;c:=false;end else kbd(key);
case key of
 32..126,130,147,149,150,155,156,159..161,163,166,167,172,210,212,213,229..231,236:begin
      if dly+1<=dlzka then begin
       setcolor(cp);rectangle(x+2,y+3,x+6,y+11);x:=x-odstup*length(na);
       bar(x-1,y+2,x+length(na)*odstup,y+12);
       if svit then begin na:=chr(key);svit:=false;end else na:=na+chr(key);
       setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
       x:=x+odstup*length(na);dly:=length(na);
      end;
     end;
 8:begin setcolor(cp);rectangle(x+2,y+3,x+6,y+11);x:=x-odstup*length(na);
      bar(x-1,y+2,x+length(na)*odstup,y+12);dly:=dly-1;
      setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
      x:=x+odstup*length(na);i:=length(na);ch:=na[i];setcolor(cp);
      rectangle(x+2,y+3,x+6,y+11);
      if length(na)>0 then x:=x-odstup;
      outtextxy(x,y,ch);
      setcolor(co);delete(na,i,1);
      end;
 339:begin setcolor(cp);rectangle(x+2,y+3,x+6,y+11);x:=x-odstup*length(na);
           bar(x-1,y+2,x+length(na)*odstup,y+12);setcolor(co);na:='';dly:=0;
     end;
 333:{>}begin
      if dly+1<=dlzka then begin
       setcolor(cp);rectangle(x+2,y+3,x+6,y+11);x:=x-odstup*length(na);
       bar(x-1,y+2,x+length(na)*odstup,y+12);
       if svit then svit:=false;
       setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
       x:=x+odstup*length(na);dly:=length(na);
      end;
     end;
 end;
 until key=13;
 setcolor(cp);rectangle(x+2,y+3,x+6,y+11);
 if svit then begin
  x:=x-odstup*length(na);
  setfillstyle(1,cp);bar(x-1,y+2,x+length(na)*odstup,y+12);
  setcolor(co);for i:=1 to length(na) do outtextxy(x+odstup*(i-1),y,na[i]);
 end;
 vystup:=na;
 oldnastavload;
end;

procedure von(x,y,co,c,d:integer;cis:real);
begin
 setcolor(co);outtextxy(x,y,sti(cis,c,d));
end;

procedure vonz(x,y,cp,cm,c,d:integer;cis:real);
begin
if cis>=0 then von(x,y,cp,c,d,cis) else von(x,y,cm,c,d,cis);
end;


procedure dnu(x,y,cp,co,dlzka:integer;s:string;var dnu:real);
begin
 new(q);
 dnustr(x,y,cp,co,dlzka,s,0,q^);
 val(q^,dnu,z);dispose(q);
end;

procedure vondnu(x,y,cp,co,cv,dlzka:word;vypis,nastav:string;var vondnu:real);
begin
 setcolor(cv);outtextxy(x,y,vypis);
 if (length(vypis)*odstup)>620 then begin y:=y+13;end
  else if vypis<>'' then x:=(length(vypis)*odstup)+5+x;
 dnu(x,y,cp,co,dlzka,nastav,vondnu);
end;

procedure vondnus(x,y,cp,co,cv,dlzka:word;vypis,nastav:string;var vondnu:string);
begin
 setcolor(cv);outtextxy(x,y,vypis);
 if (length(vypis)*odstup)>620 then begin y:=y+15;x:=200;end
  else if vypis<>'' then x:=(length(vypis)*odstup)+5+x;
 dnustr(x,y,cp,co,dlzka,nastav,0,vondnu);
end;

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

procedure chybhl(index:byte);
var miesto:pointer;
    velkost:word;
begin
 if index>0 then begin
 oldnastavsave;
 settextjustify(centertext,toptext);
 settextstyle(2,0,4);
 velkost:=imagesize(5,225,getmaxx-4,255);
 getmem(miesto,velkost);getimage(5,225,getmaxx-4,255,miesto^);
 setfillstyle(1,4);bar(5,225,getmaxx-4,255);setlinestyle(0,0,1);setcolor(14);
 rectangle(10,230,getmaxx-9,250);setcolor(10);
 outtextxy(getmaxx div 2,233,help(index));readln;
 putimage(5,225,miesto^,normalput);
 freemem(miesto,velkost);
 oldnastavload;
                 end;
end;

procedure zadokno(x,y,dx,dy:integer;typ:boolean);
var f:byte;
begin
if typ=true then f:=15 else f:=8;
 setfillstyle(1,f);bar(x,y,x+dx+1,y+dy);
 setcolor(0);line(x-1,y,x-1,y+dy);
 setcolor(8);line(x-1,y-1,x+dx+1,y-1);line(x+dx+1,y-1,x+dx+1,y+dy);
 setcolor(7);line(x,y+dy,x+dx,y+dy);
end;

procedure tab(x1,y1,x2,y2,c1,c2:word);
begin
setfillstyle(1,c1);bar(x1,y1,x2,y2);
setcolor(c2);rectangle(x1+2,y1+2,x2-2,y2-2);
if (c2-8)<0 then setcolor(c2) else setcolor(c2-8);
rectangle(x1,y1,x2,y2);
end;

procedure vstl(x,y,dx,dy:integer;tl:boolean;s:string);
type farb=array[1..2,1..4]of byte;
const f:farb=((7,15,8,1),(8,1,15,7));
var fa:byte;
begin
oldnastavsave;
case tl of
 false:fa:=1;
 true:fa:=2;
end;
 if dx=0 then dx:=(length(s)+1)*odstup;
 if x+dx>getmaxx then x:=getmaxx-dx;if y+dy>getmaxy then y:=getmaxy-dy;
 setfillstyle(1,f[fa,1]);bar(x,y,x+dx,y+dy);
 setcolor(f[fa,2]);line(x,y,x+dx,y);line(x,y,x,y+dy);
 setcolor(f[fa,3]);line(x,y+dy,x+dx,y+dy);line(x+dx,y+dy,x+dx,y);
 settextstyle(2,0,4);setcolor(f[fa,4]);
 settextjustify(centertext,centertext);
 outtextxy(x+(dx div 2),y+(dy div 2),s);
oldnastavload;
end;

procedure zaskrt_tl(x,y,dx,dy:word;tl:boolean;s:string);
begin
{setcolor(7);rectangle(x,y,x+dx,y+dy);}
setcolor(15);settextstyle(2,0,4);
if not(tl) then outtextxy(x+15,y-3,s);
setfillstyle(1,15);setcolor(7);
bar(x,y,x+8,y+8);rectangle(x,y,x+8,y+8);
if tl then begin
 setfillstyle(1,1);setcolor(9);
 bar(x+2,y+2,x+6,y+6);rectangle(x+2,y+2,x+6,y+6);
end;
end;


procedure tlacidko(x,y,dx,dy:word;tl:boolean;s:string);
begin
if tl=true then begin
 vstl(x,y,dx,dy,tl,s);delay(200);tl:=false;end;
vstl(x,y,dx,dy,tl,s);
end;

procedure tlacsip(x,y:word;tl:boolean;ch:char);
 procedure sipka;
 var f:byte;
  begin
   if tl=false then f:=0 else f:=15;
   setcolor(f);
   case ch of
    '':begin moveto(x+5,y+3);linerel(-3,4);linerel(6,0);linerel(-3,-4);end;
    '':begin moveto(x+5,y+7);linerel(-3,-4);linerel(6,0);linerel(-3,4);end;
    '<':begin moveto(x+2,y+4);linerel(6,-2);linerel(0,4);linerel(-6,-2);end;
    '>':begin moveto(x+8,y+4);linerel(-6,-2);linerel(0,4);linerel(6,-2);end;
   end;
   setfillstyle(1,f);floodfill(x+5,y+4,f);
  end;
begin
if tl=true then begin
 vstl(x,y,10,10,tl,'');sipka;delay(200);tl:=false;end;
vstl(x,y,10,10,tl,'');sipka;
end;


function popen(dir,konc:string;var novy:boolean):string;  {Nahrava data zo suboru s menom v premennej menosub+'.dat'}
type subo=string[12];
var su:subo;
    menosub:string;
    key:integer;
    subor:file of subo;
    i,j,bb,aa,vel,vel1,mx,my,cistl:word;
    miesto,miesto1:pointer;
    ok:byte;
    f:file;

function zoznam:word;
var dirinfo:searchrec;
    j:word;
begin
 assign(subor,dir+'zoznam.sub');rewrite(subor);
 findfirst(dir+'*.'+konc,archive,dirinfo);j:=0;
 while doserror = 0 do begin
  su:=dirinfo.name;
  write(subor,su);j:=j+1;
  findnext(dirinfo);   end;
zoznam:=j;
close(subor);
end;


begin
oldnastavsave;                   {nacitanie nastavenia a nove nastavenie}
settextjustify(lefttext,toptext);
vel:=imagesize(200,100,480,426); {zapametanie pozadia}
getmem(miesto,vel);getimage(200,100,480,426,miesto^);
tab(200,100,480,426,1,14);       {vykreslenie okienka}
setcolor(15);setfillstyle(1,14);bar(206,106,474,120);
setcolor(12);rectangle(206,106,474,120);
settextstyle(2,0,4);
setcolor(0);outtextxy(211,106,'Otvorenie sฃboru');
settextjustify(centertext,toptext);setcolor(14);
outtextxy(340,123,'Aktu lny adres r: '+dir);
settextjustify(lefttext,toptext);outtextxy(208,137,'Meno sฃboru :');
setfillstyle(1,8);bar(208,150,474,164);bar(208,170,474,394);
setcolor(11);rectangle(208,150,474,164);rectangle(208,170,474,394);
line(297,170,297,394);line(386,170,386,394);
setcolor(14);line(203,397,477,397);
kreslitlf(1);kreslitlf(2);
j:=zoznam;
reset(subor);novy:=false;
for i:=1 to j do begin
 bb:=i div 21;aa:=i mod 21;if bb>0 then aa:=aa+1;
 if i<64 then begin
  read(subor,su);delete(su,length(su)-3,4);outtextxy(213+bb*89,159+aa*11,su);
 end;
end;
reset(subor);read(subor,su);close(subor);
delete(su,length(su)-3,4);menosub:=su;i:=1;
mousezap;
repeat
 setfillstyle(1,8);bar(209,151,473,163);
 setcolor(15);outtextxy(213,150,menosub);
 repeat
  key:=0;ok:=0;
  repeat
   if keypressed then kbd(key);
   if tlacitka(dvoj)=1 then ok:=1;
   if key>0 then ok:=2;
  until ok>0;
  mousevyp;
  case ok of
   1:begin
      getmousepos(mx,my);cistl:=hladaj_policko(mx,my,1,2);
      ok:=0;if cistl in [1..2] then kreslitl(cistl);
      case cistl of
       1:key:={F2}316;
       2:key:=13;
      end;
     end;
   2:case key of
      13:kreslitl(2);
      316:kreslitl(1);
     end;
  end;
  case key of
   32..126,130,147,149,150,155,156,159..161,163,166,167,172,210,212,213,229..231,236,
   339:begin
    dnustr(213,150,8,15,8,menosub,key,menosub);key:=13;novy:=false;end;
   336:{}begin i:=i+1;if i>j then i:=1;reset(subor);seek(subor,i-1);read(subor,su);
           close(subor);delete(su,length(su)-3,4);menosub:=su;
           setfillstyle(1,8);bar(209,151,473,163);setcolor(15);
           outtextxy(213,150,menosub);
       end;
   316:{F2}begin
        vel1:=imagesize(170,200,470,240); {zapametanie pozadia}
        getmem(miesto1,vel1);getimage(170,200,470,230,miesto1^);
        tab(170,200,470,230,12,4);       {vykreslenie okienka}
        vondnus(177,207,12,15,15,8,'Zadaj meno suboru: ','',menosub);
        putimage(170,200,miesto1^,normalput);
        freemem(miesto1,vel1);
        setfillstyle(1,8);bar(209,151,473,163);
        setcolor(15);outtextxy(213,150,menosub);
        assign(f,dir+menosub+'.'+konc);
        rewrite(f);close(f);novy:=true;
           end;
  end;
  mousezap;
 until key=13;
 if hladaj(dir+menosub+'.'+konc)=false then chybhl(1)
 else popen:=menosub;
 mousezap;
until hladaj(dir+menosub+'.'+konc)=true;
erase(subor);
mousevyp;
putimage(200,100,miesto^,normalput);
freemem(miesto,vel);
oldnastavload;
end;

function tret(x:real):real;
begin
tret:=x*x*x;
end;

function cakaj(var key:integer):byte;
var ok:byte;
begin
 ok:=0;key:=0;
 mousezap;
 repeat
  if keypressed then begin kbd(key);ok:=3;end;
  if tlacitka(dvoj)=1 then if dvoj then ok:=2 else ok:=1;
 until ok>0;
 mousevyp;
cakaj:=ok;
end;

function ano_nie(s:string):boolean;
var miesto:pointer;
    mx,my,velkost:word;
    ok:byte;
    key:integer;

begin
if s<>'' then begin
 oldnastavsave;settextjustify(centertext,toptext);settextstyle(2,0,4);
 velkost:=imagesize(5,225,635,275);
 getmem(miesto,velkost);getimage(5,225,635,275,miesto^);
 setfillstyle(1,4);bar(5,225,635,275);setlinestyle(0,0,1);setcolor(14);
 rectangle(7,227,633,273);setcolor(10);
 outtextxy(320,230,s);
 tlacidko(290,250,24,20,false,'Nie');
 tlacidko(326,250,24,20,false,'ตno');
 repeat
  ok:=cakaj(key);
  getmousepos(mx,my);
  case ok of
   1:if (my>250)and(my<270)then
      case mx of
       290..314:begin tlacidko(290,250,24,20,true,'Nie');ano_nie:=false;ok:=4;end;
       326..350:begin tlacidko(326,250,24,20,true,'ตno');ano_nie:=true;ok:=4;end;
      end;
   3:case key of
      78,110:begin tlacidko(290,250,24,20,true,'Nie');ano_nie:=false;ok:=4;end;
      65,97:begin tlacidko(326,250,24,20,true,'ตno');ano_nie:=true;ok:=4;end;
     end;
  end;
 until ok=4;
 putimage(5,225,miesto^,normalput);
 freemem(miesto,velkost);
 oldnastavload;
end;
end;

end.
