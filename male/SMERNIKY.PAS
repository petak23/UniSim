unit smerniky;
interface

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ D E K L A R A C I E ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

procedure zmazf(volba:byte;var casl:longint;var por:word);
    {Zmazanie 1.prvku vo fronte a jeho hodnoty ako navrat.Volba rozhodne o fronte}
function  mazf:word;
    {Zmazanie 1.prvku vo fronte DEJA a index ako navrat,ak 0 tak chyba}
function mazidx(index:word):boolean;
    {zmazanie y fronty dej prvok s indexom. ak navratu true bolo to vykonane}
procedure vlozm(casl:longint;por:word);
    {Vlozenie do fronty DEJA podla casu}
procedure preradenie(vlak_cis:longint);
    {Preradi z fronty DEJ do POM vsetko co sa tyka vlaku vlak_cis}
procedure prepocet(cas_mom,vlak_cis:longint);
    {prepocet fonty DEJ pre vlak_cis na inu rychlost}
procedure vlozk_vlak(cislol:longint;vmaxl,vakt,vpom:byte;pozic:word);
    {vlozenie VLAKU na koniec}
procedure zmaz_vlak(cislo:longint);
    {zmazanie vlaku vo fronte VLAK podla jeho cisla}
procedure najd_vlak(cislo:longint;var vmaxi,vakt,vpom:byte);
    {najdenie vlaku vo fronte VLAK a vratenie jeho udajov o rychlosti}
procedure aktu_vlak(cislo:longint;vmaxi,vakt,vpom:byte);
    {najdenie vlaku vo fronte VLAK a akualizovanie jeho udajov o rychlosti}

implementation

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ------------------------ Procedury a funkcie ---------------------------บ}
{ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

uses crt,dos,deklar;


procedure zmazf(volba:byte;var casl:longint;var por:word);
 {zmazanie 1.prvku vo fronte a jeho hodnoty ako navrat.}
 {Vstup volba rozhoduje ktora fronta sa pouzije:1 - fronta DEJ ; 2 - fronta POM}
var temp:dej_ukaz;
begin
 casl:=-1;por:=0;
 case volba of
  1:begin if dej_vrchol=NIL then exit;
     temp:=dej_vrchol;
     with temp^ do begin
      casl:=cas;por:=cislo;
      dej_vrchol:=dalsi;
      dalsi:=NIL;
     end;
    end;
  2:begin if pom_vrchol=NIL then exit;
     temp:=pom_vrchol;
     with temp^ do begin
      casl:=cas;por:=cislo;
      pom_vrchol:=dalsi;
      dalsi:=NIL;
     end;
    end;
 end;
 if temp<>NIL then dispose(temp);
end;

function mazf:word;
{zmazanie 1.prvku a index ako navrat,ak 0 tak chyba}
var temp:dej_ukaz;
begin
 mazf:=0;
 if dej_vrchol=NIL then exit;
 temp:=dej_vrchol;
 with temp^ do begin
  mazf:=cislo;
  dej_vrchol:=dalsi;
  dalsi:=NIL;
 end;
 dispose(temp);
end;

function mazidx(index:word):boolean;
{zmazanie y fronty dej prvok s indexom. ak navratu true bolo to vykonane}
var temp,temp1:dej_ukaz;
    ok:boolean;
begin
 ok:=false;
 if dej_vrchol=NIL then exit;
 temp:=dej_vrchol;
 if temp^.cislo=index then begin
  mazidx:=true;
  dej_vrchol:=temp^.dalsi;
  temp^.dalsi:=NIL;
  dispose(temp);
  exit;
 end else begin
   temp1:=temp;
   temp:=temp^.dalsi;
  end;
 while not ok and (temp<>NIL) do begin
  with temp^ do
   if cislo=index then begin
    temp1^.dalsi:=temp^.dalsi;
    temp^.dalsi:=NIL;
    dispose(temp);
    ok:=true;
   end else begin
    temp1:=temp;
    temp:=temp^.dalsi;
   end;
 end;
 mazidx:=ok;
end;

procedure vlozm(casl:longint;por:word);{Vlozenie do fronty podla casu}
var nova,smern,smers:dej_ukaz;
    ok:boolean;
begin
 ok:=false;
 smern:=dej_vrchol;smers:=smern;
 new(nova);
 with nova^ do begin   {Naplnenie vstupov do prem. nova}
  cas:=casl;cislo:=por;dalsi:=NIL;
 end;
 if caslong<nova^.cas then begin {Dej bude v case od teraz do polnoci}
  if (nova^.cas<smern^.cas)or(dej_vrchol=NIL) then begin {Na zaciatok}
   nova^.dalsi:=dej_vrchol;
   dej_vrchol:=nova;
   nova:=NIL;
   exit;
  end else smern:=smern^.dalsi;
  while not ok and(smern<>NIL) do begin
   if nova^.cas<smern^.cas then begin  {nova je skor ako smern}
    ok:=true;
    nova^.dalsi:=smern;
    smers^.dalsi:=nova;
   end else begin
    if smers^.cas<=smern^.cas then begin
     smers:=smers^.dalsi;
     smern:=smern^.dalsi;
    end else begin
     ok:=true;
     nova^.dalsi:=smern;
     smers^.dalsi:=nova;
    end;
   end;
  end;
  if not ok then smers^.dalsi:=nova;
 end else begin                     {dej bude dalsi den po polnoci}
  smern:=smern^.dalsi;
  while not ok and(smern<>NIL) do begin
   if smers^.cas<=smern^.cas then begin
    smers:=smers^.dalsi;
    smern:=smern^.dalsi;
   end
   else begin
    while not ok and(smern<>NIL) do begin
     if nova^.cas<smern^.cas then begin
      ok:=true;
      nova^.dalsi:=smern;
      smers^.dalsi:=nova;
     end else begin
      smers:=smers^.dalsi;
      smern:=smern^.dalsi;
     end;
    end;
   end;
  end;
  if not ok and(smern=NIL) then smers^.dalsi:=nova;
 end;
 nova:=NIL;smern:=NIL;smers:=NIL;
end;

procedure preradenie(vlak_cis:longint);
    {Preradi z fronty DEJ do POM vsetko co sa tyka vlaku vlak_cis}
var temp,temp1:dej_ukaz;
begin
 temp:=NIL;temp1:=NIL;
 if pom_vrchol<>NIL then dispose(pom_vrchol);
 pom_vrchol:=NIL;
 if dej_vrchol=NIL then exit;
 temp:=dej_vrchol;
 while (slpoz[temp^.cislo].y=vlak_cis)and(temp<>NIL) do begin
  dej_vrchol:=dej_vrchol^.dalsi;
  temp^.dalsi:=pom_vrchol;
  pom_vrchol:=temp;
  temp:=dej_vrchol;
 end;
 temp1:=temp;temp:=temp^.dalsi;
 while temp<>NIL do begin
  if slpoz[temp^.cislo].y=vlak_cis then begin
   temp1^.dalsi:=temp^.dalsi;
   temp^.dalsi:=pom_vrchol;
   pom_vrchol:=temp;
   if temp1<>NIL then temp:=temp1^.dalsi;
  end
  else begin
   temp:=temp^.dalsi;
   temp1:=temp1^.dalsi;
  end;
 end;
end;

procedure prepocet(cas_mom,vlak_cis:longint);
 {prepocet fonty DEJ pre vlak_cis na inu rychlost}
var temp:dej_ukaz;
    vvm,vva,vvp:byte;
    casi:longint;
    pori:word;
begin
 najd_vlak(vlak_cis,vvm,vva,vvp);
 if (vva>0)and(vvp>0) then begin {ak sa meni rychl z vva>0 na vvp>0}
   repeat                        {zmena rychlosti vlaku}
    zmazf(2,casi,pori);
    if casi>=0 then
     with slpoz[pori] do begin
      if nst in [0..9] then cas:=(((casi-cas_mom)*vva)div vvp)+cas_mom;
      if cas=cas_mom then cas:=cas+1;
      vlozm(cas,pori);
     end;
   until casi<0;
   aktu_vlak(vlak_cis,vvm,vvp,vvp);
 end;
 if (vva=0)and(vvp>0) then begin {ak sa meni rychl z vva=0 na vvp>0}
  for i:=1 to slmax do           {vlak sa pohyna}
   if (slpoz[i].x>xmin)and(slpoz[i].x<(ymax-ymin)*xmax) then
    if slpoz[i].y=vlak_cis then begin
     with slpoz[i] do begin
      if nst in [50..60] then nst:=nst-50;
      cas:=cas_mom+(cas div vvp);
      vlozm(cas,i);
     end;
    end;
  aktu_vlak(vlak_cis,vvm,vvp,vvp);
 end;
 if (vva>0)and(vvp=0) then begin {ak sa meni rychl z vva>0 na vvp=0}
  while pom_vrchol<>NIL do begin {vlak zastavuje}
   zmazf(2,casi,pori);
   with slpoz[pori] do begin
    cas:=(casi-cas_mom)*vva;
    if nst in [0..9] then nst:=nst+50;
   end;
  end;
  aktu_vlak(vlak_cis,vvm,vvp,vvp);
 end;
end;

procedure vlozk_vlak(cislol:longint;vmaxl,vakt,vpom:byte;pozic:word);
 {vlozenie VLAKU na koniec fronty VLAK}
var temp,temp1:vlak_ukaz;
begin
 new(temp);
 temp1:=vlak_vrchol;
 with temp^ do begin
  cislo:=cislol;vmax:=vmaxl;va:=vakt;vp:=vpom;poz:=pozic;
  dalsi:=NIL;
 end;
 if temp1=NIL then vlak_vrchol:=temp
 else begin
  while not(temp1^.dalsi=NIL) do
   temp1:=temp1^.dalsi;
  temp1^.dalsi:=temp;
 end;
 temp:=NIL;
 temp1:=NIL;
end;

procedure zmaz_vlak(cislo:longint);
 {zmazanie vlaku vo fornte VLAK podla jeho cisla}
var ok:boolean;
    temp,temp1:vlak_ukaz;
begin
 ok:=false;
 temp:=vlak_vrchol;
 if vlak_vrchol=NIL then exit
 else begin
  if cislo=temp^.cislo then begin
   ok:=true;
   vlak_vrchol:=temp^.dalsi;
   temp^.dalsi:=NIL;
  end;
  while not ok do begin
   if cislo=temp^.cislo then begin
    ok:=true;
    temp1^.dalsi:=temp^.dalsi;
    temp^.dalsi:=NIL;
   end
   else begin
    temp1:=temp;
    temp:=temp^.dalsi;
   end;
  end;
  dispose(temp);
  temp1:=NIL;
 end;
end;

procedure najd_vlak(cislo:longint;var vmaxi,vakt,vpom:byte);
 {najdenie vlaku vo fronte VLAK a vratenie jeho udajov o rychlosti}
var ok:boolean;
    temp:vlak_ukaz;
    pozic:word;
begin
 temp:=vlak_vrchol;
 ok:=false;
 vmaxi:=0;vakt:=0;vpom:=0;
 if temp=nil then exit;
 while (not ok) and (temp<>NIL) do
  if cislo=temp^.cislo then ok:=true
  else temp:=temp^.dalsi;
 if ok then with temp^ do begin
  vmaxi:=vmax;vakt:=va;vpom:=vp;pozic:=poz;
 end;
 temp:=NIL;
 reset(svlak);
 seek(svlak,pozic);
 read(svlak,vlak);
end;

procedure aktu_vlak(cislo:longint;vmaxi,vakt,vpom:byte);
 {najdenie vlaku vo fronte VLAK a akualizovanie jeho udajov o rychlosti}
var ok:boolean;
    temp:vlak_ukaz;
begin
 temp:=vlak_vrchol;
 ok:=false;
 if vpom>vmaxi then vpom:=vmaxi;
 if vakt>vmaxi then vakt:=vmaxi;
 if temp=nil then exit;
 while (not ok) and (temp<>NIL) do
  if cislo=temp^.cislo then ok:=true
  else temp:=temp^.dalsi;
 if ok then with temp^ do begin
  vmax:=vmaxi;va:=vakt;vp:=vpom;
 end;
 temp:=NIL;
end;

end.