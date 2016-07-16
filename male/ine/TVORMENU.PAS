program tvorba_menu;
uses crt;
var i:word;
    directory:text;
    vybmen:file of string;
    menodir,s:string;
    ch,ch1:char;

procedure napis;
begin
writeln('Chces polozky prezerat,editovat alebo vytvorit menu?(p/e/v)');
writeln('Koniec - k');
end;

procedure vypis;
begin
writeln('Menu je ulozene v subore : '+menodir+'\vybmen.mnu');
writeln('Takto vyzeraju jednotlive zapisy:');s:='';
reset(vybmen);
while not(eof(vybmen)) do begin
 read(vybmen,s);
 writeln(' => '+s+' <=');
end;
close(vybmen);
napis;
end;

begin
getdir(0,menodir);
menodir:=menodir+'\fonty';
assign(vybmen,menodir+'\vybmen.mnu');
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
          writeln('Zapis sa previedol do suboru : '+menodir+'\vybmen.mnu');
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
 'e','E':begin
          writeln('Menu je ulozene v subore : '+menodir+'\vybmen.mnu');
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