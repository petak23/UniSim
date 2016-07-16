program tvorba_menu;
uses crt,printer;
var i:word;
    directory:text;
    shelp:file of string;
    menodir,s,naz:string;
    ch,ch1:char;

function hladaj(ms:string):boolean;
 var f:file;
 begin
  {$I-}
  assign(f,ms);reset(f);close(f);
  {$I+}
  hladaj:=(ioresult=0)and(ms<>'');
end;

procedure napis;
begin
writeln('Chces polozky prezerat,editovat,tlacit alebo vytvorit Help?(p/e/t/v)');
writeln('TlaŸ do s£boru(s)');
writeln('Koniec - k');
end;

procedure vypis;
begin
writeln('Help je ulozene v subore : '+menodir+naz+'.hlp');
writeln('Takto vyzeraju jednotlive zapisy:');s:='';
reset(shelp);i:=1;
while not(eof(shelp)) do begin
 read(shelp,s);
 writeln(i:2,' => '+s+' <=');
 inc(i);
end;
close(shelp);
napis;
end;

procedure vypispr;
begin
writeln(lst,'Help je ulozene v subore : '+menodir+naz+'.hlp');
writeln(lst,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(shelp);i:=1;
while not(eof(shelp)) do begin
 read(shelp,s);
 writeln(lst,i:2,' => '+s+' <=');
 inc(i);
end;
close(shelp);
writeln('Tlac OK');
end;

procedure vypissu;
var txt:text;
begin
assign(txt,menodir+naz+'.txt');rewrite(txt);
writeln(txt,'Help je ulozene v subore : '+menodir+naz+'.hlp');
writeln(txt,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(shelp);i:=1;
while not(eof(shelp)) do begin
 read(shelp,s);
 writeln(txt,i:2,' => '+s+' <=');
 inc(i);
end;
close(shelp);close(txt);
writeln('Tlac OK');
end;

begin
clrscr;
naz:='';
write('Zadaj nazov suboru pre Help (vyphelp):');readln(naz);
if length(naz)=0 then naz:='vyphelp';
getdir(0,menodir);
menodir:=menodir+'\fonty\';i:=1;
if hladaj(menodir+naz+'.hlp')=false then i:=0;
assign(shelp,menodir+naz+'.hlp');
if i=0 then begin
 rewrite(shelp);
 s:='!!!   S£bor NEEXZISTUJE   !!!';
 write(shelp,s);
 s:='Reynoldsovo Ÿ¡slo je mimo intervalu v ktorom je mo§n‚ pod–a neho urŸiœ CWL';
 write(shelp,s);
 close(shelp);end;
clrscr;
vypis;
repeat
ch:=readkey;i:=1;s:='';
case ch of
 'v','V':begin
          rewrite(shelp);
          writeln('Zadanim "qt" sa ukonci');
          s:='!!!   S£bor NEEXZISTUJE   !!!';
          write(shelp,s);
          s:='Reynoldsovo Ÿ¡slo je mimo intervalu v ktorom je mo§n‚ pod–a neho urŸiœ CWL';
          write(shelp,s);
          repeat
           s:='';
           write('Zadaj ',i,'. polozku : ');readln(s);
           if s<>'qt' then write(shelp,s);
           i:=i+1;
          until s='qt';
          close(shelp);
          clrscr;
          writeln('Zapis sa previedol do suboru : '+menodir+naz+'.hlp');
          writeln('Takto vyzeraju zapisy:');s:='';
          reset(shelp);
          while not(eof(shelp)) do begin
           read(shelp,s);
           writeln(' => '+s+' <=');
          end;
          close(shelp);
          napis;
         end;
 'p','P':vypis;
 't','T':vypispr;
 's','S':vypissu;
 'e','E':begin
          writeln('Help je ulozene v subore : '+menodir+naz+'.hlp');
          writeln('Takto vyzeraju jednotlive zapisy:');s:='';
          reset(shelp);i:=1;
          while not(eof(shelp)) do begin
           read(shelp,s);
           write(' => '+s+' <=;zadaj zmenu alebo nic:>>');s:='';
           readln(s);i:=i+1;
           if s<>'' then begin
            seek(shelp,filepos(shelp)-1);
            write(shelp,s);
           end;
          end;
          writeln('Pridat?(a/n)');ch1:=readkey;
          if (ch1='a') or (ch1='A') then begin
           writeln('Zadanim "qt" sa ukonci');i:=1;
           repeat
            s:='';
            write('Zadaj ',i,'. polozku : ');readln(s);
            if s<>'qt' then write(shelp,s);
            i:=i+1;
           until s='qt';
           close(shelp);
          end;
          clrscr;
          vypis;
         end;
end;
until ch='k';
end.