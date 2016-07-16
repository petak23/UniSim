program navrh;
uses crt,graph,menus1,sprites,pomocny,deklar;
label skok;
var key,key1:integer;
    s1:string;
    poc:array[1..5] of word;

procedure zap;
begin
setcolor(10);outtextxy(5,412,'!!!Z A P I S A N E!!!');
end;

procedure vypis(k:boolean);
begin
 if k=true then s:='x='+sti(kx,3,0)+'  y='+sti(ky,3,0);
 setfillstyle(1,0);bar(0,409,639,479);
 setcolor(14);
 outtextxy(5,420,s);s:='';
 if s1<>'' then outtextxy(85,435,s1);s1:='';
end;

procedure pole(x,y,c:word);
begin
 setcolor(c mod 16);
 rectangle(x*(krok-1),y*(krok-1),x*krok,y*krok);
 if c<16 then vypis(true);
end;

{procedure tabulka(kx,ky:byte;charusk:chu);
begin
setfillstyle(10,1);bar(100,410,630,479);
setcolor(11);rectangle(100,410,630,479);line(100,467,630,467);
settextstyle(2,0,4);
outtextxy(105,468,'F1-Edit CH.kl.; F2-Edit zapis; F9-Zapis; F12-Zrus');
setfillstyle(1,4);bar(101,411,330,421);
setcolor(10);
outtextxy(110,411,'Vypis prvku na pozicii (xs/ys): '+sti(kx,2,0)+'/'+sti(ky,2,0));
setfillstyle(1,2);bar(348,411,475,421);
setcolor(14);outtextxy(350,411,'Charakterovy kluc:');
outtextxy(457,411,charusk.ch[1]+charusk.ch[2]);

end;}

procedure hl_odk(x,y:word;s:string;var vx,vy:byte);
var oldkx,oldky:byte;
begin
 setcolor(14);outtextxy(x,y,s);
 oldkx:=kx;oldky:=ky;
 pole(kx,ky,23);
 prvky(charusk,11,0);
 repeat
  kbd(key);
  case key of
   331{<}:begin pole(kx,ky,24);kx:=kx-1;if kx<1 then kx:=63;pole(kx,ky,25);end;
   333{>}:begin pole(kx,ky,24);kx:=kx+1;if kx>63 then kx:=1;pole(kx,ky,26);end;
   328{}:begin pole(kx,ky,24);ky:=ky-1;if ky=13 then ky:=40;pole(kx,ky,27);end;
   336{}:begin pole(kx,ky,24);ky:=ky+1;if ky=41 then ky:=14;pole(kx,ky,28);end;
   13:begin
       vx:=kx;vy:=ky;
       setcolor(0);outtextxy(x,y,s);setcolor(14);
       outtextxy(x,y,s+' X>'+sti(vx,3,0)+' Y>'+sti(vy,3,0));
      end;
  end;
 until key=13;
pole(kx,ky,24);kx:=oldkx;ky:=oldky;pole(kx,ky,30);
end;

begin
igraph;getdir(0,s);
setbkcolor(0);
delay(2500);settextstyle(2,0,3);
setcolor(5);line(0,129,630,129);line(0,401,630,401);
setcolor(8);
for i:=0 to 63 do begin
 setcolor(8);line(i*10,130,i*10,400);setcolor(7);
 if i=1 then outtextxy(5,120,'1');
 if (i+1) mod 5=0 then outtextxy(i*10+3,120,sti(i+1,2,0));
end;
for i:=13 to 40 do begin
 setcolor(8);line(0,i*10,630,i*10);setcolor(7);
 if (i+1) mod 5=0 then begin
  outtextxy(1,i*10+2,sti(i+1,2,0));
  outtextxy(621,i*10+2,sti(i+1,2,0));
 end;
end;
settextstyle(2,0,4);
ss:='s';
assign(usek,s+'\trschemy\pokus1.dat');
s:='';
if (ss='N') or (ss='n') then rewrite(usek) else
 begin
  reset(usek);
  if filesize(usek)>0 then begin
   for i:=0 to filesize(usek)-1 do begin
    read(usek,charusk);prvky(charusk,11,0);
    case charusk.ch[1] of
    'M','U':case charusk.ch[2] of
         'B','S':if charusk.ty0>poc[1] then poc[1]:=charusk.ty0;
         'A','R':if charusk.nx0>poc[1] then poc[1]:=charusk.nx0;
         'H','D','N','E':if charusk.nx0>poc[2] then poc[2]:=charusk.nx0;
         'P':if charusk.nx0>poc[3] then poc[3]:=charusk.nx0;
        end;
     'V':if charusk.nx0>poc[5] then poc[5]:=charusk.nx0;
     'T':if charusk.nx0>poc[4] then poc[4]:=charusk.nx0;
    end;
   end;
   reset(usek);
   for i:=0 to filesize(usek)-1 do begin
    read(usek,charusk);
    pozicia[charusk.xs].poz:=i;
   end;
  end;
 end;
kx:=1;ky:=14;
pole(kx,ky,9);
repeat
kbd(key);
case key of
 331{<-}:begin pole(kx,ky,8);kx:=kx-1;if kx<1 then kx:=63;pole(kx,ky,9);end;
 333{->}:begin pole(kx,ky,8);kx:=kx+1;if kx>63 then kx:=1;pole(kx,ky,10);end;
 328{}:begin pole(kx,ky,8);ky:=ky-1;if ky=13 then ky:=40;pole(kx,ky,11);end;
 336{}:begin pole(kx,ky,8);ky:=ky+1;if ky=41 then ky:=14;pole(kx,ky,12);end;
 327{HOME}:begin pole(kx,ky,8);kx:=1;pole(kx,ky,12);end;
 335{END}:begin pole(kx,ky,8);kx:=63;pole(kx,ky,12);end;
 329{PgUP}:begin pole(kx,ky,8);ky:=14;pole(kx,ky,12);end;
 337{PgDWN}:begin pole(kx,ky,8);ky:=40;pole(kx,ky,12);end;
 338{Ins}:begin pole(kx,ky,8);kx:=31;ky:=27;pole(kx,ky,12);end;
 13:

 begin
  if pozicia[kx].poz>=0 then begin

   s:='x='+sti(kx,3,0)+'  y='+sti(ky,3,0);
   hl_prvok(kx,charusk);
   with charusk do begin
    case ch[1] of
    'M','U':case ch[2] of
          'B':begin
               s:=s+' Usek:c.'+sti(ty0,5,0)+'; Typ(sm):'+sti(sm,3,0);
               if nx0=1 then s:=s+'; Pr.pr';
               s:=s+'; Dl='+sti(dl,5,0)+'m; v='+sti(c[4],3,0)+'km/h; cesta=>'+sti(c[1],3,0);
               if c[2]<>0 then s1:=' Zad.b. x='+sti(c[2],3,0)+' y='+sti(c[3],3,0);
              end;
          'O':begin
               s:=s+' Odkaz na usek:smer1-> x='+sti(nx0,3,0)+' y='+sti(ty0,3,0);
               s:=s+'; smer2<- x='+sti(c[3],3,0)+' y='+sti(c[4],3,0)+'; cesta=>'+sti(c[1],3,0);
              end;
          'H','D','E','N':begin s:=s+' Nav:c.'+sti(nx0,3,0)+'; Sm:'+sti(sm,3,0);
               case ch[2] of
                'H':s:=s+' Vchodove';
                'D':s:=s+' Odchodove,Cestove';
                'E':s:=s+' Posunovacie';
                'N':s:=s+' Koncove';
               end;
               s1:=s1+' Odkaz :v smere N. x='+sti(c[1],3,0)+' y='+sti(c[2],3,0);
               s1:=s1+'; proti smeru N. x='+sti(c[3],3,0)+' y='+sti(c[4],3,0);
                          end;
          'S','C':s:=s+' Kol:'+sti(ty0,5,0);
         end;
     'V':case ch[2] of
          'N':s:=s+' C[1]='+sti(c[1],3,0)+' C[2]='+sti(c[2],3,0);
          'K':s:=s+' C[1]='+sti(c[1],3,0)+' C[2]='+sti(c[2],3,0)+' C[3]='+sti(c[3],3,0)+' C[4]='+sti(c[4],3,0);
         end;
     'T':begin end;
     'Z':begin end;
    end;
   end;
   vypis(false);
   {tabulka(kx,ky,charusk);}
  end
  else begin
   vondnus(300,420,0,13,14,3,'Zadaj kluc',''{charusk.ch[1]+charusk.ch[2]},s);
   with charusk do begin
    ch[2]:=upcase(s[2]);ch[1]:=upcase(s[1]);xs:=kx;
   end;
   setcolor(13);
   case charusk.ch[1] of
   'M','U':case charusk.ch[2] of
     'B':begin
          inc(poc[1]);outtextxy(10,435,'Cis use.:'+sti(poc[1],3,0));charusk.ty0:=poc[1];
          vondnu(100,435,0,13,14,3,'Zadaj cestu >',sti(charusk.c[1],3,0),r);charusk.c[1]:=trunc(r);
          vondnu(350,435,0,13,14,3,'Rychlost >','120',r);charusk.c[4]:=trunc(r);
          vondnu(100,448,0,13,14,5,'Dlzka useku >',sti(charusk.dl,5,0),r);charusk.dl:=trunc(r);
          vondnu(350,448,0,13,14,2,'Priz.priec. >','0',r);charusk.nx0:=trunc(r);
          vondnu(100,461,0,13,14,3,'Typ useku (SM) >',sti(charusk.sm,3,0),r);charusk.sm:=trunc(r);
          write(usek,charusk);
          pozicia[charusk.xs].poz:=filepos(usek)-1;
          case charusk.sm of
           010,011,200:begin
            hl_odk(350,461,'Poloha Zad.b.?',v2,v3);
            vondnu(350,470,0,13,14,2,'Smer Zad.b? >','1',r);
            with charusk do begin
             ch[1]:='Z';ch[2]:='B';xs:=c[2];ys:=c[3];
             for k:=1 to 4 do
              case k of
               1,4:c[k]:=0;
               2:c[k]:=v2;
               3:c[k]:=v3;
              end;
             dl:=0;nx0:=0;ty0:=0;sm:=trunc(r);
            end;
            write(usek,charusk);
            pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
           end;
          end;
          zap;
         end;
     'O':begin
          vondnu(100,435,0,13,14,3,'Zadaj cestu >',sti(charusk.c[1],3,0),r);charusk.c[1]:=trunc(r);
          with charusk do begin
           hl_odk(100,448,'Odkaz smer <-(2)',v2,v3);c[3]:=v2;c[4]:=v3;
           hl_odk(100,461,'Odkaz smer ->(1)',v2,v3);nx0:=v2;ty0:=v3;
           c[2]:=0;sm:=0;dl:=0;
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'U':begin
          vondnu(100,435,0,13,14,3,'Zadaj cestu >',sti(charusk.c[1],3,0),r);charusk.c[1]:=trunc(r);
          vondnu(100,448,0,13,14,1,'konc.nav?(0/1) >','0',r);charusk.sm:=trunc(r);
          with charusk do begin
           hl_odk(100,461,'Odkaz X>',v2,v3);nx0:=v2;ty0:=v3;
           for k:=2 to 4 do c[k]:=0;dl:=0;
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'H','D','N','E':begin
          inc(poc[2]);outtextxy(10,435,'Cis nav.:'+sti(poc[2],3,0));charusk.nx0:=poc[2];
          vondnu(100,435,0,13,14,1,'Smer >','1',r);charusk.sm:=trunc(r);
          with charusk do begin
           hl_odk(100,448,'Odkaz v smere nav.:',v2,v3);c[1]:=v2;c[2]:=v3;
           hl_odk(100,461,'Odkaz proti smeru nav.:',v2,v3);c[3]:=v2;c[4]:=v3;
           dl:=0;ty0:=0;
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'P':begin
          inc(poc[3]);outtextxy(10,435,'Cis priec.:'+sti(poc[3],3,0));charusk.nx0:=poc[3];
          vondnu(100,435,0,13,14,4,'Dlzka priecestia >',sti(charusk.dl,5,0),r);charusk.dl:=trunc(r);
          with charusk do begin
           hl_odk(100,448,'Spust v smere 1:',v2,v3);c[1]:=v2;c[2]:=v3;
           hl_odk(100,461,'Odkaz v smere 2:',v2,v3);c[3]:=v2;c[4]:=v3;
           vondnu(500,435,0,13,14,2,'Typ pr.>','000',r);ty0:=trunc(r);
           vondnu(500,448,0,13,14,3,'Rychl.>','120',r);sm:=trunc(r);
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'A':begin
          inc(poc[1]);outtextxy(10,435,'Cis AB:'+sti(poc[1],3,0));charusk.nx0:=poc[1];
          with charusk do begin
           vondnu(100,435,0,13,14,2,'Smer >','1',r);sm:=trunc(r);
           hl_odk(100,448,'Odkaz v smere:',v2,v3);c[1]:=v2;c[2]:=v3;
           hl_odk(100,461,'Odkaz proti smeru:',v2,v3);c[3]:=v2;c[4]:=v3;
           vondnu(500,435,0,13,14,5,'Dlzka >','000',r);dl:=trunc(r);
           vondnu(500,448,0,13,14,3,'Rychl.>','120',r);ty0:=trunc(r);
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'R':begin
          inc(poc[1]);outtextxy(10,435,'Cis Pr.:'+sti(poc[1],3,0));charusk.nx0:=poc[1];
          vondnu(100,435,0,13,14,2,'Smer >','1',r);charusk.sm:=trunc(r);
          with charusk do begin
           hl_odk(100,448,'Odkaz v smere X>',v2,v3);c[1]:=v2;c[2]:=v3;
           vondnu(500,435,0,13,14,4,'Dlzka >','000',r);dl:=trunc(r);
           vondnu(500,448,0,13,14,3,'Rychl.>','120',r);ty0:=trunc(r);
           c[3]:=0;c[4]:=0;
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'S':begin
          with charusk do begin
           inc(poc[1]);outtextxy(10,435,'Cis kol:'+sti(poc[1],3,0));ty0:=poc[1];
           vondnu(100,435,0,13,14,3,'Rychl. >','1',r);sm:=trunc(r);
           vondnu(350,435,0,13,14,5,'C kol. >','1',r);nx0:=trunc(r);
           vondnu(100,448,0,13,14,3,'Nastup.hore >','000',r);c[1]:=trunc(r);
           vondnu(350,448,0,13,14,3,'Nastup.dole >','000',r);c[2]:=trunc(r);
           vondnu(100,461,0,13,14,4,'Dlzka >','0',r);dl:=trunc(r);
           vondnu(350,461,0,13,14,4,'Dlyka nas.>','0',r);c[3]:=trunc(r);
           vondnu(500,435,0,13,14,4,'boc. dlz. >','00',r);c[4]:=trunc(r);
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'C':begin
          with charusk do begin
           inc(poc[1]);outtextxy(10,435,'Cis kol:'+sti(poc[1],3,0));ty0:=poc[1];
           vondnu(100,435,0,13,14,3,'Rychl. >','1',r);c[1]:=trunc(r);
           vondnu(100,448,0,13,14,5,'C kol. >','1',r);nx0:=trunc(r);
           vondnu(100,461,0,13,14,5,'Dlzka >','0',r);dl:=trunc(r);
           vondnu(350,435,0,13,14,2,'Smer >','00',r);sm:=trunc(r);
           for k:=2 to 4 do c[k]:=0;
          end;
          write(usek,charusk);zap;
          pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;

    end;
    'V':case charusk.ch[2] of
     'N':begin
         with charusk do begin
          inc(poc[5]);outtextxy(10,435,'Cis vyh:'+sti(poc[5],3,0));nx0:=poc[5];
          vondnu(100,435,0,13,14,3,'Zadaj cestu 1 >',sti(charusk.c[1],3,0),r);c[1]:=trunc(r);
          vondnu(100,448,0,13,14,3,'Zadaj cestu 2 >',sti(charusk.c[2],3,0),r);c[2]:=trunc(r);
          vondnu(100,461,0,13,14,3,'Dlzka useku >',sti(charusk.dl,5,0),r);dl:=trunc(r);
          vondnu(350,448,0,13,14,4,'Rychlost odb. >','040',r);ty0:=trunc(r);
          c[3]:=0;c[4]:=0;
         end;
         write(usek,charusk);zap;
         pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
     'K':begin
         with charusk do begin
          inc(poc[5]);outtextxy(10,435,'Cis vyh:'+sti(poc[5],3,0));nx0:=poc[5];
          vondnu(100,435,0,13,14,3,'Zadaj cestu 1 >',sti(charusk.c[1],3,0),r);c[1]:=trunc(r);
          vondnu(100,448,0,13,14,3,'Zadaj cestu 2 >',sti(charusk.c[2],3,0),r);c[2]:=trunc(r);
          vondnu(350,435,0,13,14,3,'Zadaj cestu 3 >',sti(charusk.c[3],3,0),r);c[3]:=trunc(r);
          vondnu(350,448,0,13,14,3,'Zadaj cestu 4 >',sti(charusk.c[4],3,0),r);c[4]:=trunc(r);
          vondnu(100,461,0,13,14,4,'Dlzka useku >',sti(charusk.dl,5,0),r);dl:=trunc(r);
          vondnu(350,461,0,13,14,4,'Rychlost odb. >','040',r);ty0:=trunc(r);
         end;
         write(usek,charusk);zap;
         pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
    end;
    'T':begin
         inc(poc[4]);outtextxy(10,435,'Cis suh:'+sti(poc[4],3,0));charusk.nx0:=poc[4];
         vondnu(100,435,0,13,14,2,'Smer ? >','1',r);charusk.sm:=trunc(r);
         vondnu(100,448,0,13,14,2,'Vid ? >','0',r);charusk.ty0:=trunc(r);
         for k:=1 to 4 do charusk.c[k]:=0;charusk.dl:=0;
         write(usek,charusk);zap;
         pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
    'Z':begin
         vondnu(100,435,0,13,14,2,'Smer ? >','1',r);charusk.sm:=trunc(r);
         with charusk do begin
         for k:=1 to 4 do c[k]:=0;dl:=0;nx0:=0;ty0:=0;
         end;
         write(usek,charusk);zap;
         pozicia[charusk.xs,charusk.ys].poz:=filepos(usek)-1;
         end;
   end;
  end;
 end;
end;
prvky(charusk,11);
until key=27;
closegraph;
close(usek);
end.
