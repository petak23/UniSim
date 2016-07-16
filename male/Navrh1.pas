program navrh;
uses crt,graph,menus1,deklar,sprites,pomocny,tlacidka;
type pp_p=record
      x,y,c:integer;
     end;
label skok,zaciatok;
var key,ok,ky:integer;
    s1,s:string;
    r:real;
    pam:array[1..10]of pp_p;
    cistl:word;
    spoc:array[1..4] of string[4];
    sces:array[1..4] of string[3];

procedure vypis(x:word);
begin
tab(0,73,119,93,1,14);setcolor(11);settextjustify(lefttext,toptext);
outtextxy(10,76,'x='+sti(sux(x),2,0)+' y='+sti(suy(x),2,0)+' XS='+sti(x,4,0));
end;

procedure vymaz;
var i:word;
begin
for i:=1 to 10 do
 with pam[i] do begin
  setcolor(c mod 16);
  rectangle((x-1)*krokx,(y-1)*kroky,x*krokx,y*kroky);
  x:=0;y:=0;c:=0;
 end;
end;

procedure infou(idx:word);
var ir:byte;{index riadku}
begin
setfillstyle(1,9);bar(454,4,635,66);setcolor(14);
if idx=0 then exit;
if pozicia[idx]=NIL then exit;
with pozicia[idx]^ do begin
 case ch[1] of
  'U':case ch[2] of
       'B':begin
            s:='Cesta '+sti((c[1] shr 8)and 15,1,0)+sti((c[1] shr 4)and 15,1,0)+sti(c[1] and 15,1,0);
            s:=s+', Dlzka '+sti(dl,4,0)+'m';
            outtextxy(456,4,s);
            outtextxy(456,16,'Vmax '+sti(n[2],3,0)+'km/h');ir:=2;
            if n[1]>0 then begin
             outtextxy(456,28,'Pribl. usek PZZ '+sti(n[1],4,0));inc(ir);
            end;
            if odk>0 then outtextxy(456,12*ir+4,'Je odkazovany');
           end;
       'O':begin
            s:='Cesta '+sti((c[1] shr 8)and 15,1,0)+sti((c[1] shr 4)and 15,1,0)+sti(c[1] and 15,1,0);
            outtextxy(456,4,s);
           end;
       'P':begin
            s:='Dlzka '+sti(dl,3,0)+'m, Vmax '+sti(n[2],3,0)+'km/h';
            outtextxy(456,4,s);ir:=1;
            if c[4]>0 then begin
             outtextxy(456,16,'Predzv. cas '+sti(c[4],3,0)+'s');inc(ir);
            end;
            s:='Sused ';
            if sm and $FE=1 then s:=s+'€';
            if sm and $FD=2 then s:=s+'‹';
            if sm and $FC=0 then s:=s+'nie je';
            outtextxy(456,12*ir+4,s);inc(ir);
            if odk>0 then outtextxy(456,12*ir+4,'Je odkazovany');
           end;
       'U':begin
            s:='Cesta '+sti(c[1] and $F,1,0);
            if sm=1 then s:=s+', je koncove nav.';
            outtextxy(456,4,s);
           end;

      end;
  'T':begin
       s:='Tr. s£hlas ';
       if n[2]=1 then s:=s+'- moßn† zmena' else s:=s+'- bez zmeny';
       outtextxy(456,4,s);
       s:=chr(216+sm);outtextxy(456,16,'Prim†rny smer '+s);
       if n[1]>0 then s:='Autoblok NH= '+sti(n[1],5,0) else s:='Bez AB';
       outtextxy(456,28,s);
      end;
  'Z':begin
       outtextxy(456,4,'Zad. bunka ');
       s:=chr(218+(sm and 1));outtextxy(456,16,'Smer '+s);
       s:='Poüet riadkov '+sti((sm shr 1)+1,2,0);
       outtextxy(456,28,s);
      end;
 end;
end;
end;

procedure pole(x,c:word);
begin
if x=0 then exit;
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
igraph;imys;itlob('tlacobj');
getdir(0,s);
zaciatok:
setbkcolor(0);
settextstyle(2,0,4);setcolor(11);
outtextxy(350,90,'Hranice> x=('+sti(xmin,2,0)+','+sti(xmax,2,0)+') y=('+sti(ymin,2,0)+','+sti(ymax,2,0)+')');
outtextxy(120,90,'ÔÔÔ');
setcolor(14);outtextxy(200,90,'Max Xs='+sti((ymax-ymin)*xmax,5,0)+',Ymaxpl'+sti(ymax*kroky+1,4,0));
settextstyle(2,0,3);setcolor(5);
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
     dl:=charusk.dl;n[1]:=charusk.nx0;n[2]:=charusk.ty0;sm:=charusk.sm;
     odk:=charusk.odk;
     for j:=1 to 4 do c[j]:=charusk.c[j];
    end;
    krstav(charusk.xs);
    if charusk.ch[2]='T'then prvky(charusk.xs,pozicia[charusk.xs]^.stav);
   end;
  end;
 end;
end;
reset(strsu);new(txt);
setcolor(11);
while not(eof(strsu)) do begin
 read(strsu,txt^);
 if txt^.tex[1]='#' then begin
  delete(txt^.tex,1,1);
  outtextxy(sux(txt^.xs)*krokx-5,suy(txt^.xs)*kroky-7,txt^.tex);
 end else
  outtextxy(sux(txt^.xs)*krokx-5,suy(txt^.xs)*kroky-9,txt^.tex);
end;
close(strsu);dispose(txt);
kx:=xmin;ky:=ymin;
tab(0,0,639,70,1,14);
setcolor(15);settextstyle(2,0,4);settextjustify(righttext,toptext);
outtextxy(40,10,'Ch[1]:');outtextxy(110,10,'Ch[2]:');outtextxy(180,10,'xs:');outtextxy(250,10,'y:');
outtextxy(40,30,'c[1]:');outtextxy(150,30,'c[2]:');outtextxy(260,30,'c[3]:');outtextxy(370,30,'c[4]:');
outtextxy(40,50,'dl:');outtextxy(110,50,'n[1]:');outtextxy(180,50,'n[2]:');outtextxy(250,50,'sm:');
outtextxy(370,10,'Odk:');
for i:=3 to 15 do kreslitl(i);
for i:=16 to 19 do kreslitlf(i);
for i:=1 to 3 do with pam[i] do begin x:=0;y:=0;c:=0;end;
pole(kx,14);infou(kx);
repeat
 cistl:=0;ok:=cakaj(key);getmousepos(mx,my);
 case ok of
  1:begin
     cistl:=hladaj_policko(mx,my,3,19);
     case my of
       100..455:begin
                 pole(kx,8);
                 for i:=3 to 15 do kreslitl(i);
                 krstav(kx);
                 kx:=cis((mx div krokx)+1,(my div kroky)+1);
                 pole(kx,14);infou(kx);
                 if pozicia[kx]<>NIL then
                  with pozicia[kx]^ do begin
                   setcolor(0);
                   outtextxy(45,10,ch[1]);outtextxy(115,10,ch[2]);
                   von(185,10,0,4,0,kx);von(255,10,0,3,0,y);
                   von(375,10,0,3,0,odk);
                   von(45,30,0,4,0,c[1]);von(155,30,0,4,0,c[2]);
                   von(265,30,0,4,0,c[3]);von(375,30,0,4,0,c[4]);
                   von(45,50,0,4,0,dl);von(115,50,0,4,0,n[1]);
                   von(185,50,0,4,0,n[2]);von(255,50,0,3,0,sm);
                   case ch[1] of
                    'U':case ch[2] of
                         'O':begin pam[2].x:=sux(n[1]);pam[2].y:=suy(n[1]);
                                   pam[2].c:=8;pole(n[1],25);
                                   pam[3].x:=sux(n[2]);pam[3].y:=suy(n[2]);
                                   pam[3].c:=8;pole(n[2],25);
                             end;
                         'P':begin pam[2].x:=sux(c[1]);pam[2].y:=suy(c[1]);
                                   pam[2].c:=8;pole(c[1],25);
                                   pam[3].x:=sux(c[2]);pam[3].y:=suy(c[2]);
                                   pam[3].c:=8;pole(c[2],25);
                                   if sm and 3>0 then begin
                                    case sm and 3 of
                                     1:pam[4].x:=kx-xmax;
                                     2:pam[4].x:=kx+xmax;
                                    end;
                                    pam[4].y:=suy(pam[4].x);pole(pam[4].x,26);
                                    pam[4].x:=sux(pam[4].x);pam[4].c:=8;
                                   end;
                             end;
                        end;
                    'M':case ch[2] of
                         'B':begin pam[2].x:=sux(c[3]);pam[2].y:=suy(c[3]);
                                   pam[2].c:=8;pole(c[3],28);
                                   if n[1]>0 then begin
                                    pam[3].x:=sux(n[1]);pam[3].y:=suy(n[1]);
                                    pam[3].c:=8;pole(n[1],27);
                                   end;
                             end;
                         'O':begin pam[2].x:=sux(n[1]);pam[2].y:=suy(n[1]);
                                   pam[2].c:=8;pole(n[1],25);
                                   pam[3].x:=sux(n[2]);pam[3].y:=suy(n[2]);
                                   pam[3].c:=8;pole(n[2],25);
                             end;
                         'P':begin pam[2].x:=sux(c[1]);pam[2].y:=suy(c[1]);
                                   pam[2].c:=8;pole(c[1],25);
                                   pam[3].x:=sux(c[2]);pam[3].y:=suy(c[2]);
                                   pam[3].c:=8;pole(c[2],25);
                                   if sm and 3>0 then begin
                                    case sm and 3 of
                                     1:pam[4].x:=kx-xmax;
                                     2:pam[4].x:=kx+xmax;
                                    end;
                                    pam[4].y:=suy(pam[4].x);pole(pam[4].x,26);
                                    pam[4].x:=sux(pam[4].x);pam[4].c:=8;
                                   end;
                                   pam[1].x:=sux(c[3]);pam[1].y:=suy(c[3]);
                                   pam[1].c:=8;pole(c[3],28);
                             end;
                         'A','R':begin pam[1].x:=sux(c[3]);pam[1].y:=suy(c[3]);
                                   pam[1].c:=8;pole(c[3],28);
                                   if n[1]>0 then begin
                                    pam[3].x:=sux(n[1]);pam[3].y:=suy(n[1]);
                                    pam[3].c:=8;pole(n[1],27);
                                   end;
                             end;
                         'Z':begin pam[2].x:=sux(c[1]);pam[2].y:=suy(c[1]);
                                   pam[2].c:=8;pole(c[1],28);
                                   pam[3].x:=sux(c[3]);pam[3].y:=suy(c[3]);
                                   pam[3].c:=8;pole(c[3],26);
                                   pam[1].x:=sux(n[2]);pam[1].y:=suy(n[2]);
                                   pam[1].c:=8;pole(n[2],27);
                             end;
                        end;
                    'N':begin pam[2].x:=sux(c[1]);pam[2].y:=suy(c[1]);
                              pam[2].c:=8;pole(c[1],25);
                              pam[3].x:=sux(c[2]);pam[3].y:=suy(c[2]);
                              pam[3].c:=8;pole(c[2],25);
                              if c[3]>0 then begin
                               pam[1].x:=sux(c[3]);pam[1].y:=suy(c[3]);
                               pam[1].c:=8;pole(c[3],27);
                              end;
                        end;
                    'K':case ch[2] of
                         'B':begin if c[2]>0 then begin
                                    pam[2].x:=sux(c[2]);pam[2].y:=suy(c[2]);
                                    pam[2].c:=8;pole(c[2],28);
                                   end;
                                   if n[1]>0 then begin
                                    pam[3].x:=sux(n[1]);pam[3].y:=suy(n[1]);
                                    pam[3].c:=8;pole(n[1],27);
                                   end;
                                   if c[3]>0 then begin
                                    pam[1].x:=sux(c[3]);pam[1].y:=suy(c[3]);
                                    pam[1].c:=8;pole(c[3],26);
                                   end;
                             end;
                         'S':if c[3]>0 then begin
                              pam[1].x:=sux(c[3]);pam[1].y:=suy(c[3]);
                              pam[1].c:=8;pole(c[3],26);
                             end;
                        end;
                    'Z':begin pam[2].x:=sux(n[1]);pam[2].y:=suy(n[1]);
                              pam[2].c:=8;pole(n[1],25);
                              pam[3].x:=sux(n[2]);pam[3].y:=suy(n[2]);
                              pam[3].c:=8;pole(n[2],25);
                        end;
                    'T':if n[1]>0 then begin
                         pam[2].x:=sux(n[1]);pam[2].y:=suy(n[1]);
                         pam[2].c:=8;pole(n[1],25);
                        end;
                    'S':begin
                         pam[10].x:=sux(n[2]);pam[10].y:=suy(n[2]);
                         pam[10].c:=8;pole(n[2],25);
                         for i:=1 to 4 do
                          if c[i]>0 then begin
                           pam[2*i-1].x:=c[i] and 4095;
                           pole(pam[2*i-1].x,25+i);
                           pam[2*i-1].y:=suy(pam[2*i-1].x);
                           pam[2*i-1].x:=sux(pam[2*i-1].x);
                           pam[2*i].x:=c[i] shr 16;
                           pole(pam[2*i].x,25+i);
                           pam[2*i].y:=suy(pam[2*i].x);
                           pam[2*i].x:=sux(pam[2*i].x);
                          end;
                        end;
                   end;
                   pole(kx,30);
                  end
                 else
                  if ano_nie('Zad†vaú ???') then begin
                   new(pozicia[kx]);
                   with pozicia[kx]^ do begin
                    vondnus(45,10,15,0,0,2,'','',s1);ch[1]:=s1[1];
                    vondnus(115,10,15,0,0,2,'','',s1);ch[2]:=s1[1];
                    vondnu(255,10,15,0,0,3,'','',r);y:=trunc(r);
                    vondnu(375,10,15,0,0,3,'','',r);odk:=trunc(r);
                    vondnu(045,30,15,0,0,13,'','',r);c[1]:=trunc(r);
                    vondnu(155,30,15,0,0,13,'','',r);c[2]:=trunc(r);
                    vondnu(265,30,15,0,0,13,'','',r);c[3]:=trunc(r);
                    vondnu(375,30,15,0,0,13,'','',r);c[4]:=trunc(r);
                    vondnu(045,50,15,0,0,5,'','',r);dl:=trunc(r);
                    vondnu(115,50,15,0,0,5,'','',r);n[1]:=trunc(r);
                    vondnu(185,50,15,0,0,5,'','',r);n[2]:=trunc(r);
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
                      charusk.dl:=dl;charusk.nx0:=n[1];charusk.ty0:=n[2];charusk.sm:=sm;
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
                     dl:=0;n[1]:=0;n[2]:=0;sm:=0;odk:=0;
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
                       charusk.dl:=dl;charusk.nx0:=n[1];charusk.ty0:=n[2];charusk.sm:=sm;
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
                     {3:begin vondnus(45,10,15,0,0,2,'',ch[1],s1);ch[1]:=s1[1];end;
                     4:begin vondnus(115,10,15,0,0,2,'',ch[2],s1);ch[2]:=s1[1];end;}
                     6:begin vondnu(255,10,15,0,0,3,'',sti(y,3,0),r);y:=trunc(r);end;
                 7..10:if ch[1]='V' then begin
                        kreslitl(20);kreslitl(21);kreslitl(22);kreslitlf(23);
                        settextjustify(righttext,toptext);
                        outtextxy(498,10,'Cesta:');outtextxy(498,30,'Odvrat:');
                        outtextxy(498,50,'XXXX-c:');
                        settextjustify(lefttext,toptext);
                        j:=cistl-6;
                        pomv:=c[j] and 4095;
                        sces[j]:=sti((pomv shr 8) and 15,1,0)+sti((pomv shr 4) and 15,1,0)+sti(pomv and 15,1,0);
                        pomv:=(c[j] shr 12) and 15;spoc[j]:='';
                        if pomv>0 then begin
                         for i:=1 to 4 do begin
                          if pomv and 1=1 then spoc[j]:=spoc[j]+'1'
                           else spoc[j]:=spoc[j]+'0';
                          pomv:=pomv shr 1;
                         end;
                        end else spoc[j]:='x';
                        pomv:=c[j] shr 16;
                        setcolor(0);
                        outtextxy(503,10,sces[j]);outtextxy(503,30,sti(pomv,4,0));
                        outtextxy(503,50,spoc[j]);delay(500);
                        repeat
                         cistl:=0;key:=0;ok:=cakaj(key);getmousepos(mx,my);
                         case ok of
                          1:begin
                             cistl:=hladaj_policko(mx,my,20,23);
                             case cistl of
                              20:begin
                                  vondnus(503,10,15,0,0,4,'',sces[j],s);sces[j]:='';
                                  for i:=1 to 4 do sces[j]:=sces[j]+s[i];
                                 end;
                              21:begin vondnu(503,30,15,0,0,5,'',sti(pomv,4,0),r);pomv:=trunc(r);end;
                              22:begin
                                  vondnus(503,50,15,0,0,5,'',spoc[j],s);spoc[j]:='';
                                  for i:=1 to 4 do spoc[j]:=spoc[j]+s[i];
                                 end;
                              23:begin kreslitl(23);
                                  pomv:=pomv shl 4;
                                  for i:=1 to 4 do if spoc[j,i]='1' then
                                   pomv:=pomv or moc(i-1);
                                  for i:=1 to 3 do begin
                                   pomv:=pomv shl 4;val(sces[j,i],k,mx);
                                   pomv:=pomv or k;
                                  end;
                                  c[j]:=pomv;key:=27;
                                 end;
                             end;
                            end;
                          2:key:=27;
                         end;
                        until key=27;setcolor(0);key:=0;
                        kreslitl(j+6);setcolor(6);
                        case j+6 of
                         7:outtextxy(45,30,sti(c[1],9,0));
                         8:outtextxy(155,30,sti(c[2],4,0));
                         9:outtextxy(265,30,sti(c[3],4,0));
                        10:outtextxy(375,30,sti(c[4],4,0));
                        end;
                       end else begin
                        case cistl of
                         7:begin vondnu(45,30,15,0,0,13,'',sti(c[1],3,0),r);c[1]:=trunc(r);end;
                         8:begin vondnu(155,30,15,0,0,13,'',sti(c[2],3,0),r);c[2]:=trunc(r);end;
                         9:begin vondnu(265,30,15,0,0,13,'',sti(c[3],3,0),r);c[3]:=trunc(r);end;
                         10:begin vondnu(375,30,15,0,0,13,'',sti(c[4],3,0),r);c[4]:=trunc(r);end;
                        end;
                       end;
                    11:begin vondnu(45,50,15,0,0,5,'',sti(dl,4,0),r);dl:=trunc(r);end;
                    12:begin vondnu(115,50,15,0,0,5,'',sti(n[1],4,0),r);n[1]:=trunc(r);end;
                    13:begin vondnu(185,50,15,0,0,5,'',sti(n[2],4,0),r);n[2]:=trunc(r);end;
                    14:begin vondnu(255,50,15,0,0,3,'',sti(sm,3,0),r);sm:=trunc(r);end;
                    15:begin vondnu(375,10,15,0,0,3,'',sti(odk,3,0),r);odk:=trunc(r);end;
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
   charusk.dl:=dl;charusk.nx0:=n[1];charusk.ty0:=n[2];charusk.sm:=sm;
   charusk.sl:=0;charusk.odk:=odk;
  end;
  write(usek,charusk);
  dispose(pozicia[i]);
 end;
end;
close(usek);
end.
