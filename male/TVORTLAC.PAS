program tvorba_menu;
uses crt,printer,tlacidka,graph,menus1;
label zas;
const vyr_text=14;
      nor_text=7;
var i,j,k:word;
    directory:text;
    menodir,s,naz:string;
    ch,ch1:char;
    ok:boolean;

function hladaj(ms:string):boolean;
 var f:file;
 begin
  {$I-}
  assign(f,ms);reset(f);close(f);
  {$I+}
  hladaj:=(ioresult=0)and(ms<>'');
end;

procedure zv(text1,pismeno,text2:string);
begin
textcolor(nor_text);write(text1);
textcolor(vyr_text);write(pismeno);
textcolor(nor_text);write(text2);
end;

procedure napis;
begin
textcolor(7);writeln('Moznosti:');
zv(' ','P','rezerat,');zv(' ','E','ditovat,');zv(' ','T','lacit,');
zv(' ','V','ytvorit novy,');zv(' tlaŸ do ','S','£boru,');
writeln('');zv(' ','G','raficka prewiew,');zv(' p','R','idanie');
writeln('');zv(' ','K','oniec');writeln('');
end;

procedure vypis;
begin
writeln('Tlacitka su ulozene v subore : '+menodir+naz+'.obt');
writeln('Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybtl);i:=1;
while not(eof(vybtl)) do begin
 read(vybtl,poltl);
 with poltl do
  writeln(i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
 inc(i);
 if i mod 22=0 then begin
  writeln('   pokraŸuj Enter...');readln;
 end;
end;
close(vybtl);
napis;
end;

procedure vypispr;
begin
writeln(lst,'Tlacitka su ulozene v subore : '+menodir+naz+'.obt');
writeln(lst,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybtl);i:=1;
while not(eof(vybtl)) do begin
 read(vybtl,poltl);
 with poltl do
  writeln(lst,i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
 inc(i);
end;
close(vybtl);
writeln('Tlac OK');
end;

procedure vypissu;
var txt:text;
begin
assign(txt,menodir+naz+'.txt');rewrite(txt);
writeln(txt,'Tlacitka su ulozene v subore : '+menodir+naz+'.obt');
writeln(txt,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybtl);i:=1;
while not(eof(vybtl)) do begin
 read(vybtl,poltl);
 with poltl do
  writeln(txt,i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
 inc(i);
end;
close(vybtl);close(txt);
writeln('Tlac OK');
end;

begin
clrscr;
naz:='';
write('Zadaj nazov suboru pre tlacitka (tlacobj):');readln(naz);
if length(naz)=0 then naz:='tlacobj';
getdir(0,menodir);
menodir:=menodir+'\fonty\';i:=1;
if hladaj(menodir+naz+'.obt')=false then i:=0;
assign(vybtl,menodir+naz+'.obt');
if i=0 then begin
 rewrite(vybtl);
 for i:=1 to 2 do begin
  with poltl do
   case i of     {Tl. 1 a 2 rezervovane funkciou POPEN}
    1:begin x:=405;y:=400;dx:=0;  dy:=20; text:='Novì';end;
    2:begin x:=438;y:=400;dx:=0;  dy:=20; text:='Otvor';end;
   end;
  write(vybtl,poltl);
 end;
 close(vybtl);
end;
clrscr;
vypis;
repeat
ch:=readkey;i:=1;s:='';
case ch of
 'v','V':begin
          rewrite(vybtl);
          for i:=1 to 2 do begin
           with poltl do
             case i of     {Tl. 1 a 2 rezervovane funkciou POPEN}
             1:begin x:=405;y:=400;dx:=0;  dy:=20; text:='Novì';end;
             2:begin x:=438;y:=400;dx:=0;  dy:=20; text:='Otvor';end;
            end;
           write(vybtl,poltl);
          end;
          writeln('Zadanim "qt" sa ukonci. Polozky 1-2 REZERVOVANE');
          i:=3;
          repeat
           with poltl do begin
            write('Zadaj ',i,'. polozku : text:');readln(text);
            if text<>'qt' then begin
             write('                   x:');read(x);
             write('                   y:');read(y);
             write('                  dx:');read(dx);
             write('                  dy:');read(dy);
             write('                  id:');readln(id);
             write(vybtl,poltl);
             i:=i+1;
            end;
           end;
          until poltl.text='qt';
          close(vybtl);
          clrscr;
          writeln('Zapis sa previedol do suboru : '+menodir+naz+'.obt');
          writeln('Takto vyzeraju zapisy:');s:='';
          reset(vybtl);i:=1;
          while not(eof(vybtl)) do begin
           read(vybtl,poltl);
           with poltl do
           writeln(i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
           inc(i);
          end;
          close(vybtl);
          napis;
         end;
 'p','P':vypis;
 't','T':vypispr;
 's','S':vypissu;
 'e','E':begin
          writeln('Tlacitka je ulozene v subore : '+menodir+naz+'.obt');
          writeln('Takto vyzeraju jednotlive zapisy:');s:='';
          write('Editovat');zv(' ','J','edno alebo');
          zv(' ','V','setky:');
          ch1:=readkey;i:=0;
          if ch1='j' then begin
           write('¬¡slo prvku?? :');readln(i);
          end;
          reset(vybtl);ok:=false;
          if i=0 then begin i:=1;
           write('¬o editovaœ? ');zv('( ','X',',');
           zv(' ','Y',',');zv(' ','D','x,');zv(' ','E','-dy,');
           zv(' ','I','d,');zv(' ','T','ext,');zv(' ','P','ridat):');writeln('');
           ch1:=readkey;
           while not(eof(vybtl)) do begin
            read(vybtl,poltl);
            with poltl do begin
             writeln(i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
             case ch1 of
             'x':begin write('X: => ',poltl.x,' <=;zadaj zmenu :>>');poltl.x:=0;
                       readln(poltl.x);i:=i+1;ok:=true;end;
             'y':begin write('Y: => ',poltl.y,' <=;zadaj zmenu :>>');poltl.y:=0;
                       readln(poltl.y);i:=i+1;ok:=true;end;
             'd':begin write('DX: => ',poltl.dx,' <=;zadaj zmenu :>>');poltl.dx:=0;
                       readln(poltl.dx);i:=i+1;ok:=true;end;
             'e':begin write('DX: => ',poltl.dy,' <=;zadaj zmenu :>>');poltl.dy:=0;
                       readln(poltl.dy);i:=i+1;ok:=true;end;
             'i':begin write('ID: => ',poltl.id,' <=;zadaj zmenu :>>');poltl.id:=0;
                       readln(poltl.id);i:=i+1;ok:=true;end;
             't':begin write('TXT: => '+poltl.text+' <=;zadaj zmenu alebo nic:>>');poltl.text:='';
                       readln(poltl.text);i:=i+1;
                       if poltl.text<>'' then ok:=true;
                       end;
             end;
            end;
             if ok then begin
              seek(vybtl,filepos(vybtl)-1);
              write(vybtl,poltl);
             end;
           end;
          end else begin
           seek(vybtl,i-1);
           read(vybtl,poltl);
           zas:
           with poltl do begin
            writeln(i:2,' => ',text,' - ',x,',',y,',',dx,',',dy,',',id);
            write('¬o editovaœ? ');zv('( ','X',',');
            zv(' ','Y',',');zv(' ','D','x,');zv(' ','E','-dy,');
            zv(' ','I','d,');zv(' ','T','ext,');zv(' ','P','ridat):');writeln('');
            ch1:=readkey;
            case ch1 of
            'x':begin write('X: => ',poltl.x,' <=;zadaj zmenu :>>');poltl.x:=0;
                      readln(poltl.x);i:=i+1;ok:=true;end;
            'y':begin write('Y: => ',poltl.y,' <=;zadaj zmenu :>>');poltl.y:=0;
                      readln(poltl.y);i:=i+1;ok:=true;end;
            'd':begin write('DX: => ',poltl.dx,' <=;zadaj zmenu :>>');poltl.dx:=0;
                      readln(poltl.dx);i:=i+1;ok:=true;end;
            'e':begin write('DX: => ',poltl.dy,' <=;zadaj zmenu :>>');poltl.dy:=0;
                      readln(poltl.dy);i:=i+1;ok:=true;end;
            'i':begin write('ID: => ',poltl.id,' <=;zadaj zmenu :>>');poltl.id:=0;
                      readln(poltl.id);i:=i+1;ok:=true;end;
            't':begin write('TXT: => '+poltl.text+' <=;zadaj zmenu alebo nic:>>');poltl.text:='';
                      readln(poltl.text);i:=i+1;
                      if poltl.text<>'' then ok:=true;
                      end;
            end;
           end;
           writeln('Dalej(a/n)');ch1:=readkey;
           if ch1='a' then goto zas;
           if ok then begin
            seek(vybtl,filepos(vybtl)-1);
            write(vybtl,poltl);
           end;
           i:=0;
          end;
          if i>0 then
          if ch1='p' then ch1:='a' else
           begin writeln('Pridat?(a/n)');ch1:=readkey;end;
          if (ch1='a') or (ch1='A') then begin
           writeln('Zadanim "qt" sa ukonci');
           repeat
            with poltl do begin
             write('Zadaj ',i,'. polozku : text:');readln(text);
             if text<>'qt' then begin
              write('                   x:');read(x);
              write('                   y:');read(y);
              write('                  dx:');read(dx);
              write('                  dy:');read(dy);
              write('                  id:');readln(id);
              write(vybtl,poltl);
              i:=i+1;
             end;
            end;
           until poltl.text='qt';
           close(vybtl);
          end;
          clrscr;
          vypis;
         end;
 'r','R':begin
          reset(vybtl);i:=filesize(vybtl);seek(vybtl,i);
           writeln('Zadanim "qt" sa ukonci');inc(i);
           repeat
            with poltl do begin
             write('Zadaj ',i,'. polozku : text:');readln(text);
             if text<>'qt' then begin
              write('                   x:');read(x);
              write('                   y:');read(y);
              write('                  dx:');read(dx);
              write('                  dy:');read(dy);
              write('                  id:');readln(id);
              write(vybtl,poltl);
              i:=i+1;
             end;
            end;
           until poltl.text='qt';
           close(vybtl);
          clrscr;
          vypis;
         end;
 'g','G':begin
         write('OD?? :');readln(j);write('DO?? :');readln(k);
         zv('','T','rue/');zv('','F','alse?');ch1:=readkey;
         igraph;
         tab(0,0,639,70,1,14);
         line(360,3,360,67);setcolor(14);line(363,3,363,67);
         setfillstyle(1,9);bar(454,4,635,66);
         setcolor(15);
         settextstyle(2,0,4);settextjustify(righttext,toptext);
         outtextxy(40,10,'Ch[1]:');outtextxy(110,10,'Ch[2]:');outtextxy(180,10,'xs:');outtextxy(250,10,'y:');
         outtextxy(40,30,'c[1]:');outtextxy(150,30,'c[2]:');outtextxy(260,30,'c[3]:');outtextxy(370,30,'c[4]:');
         outtextxy(40,50,'dl:');outtextxy(110,50,'nx0:');outtextxy(180,50,'ty0:');outtextxy(250,50,'sm:');
         outtextxy(370,10,'Odk:');
         outtextxy(498,10,'Cesta:');
         outtextxy(498,30,'Odvrat:');
         outtextxy(498,50,'XXXX-c:');
         for i:=j to k do
          case ch1 of
           't','T':kreslitl(i);
           'f','F':kreslitlf(i);
          end;
         readln;
         closegraph;clrscr;vypis;
         end;
end;
until ch='k';
end.