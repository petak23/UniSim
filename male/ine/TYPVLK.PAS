program fgd;
uses pomocny,crt;
var cis:longint;
    s:string;
begin
repeat
write('Cislo ? (0-koniec) : ');read(cis);
writeln(' >>> Vlak ',typ_vlaku(cis),' ',cis);
until cis=0;
end.
