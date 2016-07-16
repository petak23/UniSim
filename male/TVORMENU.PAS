program tvorba_menu;
uses crt,printer;
var i:word;
    directory:text;
    vybmen:file of string;
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
writeln('Chces polozky prezerat,editovat,tlacit alebo vytvorit menu?(p/e/t/v)');
writeln('TlaŸ do s£boru(s)');
writeln('Koniec - k');
end;

procedure vypis;
begin
writeln('Menu je ulozene v subore : '+menodir+naz+'.mnu');
writeln('Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybmen);i:=1;
while not(eof(vybmen)) do begin
 read(vybmen,s);
 writeln(i:2,' => '+s+' <=');
 inc(i);
end;
close(vybmen);
napis;
end;

procedure vypispr;
begin
writeln(lst,'Menu je ulozene v subore : '+menodir+naz+'.mnu');
writeln(lst,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybmen);i:=1;
while not(eof(vybmen)) do begin
 read(vybmen,s);
 writeln(lst,i:2,' => '+s+' <=');
 inc(i);
end;
close(vybmen);
writeln('Tlac OK');
end;

procedure vypissu;
var txt:text;
begin
assign(txt,menodir+naz+'.txt');rewrite(txt);
writeln(txt,'Menu je ulozene v subore : '+menodir+naz+'.mnu');
writeln(txt,'Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybmen);i:=1;
while not(eof(vybmen)) do begin
 read(vybmen,s);
 writeln(txt,i:2,' => '+s+' <=');
 inc(i);
end;
close(vybmen);close(txt);
writeln('Tlac OK');
end;

begin
clrscr;
naz:='';
write('Zadaj nazov suboru pre menu (vybmen):');readln(naz);
if length(naz)=0 then naz:='vybmen';
getdir(0,menodir);
menodir:=menodir+'\fonty\';i:=1;
if hladaj(menodir+naz+'.mnu')=false then i:=0;
assign(vybmen,menodir+naz+'.mnu');
if i=0 then begin rewrite(vybmen);close(vybmen);end;
clrscr;
vypis;
repeat
ch:=readkey;i:=1;s:='';
case ch of
 'v','V':begin
          rewrite(vybmen);
          writeln('Zadanim "qt" sa ukonci');
          repeat
           s:='';
           write('Zadaj ',i,'. polozku : ');readln(s);
           if s<>'qt' then write(vybmen,s);
           i:=i+1;
          until s='qt';
          close(vybmen);
          clrscr;
          writeln('Zapis sa previedol do suboru : '+menodir+naz+'.mnu');
          writeln('Takto vyzeraju zapisy:');s:='';
          reset(vybmen);
          while not(eof(vybmen)) do begin
           read(vybmen,s);
           writeln(' => '+s+' <=');
          end;
          close(vybmen);
          napis;
         end;
 'p','P':vypis;
 't','T':vypispr;
 's','S':vypissu;
 'e','E':begin
          writeln('Menu je ulozene v subore : '+menodir+naz+'.mnu');
          writeln('Takto vyzeraju jednotlive zapisy:');s:='';
          reset(vybmen);i:=1;
          while not(eof(vybmen)) do begin
           read(vybmen,s);
           write(' => '+s+' <=;zadaj zmenu alebo nic:>>');s:='';
           readln(s);i:=i+1;
           if s<>'' then begin
            seek(vybmen,filepos(vybmen)-1);
            write(vybmen,s);
           end;
          end;
          writeln('Pridat?(a/n)');ch1:=readkey;
          if (ch1='a') or (ch1='A') then begin
           writeln('Zadanim "qt" sa ukonci');i:=1;
           repeat
            s:='';
            write('Zadaj ',i,'. polozku : ');readln(s);
            if s<>'qt' then write(vybmen,s);
            i:=i+1;
           until s='qt';
           close(vybmen);
          end;
          clrscr;
          vypis;
         end;
end;
until ch='k';
end.