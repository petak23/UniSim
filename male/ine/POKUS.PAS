program navrh;
uses crt,dos,graph,menus,dswmouse,pomocny,deklar,sprites,smerniky;
var pocitadlo:longint;

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ--------- Z A C I A T O K   H L A V N E H O   P R O G R A M U ----------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

begin
igraph;imys;imenu('vybmen'); {Inicializacia grafiky, mysi a menu}
naz:='mala';cleardevice;setbkcolor(0);
logo(0,449);
setfillstyle(0,0);bar(0,129,639,401);setfillstyle(0,0);
setcolor(5);line(0,129,630,129);line(0,401,630,401);
setfillstyle(1,8);bar(250,0,630,100);setcolor(5);rectangle(250,0,630,100);
line(440,0,440,100);
tlacidko(588,458,false,'Koniec');
settextjustify(centertext,toptext);
setcolor(6);
outtextxy(getmaxx div 2,240,'Inicializujem subory. Prosim cakajte.');
setcolor(14);
outtextxy(getmaxx div 2,150,'Simulator elektronickeho stavadla. Subor: '+naz);
settextjustify(lefttext,toptext);
volba:=false;
mousezap;
po:=0;
with told do begin gettime(h,m,s,d);d:=d div 10;end;
pocitadlo:=0;
mys_stl:=0;
tlac:=0;


repeat         {Zac.  hlavnej slucky}
 if tlacitka(dvoj)=1 then mys_stl:=1
 else mys_stl:=0;
 tlac:=0;

 repeat         {Zasc. ciklu pre mys a cas}
  getmousepos(mx,my);
  tlac:=0;
  if mys_stl=1 then
   if tlacitka(dvoj)=0 then mys_stl:=0;
  case mys_stl of
   0:begin tlac:=tlacitka(dvoj);
      if tlac>0 then mys_stl:=1;end;
   1:tlac:=0;
  end;
  case tlacitka(dvoj) of
   0:begin setfillstyle(0,0);bar(320,470,330,479);end;
   1:begin setfillstyle(1,2);bar(320,470,330,479);end;
   2:begin setfillstyle(1,12);bar(320,470,330,479);end;
  end;
  case mys_stl of
   0:begin setfillstyle(0,0);bar(320,470,330,479);end;
   1:begin setfillstyle(1,3);bar(340,470,350,479);end;
   2:begin setfillstyle(1,12);bar(320,470,330,479);end;
  end;
 until (tlac=1) or (tlac=2);  {Koniec ciklu pri stlac. tlac. mysi}

 mousevyp;
 if tlac=1 then
  case my of
   130..400:begin
    kx:=cis((mx div 10)+1,(my div 10)+1);
    {delay(100);}
    setfillstyle(0,0);
    bar(220,270,320,285);
    setcolor(15);outtextxy(220,270,'x='+sti(kx,2,0)+' y='+sti(ky,2,0));
    vmenum(mx,my,4,5,1,v1);nulmenu(mx,my,4,5,1);
    with charusk do begin
     ch[1]:='N';ch[2]:='E';xs:=kx;
    end;
    case v1 of
     4:begin
        charusk.sm:=1;
        prvky(charusk,0,2);
       end;
     5:begin
        charusk.sm:=2;
        prvky(charusk,0,12);
       end;
    end;
   end;
   458..478:if (mx>=588)and(mx<=640) then tlacidko(588,458,true,'Koniec');
  end;
 if tlac=2 then begin
  vmenum(mx,my,1,3,1,v1);nulmenu(mx,my,1,3,1);
  if (my>=130)and(my<=400) then begin
   kx:=cis((mx div 10)+1,(my div 10)+1);
   tlac:=1;{delay(200);}
  end;
 end;
 mousezap;
until (mx>=588)and(mx<=640)and(my>=458)and(my<=480)and(tlac=1);



mousevyp;
closegraph;
writeln(' ');
writeln('    ษอออออออออออออออออออออออออออออหออออออออหออออออออป');
writeln('    บ (c) Ing. Peter Vojtech 2002 บ UnIsiM บ (R) Vฆ บ');
writeln('    ศอออออออออออออออออออออออออออออสออออออออสออออออออผ');
reset(usek);
close(usek);reset(cesta);close(cesta);reset(vlc);
close(vlc);reset(svlak);close(svlak);close(pomoc);
delay(2000);
end.