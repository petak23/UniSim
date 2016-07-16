program navrh;
uses crt,dos,graph,menus,dswmouse,pomocny;
const dx:array[1..9]of integer=(-1, 0, 1,-1,0,1,-1, 0, 1);{posun x}
      dy:array[1..9]of integer=( 1, 1, 1, 0,0,0,-1,-1,-1);{posun y}
      xmin=01;xmax=63;{hranice}
      ymin=14;ymax=40;
      slmax=300;
type chup=^chu;
     vlakkp=^vlakk;
     tep=^te;
     longintp=^longint;
     chu=record
      ch:array[1..2]of char;
      dl,nx0,ty0:word;
      c:array[1..4] of longint;
      xs,ys,sm:byte;
      id:integer;
      odk:byte;
     end;
     te=record
      xs,ys:byte;
      tex:string;
     end;
     time=record
      h,m,s,d:word;
     end;
     vlcesta=record {vlak}
      ch:char;
      zc,kc,ts:byte;
      vyh,odv:array[1..20]of byte;
     end;
     ssta=record {pozicia}
      stav:shortint;
        {-1 - odkaz; 0 - volny; 1 - zav. pos.c.; 2 - zav vl.c.
          3 - obsadeny; 4 - porucha; 5 - rus. pos.c.; 6 - rus. vl.c.}
      vlak:longint; {ak je usek obsadeny al. pod zav.vl. al. pos c.
                  tak je tam cislo vlaku. Inak 0.}
      poz:word;
      rych:byte;
     end;
     sslpo=record  {slpoz}
      x,y,cas:longint;
      nst:shortint;
        {ako stav ale 10 - kod rusenia celej cesty}
        {novy vlak 20, 30 - AB predzvest }
     end;
     vlakk=record  {vlak}
      cv1,casz,cv2:longint;
      mz,mo,vm,dl,sm:byte;
     end;
var i,j,k,po,mx,my,vel,tlac,polh:word;
    kx,ky,v1,v2,v3:byte;
    id,koe:integer;
    ca,cha:char;
    s,ss,pos:string;
    tnew,told:time;
    dvoj,volba,konc:boolean;
    charusk,charusk1,chary,charusk2:chu;
    vlakc:vlcesta;
    vlak:vlakk;
    r:real;
    txt:tep;
    usek,cesta:file of chu;
    strsu:file of te;
    vlc:file of vlcesta;
    svlak:file of vlakk;
    pozicia:array[xmin..xmax,ymin..ymax]of ssta;
    slpoz:array[1..slmax] of sslpo;
    caslong,caspom,caszac:longint;
    pomoc:text;

function cis(X,Y:integer):integer; assembler;
asm
 mov bx,Y;        {X+(Y-ymin)*xmax}
 sub bx,ymin;
 mov ax,xmax;
 imul bx;
 add ax,X;
end;


begin
getdir(0,ss);
assign(usek,ss+'\mala.dat');reset(usek);
assign(cesta,ss+'\malanew.dat');rewrite(cesta);
po:=filesize(usek);
gotoxy(20,15);write('Urobene ');gotoxy(28,15);k:=trunc(100*polh/po);write(k:3,'%');
while not(eof(usek)) do begin
 read(usek,charusk);polh:=filepos(usek);
 with charusk do
 case ch[1] of
  'U':case ch[2] of
       'B':begin ty0:=c[4];c[4]:=0;
                 reset(usek);ca:='a';
                 while (not(eof(usek)))and(ca='a') do begin
                  read(usek,charusk1);
                  if (charusk1.ch[1]='Z')and(charusk1.nx0=c[2]) then ca:='n';
                 end;
                 c[3]:=cis(charusk1.xs,charusk1.ys);c[2]:=0;id:=0;
                 write(cesta,charusk);
                 seek(usek,polh);
           end;
       'O':begin nx0:=cis(nx0,ty0);ty0:=cis(c[3],c[4]);
                 dl:=0;c[2]:=0;c[3]:=0;c[4]:=0;id:=0;odk:=0;
                 write(cesta,charusk);
           end;
       'H':begin c[1]:=cis(c[1],c[2]);c[2]:=cis(c[3],c[4]);c[4]:=0;
                 reset(usek);ca:='a';
                 while (not(eof(usek)))and(ca='a') do begin
                  read(usek,charusk1);
                  if (charusk1.ch[1]='Z')and(charusk1.nx0=ty0) then ca:='n';
                 end;
                 c[3]:=cis(charusk1.xs,charusk1.ys);dl:=0;nx0:=0;ty0:=0;
                 id:=0;odk:=0;
                 write(cesta,charusk);
                 seek(usek,polh);
           end;
       'D','E','N':begin c[1]:=cis(c[1],c[2]);c[2]:=cis(c[3],c[4]);
                         c[4]:=0;c[3]:=0;dl:=0;nx0:=0;ty0:=0;
                         id:=0;odk:=0;
                         write(cesta,charusk);
                   end;
       'P':begin c[1]:=cis(c[1],c[2]);c[2]:=cis(c[3],c[4]);
                 c[4]:=ty0;c[3]:=0;ty0:=sm;nx0:=0;sm:=0;
                 id:=0;odk:=0;
                 write(cesta,charusk);
           end;
       'A':begin for i:=1 to 4 do c[i]:=0;
                 nx0:=0;id:=0;odk:=0;
                 write(cesta,charusk);
           end;
       'R':begin c[1]:=cis(c[1],c[2]);c[2]:=0;
                 c[4]:=ty0;c[3]:=0;nx0:=0;id:=0;odk:=0;
                 write(cesta,charusk);
           end;
       'S':begin i:=c[2];c[2]:=c[3];c[3]:=i;ty0:=sm;sm:=0;id:=0;
                 write(cesta,charusk);
           end;
       'U':begin nx0:=cis(nx0,ty0);
                 write(cesta,charusk);
           end;
      end;
  'V':case ch[2] of
       'N':begin nx0:=ty0;ty0:=0;
                 write(cesta,charusk);
           end;
       'K':begin nx0:=ty0;ty0:=0;
                 write(cesta,charusk);
           end;
      end;
  'Z','T':begin nx0:=0;write(cesta,charusk);end;
  'M':begin reset(usek);ca:='a';
            while (not(eof(usek)))and(ca='a') do begin
             read(usek,charusk1);
             if (charusk1.ch[1]='Z')and(charusk1.nx0=c[3]) then ca:='n';
            end;
            c[3]:=cis(charusk1.xs,charusk1.ys);id:=0;odk:=0;
            write(cesta,charusk);
            seek(usek,polh);
      end;
 end;
gotoxy(28,15);k:=trunc(100*polh/po);write(k:3,'%');
end;
textcolor(128+14);gotoxy(20,16);write('!!!Dokoncene!!!');
readln;
close(usek);close(cesta);
end.