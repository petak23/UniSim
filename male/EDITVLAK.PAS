program tvorba_menu;
uses crt,dos,menus,deklar,printer;
type time=record
      h,m,s,d:word;
     end;
     vlakk1=record
      cv1,cv2:longint;
      casz,mz,mo:word;
      vm,dl:byte;
      sm:shortint;
      stm:array[1..mstan]of word;{cis SB}
      stc:array[1..mstan]of word;{cas odchodu}
     end;
var ch,ch1:char;
    cas:time;
    caspom,cvp:longint;
    s:string;
    ok:boolean;
    vlak1:vlakk1;
    svlak1:file of vlakk1;
    vlak2:vlakk;

procedure wip(b,o:string);
begin
textcolor(14);write(b);textcolor(7);write(o);
end;

procedure wipnl(b,o:string);
begin
textcolor(14);write(b);textcolor(7);writeln(o);
end;

procedure napis;
begin
textcolor(7);write('Moznosti: ');
wip('P','rezeranie,');wip('E','ditovanie,');write('p');wip('R','idanie,');
wip('G','enerovanie,');wipnl('V','ytvorit');write('pr');wip('I','nt,');
wipnl('K','oniec');
wip('Z','mena smerov');write(', k');wip('O','nverzia, ');wipnl('U','sporiadanie');
end;

function prcas(hz,mz,sz:word):string;
var s:string;
begin
if hz<10 then s:='0'+sti(hz,1,0)+':' else s:=sti(hz,2,0)+':';
if mz<10 then s:=s+'0'+sti(mz,1,0)+':' else s:=s+sti(mz,2,0)+':';
if sz<10 then s:=s+'0'+sti(sz,1,0) else s:=s+sti(sz,2,0);
prcas:=s;
end;


procedure vypis;
var s:string;
 procedure tex;
 begin
 read(svlak,vlak);
  with vlak do begin
   write(filepos(svlak):2,'=>',cv1:5,' ',casz:5,' ',mz:4,' ',mo:4,' ',cv2:5,' ',(dl*10):3,'m ',vm:3,'km/h ');
   cas.h:=casz div 36000;casz:=casz mod 36000;cas.m:=casz div 600;
   casz:=casz mod 600;cas.s:=casz div 10;
   writeln(prcas(cas.h,cas.m,cas.s),'  ',sm);
  end;
 end;

begin
writeln('Vlaky su ulozene v subore : '+ss^+'mala.dvd');
reset(svlak);
writeln('V subore je ',filesize(svlak),' poloziek.');
writeln('Takto vyzeraju jednotlive zapisy:');s:='';
writeln('Cp  C.vl1  Casl   Mz   Mo  C.vl2  Dl   Vmax   Cas zj.  sm');
if filesize(svlak)<21 then
 while not(eof(svlak)) do tex
else begin
 for i:=1 to 20 do tex;
 writeln('Poloziek v subore je viac ako 20. Spolu:',filesize(svlak),' Vypisujem prvych 20.');
end;
close(svlak);
napis;
end;

procedure vypispr;
var s:string;
 procedure texpr;
 begin
 read(svlak,vlak);
  with vlak do begin
   write(lst,filepos(svlak):2,'=>',cv1:5,' ',casz:5,' ',mz:4,' ',mo:4,' ',cv2:5,' ',(dl*10):3,'m ',vm:3,'km/h ');
   cas.h:=casz div 36000;casz:=casz mod 36000;cas.m:=casz div 600;
   casz:=casz mod 600;cas.s:=casz div 10;
   writeln(lst,prcas(cas.h,cas.m,cas.s),'  ',sm);
  end;
 end;

begin
writeln(lst,'Vlaky su ulozene v subore : '+ss^+'mala.dvd');
reset(svlak);
writeln(lst,'V subore je ',filesize(svlak),' poloziek.');
writeln(lst,'Takto vyzeraju jednotlive zapisy:');s:='';
writeln(lst,'Cp  C.vl1  Casl   Mz   Mo  C.vl2 Dl   Vmax   Cas zj.  sm');
if filesize(svlak)<21 then
 while not(eof(svlak)) do texpr
else begin
 for i:=1 to 20 do texpr;
 writeln('Poloziek v subore je viac ako 20. Spolu:',filesize(svlak),' Vypisujem prvych 20.');
end;
close(svlak);
writeln('Tlac OK');
end;

procedure generuj;
var perioda:word;
    casp:longint;
begin
clrscr;writeln('Generonanie vlakov');
writeln('Chces zmazat povodne vlaky?(A/N) ');
ch:=' ';
repeat
ch:=readkey;
until ch<>' ';
case upcase(ch) of
 'N':begin reset(svlak);while not(eof(svlak)) do read(svlak,vlak);end;
 'A':begin rewrite(svlak);writeln('Povodne vlaky vymazane');end;
end;
with vlak do begin
 cv1:=0;casz:=0;cv2:=0;mz:=0;mo:=0;vm:=0;dl:=0;sm:=0;
 write('Cas zjavenia prveho-> ');read(cas.h);write(':');read(cas.m);write(':');readln(cas.s);
 casz:=cas.h;casz:=casz*36000+cas.m*600+cas.s*10;
 write('Cas zjavenia posledneho-> ');read(cas.h);write(':');read(cas.m);write(':');readln(cas.s);
 casp:=cas.h;casp:=casp*36000+cas.m*600+cas.s*10;
 write('Perioda vlakov: ');read(perioda);
 write('Cislo prveho-> ');readln(cv1);
 write('Precislovanie prveho-> ');readln(cv2);
 write('Miesto zjavenia -> ');readln(mz);
 write('Miesto odchodu -> ');readln(mo);
 write('Max. rychlost -> ');readln(vm);
 write('Smer 1 ->,2 <- :');readln(sm);
 write('Dlzka vlaku/10 !!!: ');readln(dl);
end;
writeln('Generovat ???(A/N) ');
ch:=' ';
repeat
ch:=readkey;
until ch<>' ';
if upcase(ch)='A' then begin
 repeat
  write(svlak,vlak);
  with vlak do begin
   casz:=casz+perioda;
   cv1:=cv1+2;cv2:=cv2+2;
  end;
 until vlak.casz>=casp;
 close(svlak);
end;
vypis;
end;


begin
new(ss);
getdir(0,ss^);
ss^:=ss^+'\trschemy\';
reset(svlak);
cas.h:=0;cas.m:=0;cas.s:=0;cas.d:=0;
clrscr;
vypis;
repeat
ch:=readkey;i:=1;s:='';ch:=upcase(ch);
case ch of
 'U':begin
      writeln('');
      repeat
       reset(svlak);ok:=false;
       for i:=0 to filesize(svlak)-2 do begin
        seek(svlak,i);
        read(svlak,vlak);read(svlak,vlak2);
        if vlak.casz>vlak2.casz then begin
         ok:=true;seek(svlak,i);
         write(svlak,vlak2);write(svlak,vlak);
        end;
       end;
       write('-');
      until not ok;
      writeln('OK');
     end;
 'O':begin
      assign(svlak1,ss^+'malanew.gvd');
      rewrite(svlak1);
      reset(svlak);
      while not(eof(svlak)) do begin
       read(svlak,vlak);
       vlak1.cv1:=vlak.cv1;
       vlak1.cv2:=vlak.cv2;
       vlak1.casz:=vlak.casz div 600;
       vlak1.mz:=vlak.mz;
       vlak1.mo:=vlak.mo;
       vlak1.vm:=vlak.vm;
       vlak1.dl:=vlak.dl;
       vlak1.sm:=vlak.sm;
       for i:=1 to mstan do begin
        vlak1.stm[i]:=vlak.stm[i];vlak1.stc[1]:=vlak.stc[i];
       end;
       write(svlak1,vlak1);
      end;
      writeln('OK');
     end;
 'z','Z':begin
          reset(svlak);
          for i:=0 to filesize(svlak) do begin
           read(svlak,vlak);
           if vlak.sm=-1 then vlak.sm:=2;
           seek(svlak,filepos(svlak)-1);
           write(svlak,vlak);
          end;
          close(svlak);
          clrscr;
          vypis;
         end;
 'v','V':begin
          rewrite(svlak);
          writeln('Zadanim cisla vlaku "0" sa ukonci');
          with vlak do
          repeat
            writeln('Zadaj ',i,'. polozku : ');
            write('Cislo vlaku: ');read(cv1);
            if cv1>0 then begin
             write(' Precislovanie: ');readln(cv2);
             write('Cas zjavenia-> ');read(cas.h);write(':');read(cas.m);write(':');readln(cas.s);
             casz:=cas.h;
             casz:=casz*36000+cas.m*600+cas.s*10;
             writeln('Cas zjavenia dlhy-> ',casz);
             write('Miesto zjavenia: ');read(mz);write(' Miesto odchodu: ');readln(mo);
             write('Smer 1 ->,2 <- :');read(sm);
             write('Dlzka vlaku/10 !!!: ');read(dl);write('Max. rychlost vlaku: ');read(vm);
            end;
           if cv1<>0 then write(svlak,vlak);
            with vlak do begin
             writeln(filepos(svlak),' => ',cv1:5,' ',casz:5,' ',mz:2,' ',mo:2,' ',cv2:5,' ',dl*10,'m ',vm,'km/h');
             cas.h:=casz div 36000;casz:=casz mod 36000;cas.m:=casz div 600;
             casz:=casz mod 600;cas.s:=casz div 10;
             writeln('  <=> cas zj. >',cas.h:2,':',cas.m:2,':',cas.s:2,'  ',sm);
            end;
           i:=i+1;
          until cv1=0;
          close(svlak);
          clrscr;
          vypis
         end;
 'g','G':generuj;
 'p','P':vypis;
 'i','I':vypispr;
 'r','R':begin
          reset(svlak);
          while not(eof(svlak)) do read(svlak,vlak);
          writeln('Zadanim cisla vlaku "0" sa ukonci');
          with vlak do
          repeat
            writeln('Zadaj ',i,'. polozku : ');
            write('Cislo vlaku: ');read(cv1);
            if cv1>0 then begin
             write(' Precislovanie: ');readln(cv2);
             write('Cas zjavenia-> ');read(cas.h);write(':');read(cas.m);write(':');readln(cas.s);
             casz:=cas.h;casz:=casz*36000+cas.m*600+cas.s*10;
             writeln('Cas zjavenia dlhy-> ',casz);
             write('Miesto zjavenia: ');read(mz);write(' Miesto odchodu: ');readln(mo);
             write('Smer 1 ->,2 <- :');read(sm);
             write('Dlzka vlaku: ');read(dl);write('Max. rychlost vlaku: ');read(vm);
            end;
           if cv1<>0 then write(svlak,vlak);
            with vlak do
            writeln(filepos(svlak),' => ',cv1:5,' ',casz:5,' ',mz,' ',mo,' ',cv2:5,' ',dl,'m ',vm,'km/h');
           i:=i+1;
          until cv1=0;
          close(svlak);
          clrscr;
          vypis
         end;
 'e','E':begin
          write('Ktory vlak?');readln(cvp);reset(svlak);
          ca:=false;reset(svlak);             {najdenie vlaku, co obsadil}
           while not(eof(svlak)) and (not ca) do begin
            read(svlak,vlak);
            if cvp=vlak.cv1 then ca:=true;
           end;
          {writeln('Cp  C.vl1  Casl  Mz Mo C.vl2   Dl  Vmax     Cas zj.  sm');}
          write('    Cv');wip('1','     ');wip('C','as    ');wip('Z','m  ');wip('O','m  ');
          write(' cv');wip('2','  ');wip('D','l  ');wipnl('V','max');
          with vlak do begin
           write(filepos(svlak):2,'=>',cv1:5,' ',casz:5,' ',mz:2,' ',mo:2,' ',cv2:5,'   ',dl*10,'m ',vm:3,'km/h ');
           caspom:=casz;
           cas.h:=casz div 36000;casz:=casz mod 36000;cas.m:=casz div 600;
           casz:=casz mod 600;cas.s:=casz div 10;
           writeln(prcas(cas.h,cas.m,cas.s),'  ',sm);
           casz:=caspom;
          end;
          ch:=readkey;
          case ch of
           '1':begin
                write('Stare cislo vlaku je:',vlak.cv1,' . Zadaj nove: ');
                readln(vlak.cv1);
               end;
           '2':begin
                write('Stare cislo precislovania vlaku je:',vlak.cv2,' . Zadaj nove: ');
                readln(vlak.cv2);
               end;
           'C','c':begin
                write('Stary cas je:',vlak.casz,' . Zadaj novy: ');
                readln(vlak.casz);
               end;
           'Z','z':begin
                write('Stare miesto zjavenia je:',vlak.mz,' . Zadaj nove: ');
                readln(vlak.mz);
               end;
           'O','o':begin
                write('Stare miesto odchodu je:',vlak.mo,' . Zadaj nove: ');
                readln(vlak.mo);
               end;
           'D','d':begin
                write('Stare dlzka vlaku je:',vlak.dl,' . Zadaj novu: ');
                readln(vlak.dl);
               end;
           'V','v':begin
                write('Stare max. rychlost je:',vlak.vm,' . Zadaj novu: ');
                readln(vlak.vm);
               end;
          end;
          seek(svlak,filepos(svlak)-1);write(svlak,vlak);
          close(svlak);
          clrscr;
          vypis;
         end;
end;
until ch='K';
dispose(ss);
end.