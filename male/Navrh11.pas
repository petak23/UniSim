program navrh;
uses crt,graph,menus1,deklar,sprites,pomocny,tlacidka;
type pp_p=record
      x,y,c:integer;
     end;
label skok,zaciatok;
var key,ok:integer;
    s1,s:string;
    pam:array[1..3]of pp_p;
    cistl:word;

procedure vypis(x:word);
begin
tab(0,73,119,93,1,14);setcolor(11);settextjustify(lefttext,toptext);
outtextxy(10,76,'x='+sti(sux(x),2,0)+' y='+sti(suy(x),2,0)+' XS='+sti(x,4,0));
end;

procedure infou(idx:word);
begin
setfillstyle(1,9);bar(454,4,635,66);setcolor(14);
if idx=0 then exit;
if pozicia[idx]=NIL then exit;
with pozicia[idx]^ do begin
 case ch[1] of
  'U':case ch[2] of
       'B':begin
            s:='Cesta '+sti((c[1] shr 8)and 15,1,0)+sti((c[1] shr 4)and 15,1,0)+sti(c[1] and 15,1,0);
            outtextxy(456,4,s);
           end;
      end;

 end;
end;
end;

procedure vymaz;
var i:word;
begin
for i:=1 to 3 do
 with pam[i] do begin
  setcolor(c mod 16);
  rectangle(x*10-10,y*10-10,x*10,y*10);
  x:=0;y:=0;c:=0;
 end;
end;

procedure pole(x,c:word);
begin
setcolor(c mod 16);
if c=0 then begin
 setfillstyle(0,0);
 bar((sux(x)-1)*krokx,(suy(x)-1)*kroky,sux(x)*krokx,suy(x)*kroky);
 setcolor(8);
end;
rectangle((sux(x)-1)*krokx,(suy(x)-1)*kroky,sux(x)*krokx,suy(x)*kroky);
if c<16 then begin vypis(x);vymaz;end;
end;

{---------------------- Zaciatok Programu -----------------------------}

begin
new(ss);
ss^:='S';
igraph;imys;{imenu('menu');}itlob('tlacobj');
getdir(0,s);
zaciatok:
setbkcolor(0);
settextstyle(2,0,3);
setcolor(5);
line((xmin-1)*krokx,(ymin-1)*kroky-1,xmax*krokx,(ymin-1)*kroky-1);
line((xmin-1)*krokx,ymax*kroky+1,xmax*krokx,ymax*kroky+1);
setcolor(8);
for i:=xmin-1 to xmax do begin
 setcolor(8);line(i*krokx,(ymin-1)*kroky,i*krokx,ymax*kroky);setcolor(7);
 if i=1 then outtextxy(5,(ymin-1)*kroky,'1');
 if (i+1) mod 5=0 then outtextxy(i*10+3,(ymin-1)*kroky,sti(i+1,2,0));
end;
for i:=ymin to ymax do begin
 setcolor(8);line((xmin-1)*krokx,i*kroky,xmax*krokx,i*kroky);setcolor(7);
 if (i+1) mod 5=0 then begin
  outtextxy(1,i*10+2,sti(i+1,2,0));
  outtextxy(621,i*10+2,sti(i+1,2,0));
 end;
end;
settextstyle(2,0,4);
s:='';
if (ss^='N') or (ss^='n') then rewrite(usek) else begin
 reset(usek);
 if filesize(usek)>0 then begin
  for i:=0 to filesize(usek)-1 do begin
   seek(usek,i);read(usek,charusk);
   if charusk.ch[1]<>'X' then begin
    new(pozicia[charusk.xs]);
    with pozicia[charusk.xs]^ do begin  {vyplnenie prvku pozicie}
     if charusk.ch[1]='T' then stav:=charusk.sm else stav:=0;
     pvlak:=0;rych:=255;
     ch[1]:=charusk.ch[1];ch[2]:=charusk.ch[2];y:=charusk.y;
     dl:=charusk.dl;nx0:=charusk.nx0;ty0:=charusk.ty0;sm:=charusk.sm;
     odk:=charusk.odk;
     for j:=1 to 4 do c[j]:=charusk.c[j];
    end;
    krstav(charusk.xs);
    if charusk.ch[2]='T'then prvky(charusk.xs,0,pozicia[charusk.xs]^.stav);
   end;
  end;
 end;
end;
kx:=xmin;ky:=ymin;
tab(0,0,639,70,1,14);line(450,3,450,67);setcolor(14);line(453,3,453,67);
setcolor(15);settextstyle(2,0,4);settextjustify(righttext,toptext);
outtextxy(40,10,'Ch[1]:');outtextxy(110,10,'Ch[2]:');outtextxy(180,10,'xs:');outtextxy(250,10,'y:');
outtextxy(40,30,'c[1]:');outtextxy(150,30,'c[2]:');outtextxy(260,30,'c[3]:');outtextxy(370,30,'c[4]:');
outtextxy(40,50,'dl:');outtextxy(110,50,'nx0:');outtextxy(180,50,'ty0:');outtextxy(250,50,'sm:');
for i:=3 to 14 do kreslitl(i);
for i:=15 to 19 do kreslitlf(i);
for i:=1 to 3 do with pam[i] do begin x:=0;y:=0;c:=0;end;
pole(kx,14);infou(0);
repeat
 cistl:=0;ok:=cakaj(key);getmousepos(mx,my);
 case ok of
  1:begin
     cistl:=hladaj_policko(mx,my,3,19);
     case my of
       100..430:begin
                 pole(kx,8);
                 for i:=3 to 14 do kreslitl(i);kreslitlf(15);
                 krstav(kx);
                 kx:=cis((mx div krokx)+1,(my div kroky)+1);
                 pole(kx,14);infou(kx);
                 if pozicia[kx]<>NIL then
                  with pozicia[kx]^ do begin
                   setcolor(0);
                   outtextxy(45,10,ch[1]);outtextxy(115,10,ch[2]);
                   von(185,10,0,4,0,kx);von(255,10,0,3,0,y);
                   von(45,30,0,4,0,c[1]);von(155,30,0,4,0,c[2]);
                   von(265,30,0,4,0,c[3]);von(375,30,0,4,0,c[4]);
                   von(45,50,0,4,0,dl);von(115,50,0,4,0,nx0);
                   von(185,50,0,4,0,ty0);von(255,50,0,3,0,sm);
                   if odk=1 then kreslitl(15) else kreslitlf(15);
                  end
                 else begin
                  new(pozicia[kx]);
                  with pozicia[kx]^ do begin
                   vondnus(45,10,15,0,0,2,'','',s1);ch[1]:=s1[1];
                   vondnus(115,10,15,0,0,2,'','',s1);ch[2]:=s1[1];
                   vondnu(255,10,15,0,0,3,'','',r);y:=trunc(r);
                   vondnu(045,30,15,0,0,9,'','',r);c[1]:=trunc(r);
                   vondnu(155,30,15,0,0,9,'','',r);c[2]:=trunc(r);
                   vondnu(265,30,15,0,0,9,'','',r);c[3]:=trunc(r);
                   vondnu(375,30,15,0,0,9,'','',r);c[4]:=trunc(r);
                   vondnu(045,50,15,0,0,5,'','',r);dl:=trunc(r);
                   vondnu(115,50,15,0,0,5,'','',r);nx0:=trunc(r);
                   vondnu(185,50,15,0,0,5,'','',r);ty0:=trunc(r);
                   vondnu(255,50,15,0,0,3,'','',r);sm:=trunc(r);
                  end;
                  krstav(kx);
                  pole(kx,14);infou(kx);
                 end;
                 delay(200);
                end;
       0..100:case cistl of
               16:begin
                   kreslitl(16);
                   setcolor(10);outtextxy(470,73,'Ukladam');rewrite(usek);
                   for i:=xmin to ((ymax-ymin)*xmax) do begin
                    if pozicia[i]<>nil then begin
                     with pozicia[i]^ do begin
                      charusk.xs:=i;charusk.ch[1]:=ch[1];charusk.ch[2]:=ch[2];
                      charusk.y:=y;for j:=1 to 4 do charusk.c[j]:=c[j];
                      charusk.dl:=dl;charusk.nx0:=nx0;charusk.ty0:=ty0;charusk.sm:=sm;
                      charusk.sl:=0;charusk.odk:=odk;
                     end;
                     write(usek,charusk);
                    end;
                   end;
                   delay(1000);setcolor(0);outtextxy(470,73,'Ukladam');
                  end;
               17:begin
                   kreslitl(17);
                   if (ano_nie('Zmazat prvok '+sti(kx,4,0)+'?'))and(pozicia[kx]<>NIL) then begin
                    with pozicia[kx]^ do begin
                     ch[1]:=' ';ch[2]:=' ';y:=0;for i:=1 to 4 do c[i]:=0;
                     dl:=0;nx0:=0;ty0:=0;sm:=0;odk:=0;
                    end;
                    dispose(pozicia[kx]);
                    pozicia[kx]:=NIL;
                    pole(kx,0);
                   end;
                  end;
               18:begin
                   kreslitl(18);
                   rewrite(usek);
                    for i:=xmin to ((ymax-ymin)*xmax) do begin
                     if pozicia[i]<>nil then begin
                      with pozicia[i]^ do begin
                       charusk.xs:=i;charusk.ch[1]:=ch[1];charusk.ch[2]:=ch[2];
                       charusk.y:=y;for j:=1 to 4 do charusk.c[j]:=c[j];
                       charusk.dl:=dl;charusk.nx0:=nx0;charusk.ty0:=ty0;charusk.sm:=sm;
                       charusk.sl:=0;charusk.odk:=odk;
                      end;
                      write(usek,charusk);
                      dispose(pozicia[i]);
                     end;
                    end;
                   close(usek);
                   cleardevice;
                   goto zaciatok;
                  end;
               19:begin kreslitl(19);key:=27;end;
        3,4,6..15:if pozicia[kx]<>NIL then begin
                   settextjustify(lefttext,toptext);
                   with pozicia[kx]^ do
                    case cistl of
                     3:begin vondnus(45,10,15,0,0,2,'',ch[1],s1);ch[1]:=s1[1];end;
                     4:begin vondnus(115,10,15,0,0,2,'',ch[2],s1);ch[2]:=s1[1];end;
                     6:begin vondnu(255,10,15,0,0,3,'',sti(y,3,0),r);y:=trunc(r);end;
                     7:begin vondnu(45,30,15,0,0,9,'',sti(c[1],4,0),r);c[1]:=trunc(r);end;
                     8:begin vondnu(155,30,15,0,0,9,'',sti(c[2],4,0),r);c[2]:=trunc(r);end;
                     9:begin vondnu(265,30,15,0,0,9,'',sti(c[3],4,0),r);c[3]:=trunc(r);end;
                    10:begin vondnu(375,30,15,0,0,9,'',sti(c[4],4,0),r);c[4]:=trunc(r);end;
                    11:begin vondnu(45,50,15,0,0,5,'',sti(dl,4,0),r);dl:=trunc(r);end;
                    12:begin vondnu(115,50,15,0,0,5,'',sti(nx0,4,0),r);nx0:=trunc(r);end;
                    13:begin vondnu(185,50,15,0,0,5,'',sti(ty0,4,0),r);ty0:=trunc(r);end;
                    14:begin vondnu(255,50,15,0,0,3,'',sti(sm,3,0),r);sm:=trunc(r);end;
                    15:if odk=0 then begin odk:=1;kreslitl(15);end else begin odk:=0;kreslitlf(15);end;
                    end;
                   delay(200);
                   krstav(kx);
                   pole(kx,14);infou(kx);
                  end;
              end;
    end;
 end;
 end;
 ok:=0;
until key=27;
closegraph;
rewrite(usek);
for i:=xmin to ((ymax-ymin)*xmax) do begin
 if pozicia[i]<>nil then begin
  with pozicia[i]^ do begin
   charusk.xs:=i;charusk.ch[1]:=ch[1];charusk.ch[2]:=ch[2];
   charusk.y:=y;for j:=1 to 4 do charusk.c[j]:=c[j];
   charusk.dl:=dl;charusk.nx0:=nx0;charusk.ty0:=ty0;charusk.sm:=sm;
   charusk.sl:=0;charusk.odk:=odk;
  end;
  write(usek,charusk);
  dispose(pozicia[i]);
 end;
end;
close(usek);
end.
