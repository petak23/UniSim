program Prevody;    {Realizuju sa nim prevody datovych suborov}
uses crt,deklar,graph,menus1,pomocny,sprites;
const dlsub=1200;
var von,von1:text;
    s,s1:string;
    v3:byte;
    ok:boolean;
    vlak2:vlakk;
    per,casp:word;
    ch:char;
    ook:longint;
    v1,v2:byte;

procedure tab_pr(s1,s2,s3,s4:string);
begin
 setfillstyle(1,1);bar(180,200,440,300);setcolor(9);rectangle(180,200,440,300);
 rectangle(185,205,435,295);
 setcolor(14);outtextxy(190,220,s1);setcolor(3); outtextxy(190,235,s2);
 setcolor(6); outtextxy(190,250,s3);outtextxy(190,265,s4);
 setcolor(14);outtextxy(191,251,s3);outtextxy(191,266,s4);
end;

procedure tab_nul;
begin
 setcolor(12);outtextxy(220,280,'UKONCENE - Stlac ENTER');
 setcolor(10);outtextxy(221,281,'UKONCENE - Stlac ENTER');
 readln;setfillstyle(0,0);bar(180,200,440,300);
end;


function prevct(input:longint;po:byte):string;
var a:string;   {Prevod cisla input na retazec dlzky po}
begin
a:='';
if input>0 then begin
 a:=sti(input,po,0);
 if length(a)<po then for i:=1 to po-length(a) do a:='0'+a;
              end;
if input=0 then for i:=1 to po do a:=a+'0';
prevct:=a;
end;

procedure chutotxt; {Prevod suborov DAT do formatu TXT}
begin
 tab_pr('Vykonava sa prevod DAT -> txt','IN  subor : '+naz+'.dat','OUT subor : '+naz+'.txt','            '+naz+'1.txt');
 assign(von,ss^+naz+'.txt');
 assign(von1,ss^+naz+'1.txt');
 s:='';
 reset(usek);rewrite(von);rewrite(von1);
 if filesize(usek)>0 then
 if filesize(usek)<dlsub then
  for k:=0 to filesize(usek)-1 do begin
   with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
    for i:=1 to 4 do c[i]:=0;sm:=0;
   end;
   read(usek,charusk);
   with charusk do begin
    s:=ch[1]+ch[2]+' '+prevct(xs,4)+' '+prevct(y,3);
    for j:=1 to 4 do s:=s+' '+prevct(c[j],8);
    s:=s+' '+prevct(dl,6)+' '+prevct(nx0,5)+' '+prevct(ty0,5)+' '+prevct(sm,3);
    s:=s+' 0 '+prevct(odk,1);
   end;
   writeln(von,s);
  end
 else begin
  for k:=0 to dlsub do begin
   with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
    for i:=1 to 4 do c[i]:=0;sm:=0;
   end;
   read(usek,charusk);
   with charusk do begin
    s:=ch[1]+ch[2]+' '+prevct(xs,4)+' '+prevct(y,3);
    for j:=1 to 4 do s:=s+' '+prevct(c[j],3);
    s:=s+' '+prevct(dl,6)+' '+prevct(nx0,5)+' '+prevct(ty0,5)+' '+prevct(sm,3);
    s:=s+' 0 '+prevct(odk,1);
   end;
   writeln(von,s);
  end;
  for k:=(dlsub+1) to filesize(usek)-1 do begin
   with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
    for i:=1 to 4 do c[i]:=0;sm:=0;
   end;
   read(usek,charusk);
   with charusk do begin
    s:=ch[1]+ch[2]+' '+prevct(xs,4)+' '+prevct(y,3);
    for j:=1 to 4 do s:=s+' '+prevct(c[j],3);
    s:=s+' '+prevct(dl,6)+' '+prevct(nx0,5)+' '+prevct(ty0,5)+' '+prevct(sm,3);
    s:=s+' 0 '+prevct(odk,1);
   end;
   writeln(von1,s);
  end;
 end;
 close(usek);close(von);close(von1);
 delay(1500);
 tab_nul;
end;



procedure txttochu;    {Prevod suborov TXT do formatu DAT}

function prevtc(odka,dok:byte):longint;
var a:string;
    i:integer;
    j:longint;
begin
a:='';for i:=odka to dok do a:=a+s[i];
val(a,j,i);prevtc:=j;
end;

begin
 tab_pr('Vykonava sa prevod txt -> DAT','IN  subor : '+naz+'.txt','            '+naz+'1.txt','OUT subor : '+naz+'.dat');
 assign(von,ss^+naz+'.txt');
 assign(von1,ss^+naz+'1.txt');
 s:='';
 reset(von);reset(von1);rewrite(usek);
 while not(eof(von)) do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  readln(von,s);
  with charusk do begin
   ch[1]:=s[1];ch[2]:=s[2];xs:=prevtc(4,7);y:=prevtc(9,11);
   for k:=1 to 4 do c[k]:=prevtc(4+k*9,11+k*9);
   dl:=prevtc(49,54);nx0:=prevtc(56,60);ty0:=prevtc(62,66);
   sm:=prevtc(68,70);sl:=prevtc(72,72);odk:=prevtc(74,74);
  end;
  write(usek,charusk);
 end;
 while not(eof(von1)) do begin
  with charusk do begin ch[1]:=' ';ch[2]:=' ';xs:=0;y:=0;dl:=0;nx0:=0;ty0:=0;
   for i:=1 to 4 do c[i]:=0;sm:=0;
  end;
  readln(von1,s);
  with charusk do begin
   ch[1]:=s[1];ch[2]:=s[2];xs:=prevtc(4,7);y:=prevtc(9,11);
   for k:=1 to 4 do c[k]:=prevtc(4+k*9,11+k*9);
   dl:=prevtc(49,54);nx0:=prevtc(56,60);ty0:=prevtc(62,66);
   sm:=prevtc(68,70);sl:=prevtc(72,72);odk:=prevtc(74,74);
  end;
  write(usek,charusk);
 end;
 delay(1500);
 tab_nul;
 setfillstyle(0,0);bar(180,200,440,300);
end;

function prvct(input:byte):string;
begin
 case input of
  0:prvct:='_';
  1..9:prvct:=sti(input,1,0);
  10:prvct:='A';
 end;
end;

procedure vlatotxt;
begin
 tab_pr('Vykonava sa prevod DAT -> txt','IN  subor : '+naz+'.dvl','OUT subor : '+naz+'vl.txt','');
 assign(von,ss^+naz+'vl.txt');s:='';
 reset(vlc);rewrite(von);
 if filesize(vlc)>0 then
 for k:=0 to filesize(vlc)-1 do begin
  with vlakc do begin
   ch:=0;zc:=0;kc:=0;
   for i:=1 to 20 do begin vyh[i]:=0;end;
  end;
  s:='';
  read(vlc,vlakc);
  with vlakc do begin
   s:=prevct(ch,1)+' '+prevct(zc,4)+' '+prevct(kc,4)+' ';
   for j:=1 to 20 do s:=s+prvct(vyh[j]);
  end;
  writeln(von,s);
 end;
 close(vlc);close(von);
 delay(1500);
 tab_nul;
end;

procedure txttovla;

function prevtc(odka,dok:byte):word;
var a:string;
begin
a:='';for i:=odka to dok do a:=a+s[i];
val(a,j,i);prevtc:=j;
end;

function prevtc1(odka:byte):word;
begin
case s[odka] of
 '_':prevtc1:=0;
 '1'..'9':begin val(s[odka],j,i);prevtc1:=j;end;
 'A':prevtc1:=10;
end;
end;

begin
 tab_pr('Vykonava sa prevod txt -> DAT','IN  subor : '+naz+'vl.txt','OUT subor : '+naz+'.dvl','');
 assign(von,ss^+naz+'vl.txt');
 reset(von);rewrite(vlc);
 while not(eof(von)) do begin
  with vlakc do begin
   ch:=0;zc:=0;kc:=0;
   for i:=1 to 20 do begin vyh[i]:=0;end;
  end;
  s:='';
  readln(von,s);
  with vlakc do begin
   ch:=prevtc(1,1);zc:=prevtc(3,6);kc:=prevtc(8,11);
   for k:=1 to 20 do vyh[k]:=prevtc1(12+k);
  end;
  write(vlc,vlakc);
 end;
 close(vlc);close(von);
 delay(1500);
 tab_nul;
end;

procedure nazov;
begin
{ naz:=popen;}
 setfillstyle(0,0);bar(10,100,150,112);
 setcolor(10);rectangle(10,100,150,112);
 settextjustify(CenterText,TopText);
 setcolor(14);outtextxy(80,102,'Subor :'+naz);
 settextjustify(LeftText,TopText);
end;

procedure tabalt;
begin
 setcolor(14);rectangle(10,124,150,365);rectangle(10,375,150,425);
 setcolor(6);line(11,136,149,136);line(80,136,80,364);
 settextjustify(CenterText,TopText);setcolor(9);
 outtextxy(80,127,'Alt - Tabulka');
 setcolor(15);
 j:=0;k:=45;
 for i:=129 to 253 do begin
  case i of
   129,130,132,142,144..147,149,150,155,156,159..163,166,167,172,
   181,183,210,212..214,216,226,229..234,236,237,253:begin
    setcolor(15);
    outtextxy(k,139+j*12,chr(i)+'-'+sti(i,3,0));
    inc(j);end;
  end;
  if j=19 then begin j:=0;k:=115;end;
 end;
 settextjustify(LeftText,TopText);
 outtextxy(18,379,'F5-Pridaj text');
 outtextxy(18,391,'F6-Edituj riadok');
 outtextxy(18,403,'F8-Zmaz riadok');
 outtextxy(18,415,'F9-Ukonc edit.');
end;

procedure deltabalt;
begin
 setfillstyle(0,0);bar(10,124,150,430);
end;


procedure edittxt;    {Editovanie textov}
label zaciatok;
var tt:array[0..24] of tep;
    zac,kon:word;
    st,no,key:integer;
    miesto:pointer;
    velkost:word;
    strpom:file of te;
    r:real;

 procedure riadok(ind,farba:word);
  begin
   setcolor(farba);
   settextjustify(CenterText,TopText);
   outtextxy(190,127+ind*12,sti(tt[ind]^.xs,5,0));
   outtextxy(585,127+ind*12,tt[ind]^.skr);
   settextjustify(LeftText,TopText);
   outtextxy(225,127+ind*12,tt[ind]^.tex);
  end;

 procedure pohyb;
  begin
   riadok(st,9);
   riadok(no,15);
  end;

begin
 tabalt;
 no:=0;st:=0;
 for i:=0 to 24 do new(tt[i]);
 zaciatok:
 for i:=0 to 24 do
  with tt[i]^ do begin
   xs:=0;tex:='';skr:='';
  end;
 setcolor(14);rectangle(160,100,600,425);
 setcolor(6);line(161,112,599,112);line(161,124,599,124);
 line(220,112,220,424);line(570,112,570,424);
 settextjustify(CenterText,TopText);setcolor(9);
 outtextxy(380,103,'Editovanie textov na ploche UnIsiM-u');
 setcolor(14);outtextxy(190,115,'Poloha');outtextxy(395,115,'Text');
 outtextxy(585,115,'Skr');
 reset(strsu);
 settextjustify(LeftText,TopText);zac:=0;ca:=false;i:=0;
 while (not(eof(strsu)))and(not ca) do begin
  read(strsu,tt[i]^);
  kon:=i;
  inc(i);
  if i=25 then ca:=true;
 end;
 setcolor(9);
 for i:=0 to kon do begin
  riadok(i,9);
 end;
 riadok(no,15);
 repeat;kbd(key);
  case key of
   336:{}begin st:=no;no:=no+1;if no=(kon+1) then no:=0;pohyb;end;
   328:{}begin st:=no;no:=no-1;if no=-1 then no:=kon;pohyb;end;
   319:{F5-Prid}begin
        velkost:=imagesize(160,200,600,241);getmem(miesto,velkost);
        getimage(160,200,600,241,miesto^);setfillstyle(1,1);bar(160,200,600,241);
        setcolor(9);rectangle(160,200,600,241);
        setcolor(14);setfillstyle(1,9);
        outtextxy(168,205,'Poloha: ');bar(225,204,280,214);
        outtextxy(168,217,'Text: ');bar(210,216,590,226);
        outtextxy(168,229,'Skratka: ');bar(233,228,273,238);new(txt);
        dnu(227,202,9,15,5,'',r);txt^.xs:=trunc(r);
        dnustr(213,214,9,15,30,'',0,txt^.tex);
        dnustr(236,226,9,15,3,'',0,s);txt^.skr:=copy(s,1,3);
        putimage(160,200,miesto^,normalput);
        reset(strsu);seek(strsu,filesize(strsu));
        write(strsu,txt^);
        setfillstyle(0,0);bar(162,113,598,424);settextstyle(0,0,1);
        goto zaciatok;
       end;
   320:{F6-Edit}begin
        velkost:=imagesize(160,200,600,241);getmem(miesto,velkost);
        getimage(160,200,600,241,miesto^);setfillstyle(1,1);bar(160,200,600,241);
        setcolor(9);rectangle(160,200,600,241);
        setcolor(14);setfillstyle(1,9);new(txt);
        reset(strsu);seek(strsu,no+zac);read(strsu,txt^);settextstyle(2,0,4);
        outtextxy(168,205,'Poloha: ');bar(225,204,280,214);outtextxy(227,202,sti(txt^.xs,5,0));
        outtextxy(168,217,'Text: ');bar(210,216,590,226);outtextxy(213,214,txt^.tex);
        outtextxy(168,229,'Skratka: ');bar(233,228,273,238);outtextxy(236,226,txt^.skr);
        dnu(227,202,9,15,5,sti(txt^.xs,5,0),r);txt^.xs:=trunc(r);
        dnustr(213,214,9,15,30,txt^.tex,0,txt^.tex);
        dnustr(236,226,9,15,3,txt^.skr,0,s);txt^.skr:=copy(s,1,3);
        putimage(160,200,miesto^,normalput);
        reset(strsu);seek(strsu,no+zac);
        write(strsu,txt^);
        setfillstyle(0,0);bar(162,113,598,424);settextstyle(0,0,1);
        goto zaciatok;
       end;
   322:{F8-Maz}begin
        velkost:=imagesize(5,225,635,255);getmem(miesto,velkost);
        getimage(5,225,635,255,miesto^);
        setfillstyle(1,4);bar(5,225,635,255);
        setlinestyle(0,0,1);setcolor(14);
        rectangle(10,230,630,250);setcolor(10);
        settextjustify(CenterText,TopText);
        outtextxy(320,237,'??? Naozaj ZMAZAT ??? (Ano-Enter / Nie-Esc) '+sti(no+1,3,0)+'. polozku?');
        settextjustify(LeftText,TopText);
        repeat;kbd(key);until (key=13)or(key=27);
        setfillstyle(0,0);bar(5,225,635,255);putimage(5,225,miesto^,normalput);
        if key=13 then begin
         assign(strpom,ss^+'txt.dtx');
         rewrite(strpom);reset(strsu);
         new(txt);
         while not(eof(strsu)) do begin
          read(strsu,txt^);
          if filepos(strsu)<>no+zac+1 then write(strpom,txt^);
         end;
         close(strsu);close(strpom);dispose(txt);
         erase(strsu);rename(strpom,ss^+naz+'.dtx');
         assign(strsu,ss^+naz+'.dtx');
         setfillstyle(0,0);bar(162,113,598,424);
         st:=no;no:=no-1;
         goto zaciatok;
        end;
       end;
  end;
 until key=323{F9};
 for i:=0 to 24 do dispose(tt[i]);
 setfillstyle(0,0);bar(160,100,600,430);
 deltabalt;
end;

procedure editvlak;    {Editovanie vlakov}
label zaciatok;
var zac,kon,pocp:word;
    st,no,key:integer;
    svlakp:file of vlakk;
    r:real;

 procedure riadok(ind,farba:word);
  var i:byte;
      s:string;
  begin
   setcolor(farba);settextjustify(RightText,TopText);settextstyle(2,0,4);
   seek(svlak,ind);read(svlak,vlak);
   outtextxy(42,145+(ind-zac)*11,sti(vlak.cv1,5,0));
   outtextxy(85,145+(ind-zac)*11,sti(vlak.cv2,5,0));
   outtextxy(115,145+(ind-zac)*11,sti(vlak.mz,4,0));
   outtextxy(148,145+(ind-zac)*11,sti(vlak.mo,4,0));
   outtextxy(178,145+(ind-zac)*11,sti(vlak.casz,4,0));
   outtextxy(201,145+(ind-zac)*11,sti(vlak.vm,4,0));
   outtextxy(226,145+(ind-zac)*11,sti(vlak.dl*10,4,0));
   outtextxy(244,145+(ind-zac)*11,chr(vlak.sm+216));
   outtextxy(288,145+(ind-zac)*11,sti(vlak.clo,5,0));
   settextjustify(LeftText,TopText);
   setcolor(9);outtextxy(44,146+(ind-zac)*11,'ฏ');outtextxy(117,146+(ind-zac)*11,'ฏ');
   s:='';setcolor(farba);
   for i:=1 to mstan do
    if vlak.stm[i]>0 then begin
     s:=s+sti(vlak.stm[i],4,0)+'/';
     if vlak.stcp[i]=0 then s1:='๙' else s1:=sti(vlak.stcp[i],5,0)+'-';
     s:=s+s1+sti(vlak.stco[i],5,0)+',';
    end;
   if length(s)>55 then begin
    delete(s,52,length(s)-51);s:=s+'...';
   end;
   outtextxy(292,145+(ind-zac)*11,s);
   settextstyle(0,0,1);settextjustify(LeftText,TopText);
  end;

 procedure pohyb;
  begin
   riadok(st+zac,11);
   riadok(no+zac,14);
  end;

 procedure tabulka;
 var i:byte;
  begin
   setfillstyle(1,1);bar(40,200,600,323);
   setcolor(9);rectangle(40,200,600,323);line(193,200,193,323);
   rectangle(198,205,595,244);line(198,219,595,219);line(198,232,595,232);
   for i:=1 to 10 do line(221+i*34,205,221+i*34,244);
   settextjustify(LeftText,TopText);
   setcolor(14);setfillstyle(1,9);settextstyle(2,0,4);
   outtextxy(45,205,'Cislo vlaku    :');
   outtextxy(45,218,'Precislovanie  :');
   outtextxy(45,231,'Cas zjavenia   :');
   outtextxy(45,243,'Miesto zjavenia:');
   outtextxy(45,256,'Miesto odchodu :');
   outtextxy(45,269,'Max. rychlost  :');
   outtextxy(45,282,'Dlzka vlaku/10 :');
   outtextxy(45,295,'Smer vlaku     :');
   outtextxy(45,308,'Cislo Lv       :');
   outtextxy(202,205,'Cis. zst.');
   outtextxy(202,218,'C p[min] ');
   outtextxy(202,231,'C o[min] ');
  end;

 procedure tabulka1;
 var i:byte;
  begin
   setfillstyle(1,1);bar(40,200,600,323);
   setcolor(9);rectangle(40,200,600,323);line(193,200,193,323);
   rectangle(198,205,595,244);line(198,219,595,219);line(198,232,595,232);
   for i:=1 to 10 do line(221+i*34,205,221+i*34,244);
   settextjustify(LeftText,TopText);
   setcolor(14);setfillstyle(1,9);settextstyle(2,0,4);
   outtextxy(45,205,'Cislo 1.vlaku  :');
   outtextxy(45,218,'Precis. 1.vlaku:');
   outtextxy(45,231,'Cas zj. 1.vlaku:');
   outtextxy(45,243,'Miesto zjavenia:');
   outtextxy(45,256,'Miesto odchodu :');
   outtextxy(45,269,'Max. rychlost  :');
   outtextxy(45,282,'Dlzka vlaku/10 :');
   outtextxy(45,295,'Smer vlaku     :');
   outtextxy(45,308,'Cislo Lv       :');
   outtextxy(202,205,'Cis. zst.');
   outtextxy(202,218,'C p[min] ');
   outtextxy(202,231,'C o[min] ');
   setcolor(13);
   outtextxy(202,243,'Perioda zj.    :');
   outtextxy(202,256,'Cas posledneho :');
  end;

 procedure tabulka2;
 var i:byte;
  begin
   setfillstyle(1,1);bar(40,200,600,323);
   setcolor(9);rectangle(40,200,600,323);line(193,200,193,323);
   rectangle(198,205,595,244);line(198,219,595,219);line(198,232,595,232);
   for i:=1 to 10 do line(221+i*34,205,221+i*34,244);
   settextjustify(LeftText,TopText);
   setcolor(14);setfillstyle(1,9);settextstyle(2,0,4);
   outtextxy(45,205,'Cislo 1.vlaku  :');
   outtextxy(45,218,'Cis.posl. vlaku:');
   outtextxy(45,231,'Par/Nepar (0/1):');
  end;

 function cst(sta:word):char;
 begin
  case sta of
   1009,1072:cst:='A';
   1142:cst:='B';
   1158:cst:='C';
   1248:cst:='D';
   1385,1448:cst:='E';
   658:cst:='F';
   366:cst:='G';
   503:cst:='H';
   691:cst:='I';
   771,834:cst:='J';
   801,864:cst:='K';
   1263:cst:='L';
   1583:cst:='M';
   1607:cst:='N';
  end;
 end;

begin
 zac:=0;no:=0;st:=0;
 zaciatok:
 setfillstyle(0,0);bar(10,120,630,475);
 setcolor(14);rectangle(10,464,630,475);rectangle(10,120,630,455);
 setcolor(6);line(11,132,629,132);line(11,144,629,144);
 line(87,132,87,454);line(150,132,150,454);line(180,132,180,454);
 line(203,132,203,454);line(228,132,228,454);line(246,132,246,454);
 line(290,132,290,454);
 settextjustify(CenterText,TopText);setcolor(10);
 reset(svlak);kon:=filesize(svlak);
 outtextxy(320,123,'Editovanie vlakov v UnIsiM-e. Vlakov '+sti(kon,3,0));
 settextstyle(2,0,4);setcolor(14);
 outtextxy(30,131,'Cv1');outtextxy(75,131,'Cv2');
 outtextxy(105,131,'Mz');outtextxy(138,131,'Mo');outtextxy(164,131,'CasZ');
 outtextxy(192,131,'Vm');outtextxy(217,131,'Dl');outtextxy(239,131,'Sm');
 outtextxy(268,131,'cLV');outtextxy(400,131,'Gvd');
 settextjustify(LeftText,TopText);
 setcolor(15);
 outtextxy(18,463,'F4-Sk.DEL  F5-Pridaj  F6-Edituj  F7-Generuj  F8-Zmaz  F9-Ukonc edit.   F10-text');
 settextstyle(0,0,1);setcolor(9);
 ca:=false;i:=0;
 if kon>0 then begin
  if kon-zac-1<27 then begin
   pocp:=kon-zac-1;
  end else pocp:=27;
  for i:=0 to pocp do riadok(i+zac,11);
  riadok(no+zac,14);
 end;
 repeat;kbd(key);
  case key of
   329:{pgUP}begin if zac<27 then zac:=0 else dec(zac,27);
              no:=0;st:=0;goto zaciatok;end;
   337:{pgDN}begin if kon-zac>27 then inc(zac,27);
              no:=0;st:=0;goto zaciatok;end;
   336:{}begin st:=no;no:=no+1;if no=(pocp+1) then no:=0;pohyb;end;
   328:{}begin st:=no;no:=no-1;if no=-1 then no:=pocp;pohyb;end;
   318:{F4-Sk.del}begin
        tabulka2;
        with vlak2 do begin
         vondnu(45,205,1,15,14,6,'Cislo 1.vlaku  :','',r);cv1:=trunc(r);
         vondnu(45,218,1,15,14,6,'Cis.posl. vlaku:','',r);cv2:=trunc(r);
         vondnu(45,231,1,15,14,6,'Par/Nepar (0/1):','',r);sm:=trunc(r);
        end;
        setfillstyle(1,4);bar(10,225,630,255);
        setlinestyle(0,0,1);setcolor(14);
        rectangle(12,227,628,252);setcolor(10);
        settextjustify(CenterText,TopText);
        with vlak2 do
        outtextxy(320,237,'??? Naozaj ZMAZAT ??? (Ano-Enter / Nie-Esc)  Vlaky od '+sti(cv1,5,0)+'do '+sti(cv2,5,0)+' typ-'+
         sti(sm,1,0)+' ?');
        settextjustify(LeftText,TopText);
        repeat;kbd(key);until (key=13)or(key=27);
        if key=13 then begin
         assign(svlakp,ss^+naz+'.gv_');
         rewrite(svlakp);reset(svlak);
         while not(eof(svlak)) do begin
          read(svlak,vlak);
          if (vlak.cv1>=vlak2.cv1)and
             (vlak.cv1<=vlak2.cv2)and
             (vlak.cv1 mod 2 =vlak2.sm) then begin end
             else write(svlakp,vlak);
         end;
         close(svlak);close(svlakp);
         erase(svlak);rename(svlakp,ss^+naz+'.gvd');
         assign(svlak,ss^+naz+'.gvd');reset(svlak);
        end;
        setfillstyle(0,0);bar(10,225,630,255);settextstyle(0,0,1);
        goto zaciatok;
       end;
   319:{F5-Prid}begin
        tabulka;
        with vlak do begin
         vondnu(45,205,1,15,14,6,'Cislo vlaku    :','',r);cv1:=trunc(r);
         vondnu(45,218,1,15,14,6,'Precislovanie  :','',r);cv2:=trunc(r);
         vondnu(45,231,1,15,14,6,'Cas zjavenia   :','',r);casz:=trunc(r);
         vondnu(45,243,1,15,14,5,'Miesto zjavenia:','',r);mz:=trunc(r);
         vondnu(45,256,1,15,14,5,'Miesto odchodu :','',r);mo:=trunc(r);
         vondnu(45,269,1,15,14,3,'Max. rychlost  :','',r);vm:=trunc(r);
         vondnu(45,282,1,15,14,3,'Dlzka vlaku/10 :','',r);dl:=trunc(r);
         vondnu(45,295,1,15,14,1,'Smer vlaku     :','',r);sm:=trunc(r);
         vondnu(45,308,1,15,14,6,'Cislo Lv       :','',r);clo:=trunc(r);
         ca:=true;
         for i:=1 to 10 do begin
          if ca then begin
           vondnu(223+i*34,205,1,15,14,5,'','0',r);stm[i]:=trunc(r);
           vondnu(223+i*34,218,1,15,14,5,'','0',r);stcp[i]:=trunc(r);
           vondnu(223+i*34,231,1,15,14,5,'','0',r);stco[i]:=trunc(r);
           if stm[i]=0 then ca:=false;
          end else begin stm[i]:=0;stcp[i]:=0;stco[i]:=0;end;
         end;
        end;
        reset(svlak);seek(svlak,filesize(svlak));
        write(svlak,vlak);
        settextstyle(0,0,1);
        repeat
         reset(svlak);ok:=false;j:=0;
         for i:=0 to filesize(svlak)-2 do begin
          seek(svlak,i);read(svlak,vlak);read(svlak,vlak2);
          if vlak.casz>vlak2.casz then begin
           ok:=true;seek(svlak,i);inc(j);
           write(svlak,vlak2);write(svlak,vlak);
          end;
         end;
         setfillstyle(1,10);setcolor(0);
         bar(200,269,420,282);
         outtextxy(203,269,'Usporaduvam vlaky. Este '+sti(j,3,0));
        until not ok;
        settextstyle(0,0,1);
        goto zaciatok;
       end;
   320:{F6-Edit}begin
        reset(svlak);seek(svlak,no+zac);
        read(svlak,vlak);tabulka;
        with vlak do begin
         vondnu(45,205,1,15,14,6,'Cislo vlaku    :',sti(cv1,5,0),r);cv1:=trunc(r);
         vondnu(45,218,1,15,14,6,'Precislovanie  :',sti(cv2,5,0),r);cv2:=trunc(r);
         vondnu(45,231,1,15,14,6,'Cas zjavenia   :',sti(casz,6,0),r);casz:=trunc(r);
         vondnu(45,243,1,15,14,5,'Miesto zjavenia:',sti(mz,5,0),r);mz:=trunc(r);
         vondnu(45,256,1,15,14,5,'Miesto odchodu :',sti(mo,5,0),r);mo:=trunc(r);
         vondnu(45,269,1,15,14,3,'Max. rychlost  :',sti(vm,3,0),r);vm:=trunc(r);
         vondnu(45,282,1,15,14,3,'Dlzka vlaku/10 :',sti(dl,3,0),r);dl:=trunc(r);
         vondnu(45,295,1,15,14,1,'Smer vlaku     :',sti(sm,1,0),r);sm:=trunc(r);
         vondnu(45,308,1,15,14,6,'Cislo Lv       :',sti(clo,5,0),r);clo:=trunc(r);
         ca:=true;
         for i:=1 to 10 do begin
          if ca then begin
           vondnu(223+i*34,205,1,15,14,5,'',sti(stm[i],5,0),r);stm[i]:=trunc(r);
           vondnu(223+i*34,218,1,15,14,5,'',sti(stcp[i],5,0),r);stcp[i]:=trunc(r);
           vondnu(223+i*34,231,1,15,14,5,'',sti(stco[i],5,0),r);stco[i]:=trunc(r);
           if stm[i]=0 then ca:=false;
          end else begin stm[i]:=0;stcp[i]:=0;stco[i]:=0;end;
         end;
        end;
        seek(svlak,filepos(svlak)-1);
        write(svlak,vlak);
        settextstyle(0,0,1);
        repeat
         reset(svlak);ok:=false;j:=0;
         for i:=0 to filesize(svlak)-2 do begin
          seek(svlak,i);read(svlak,vlak);read(svlak,vlak2);
          if vlak.casz>vlak2.casz then begin
           ok:=true;seek(svlak,i);inc(j);
           write(svlak,vlak2);write(svlak,vlak);
          end;
         end;
         setfillstyle(1,2);setcolor(0);
         bar(200,269,420,282);
         outtextxy(203,269,'Usporaduvam vlaky. Este '+sti(j,3,0));
        until not ok;
        settextstyle(0,0,1);
        goto zaciatok;
       end;
   321:{F7-Gen}begin
        tabulka1;
        with vlak do begin
         vondnu(45,205,1,15,14,6,'Cislo 1.vlaku  :','',r);cv1:=trunc(r);
         vondnu(45,218,1,15,14,6,'Precis. 1.vlaku:','',r);cv2:=trunc(r);
         vondnu(45,231,1,15,14,6,'Cas zj. 1.vlaku:','',r);casz:=trunc(r);
         vondnu(45,243,1,15,14,5,'Miesto zjavenia:','',r);mz:=trunc(r);
         vondnu(45,256,1,15,14,5,'Miesto odchodu :','',r);mo:=trunc(r);
         vondnu(45,269,1,15,14,3,'Max. rychlost  :','',r);vm:=trunc(r);
         vondnu(45,282,1,15,14,3,'Dlzka vlaku/10 :','',r);dl:=trunc(r);
         vondnu(45,295,1,15,14,1,'Smer vlaku     :','',r);sm:=trunc(r);
         vondnu(45,308,1,15,14,6,'Cislo Lv       :','',r);clo:=trunc(r);
         ca:=true;
         for i:=1 to 10 do begin
          if ca then begin
           vondnu(223+i*34,205,1,15,14,5,'','0',r);stm[i]:=trunc(r);
           vondnu(223+i*34,218,1,15,14,5,'','0',r);stcp[i]:=trunc(r);
           vondnu(223+i*34,231,1,15,14,5,'','0',r);stco[i]:=trunc(r);
           if stm[i]=0 then ca:=false;
          end else begin stm[i]:=0;stcp[i]:=0;stco[i]:=0;end;
         end;
         vondnu(202,243,1,14,13,5,'Perioda zj.    :','',r);per:=trunc(r);
         vondnu(202,256,1,14,13,5,'Cas posledneho :','',r);casp:=trunc(r);
        end;
        setfillstyle(1,4);setcolor(14);
        bar(200,269,420,282);
        outtextxy(203,269,'Naozaj chces generovat vlaky ? {a/n}');
        ch:=readkey;ch:=upcase(ch);
        case ch of
        'A':begin
             v1:=(casp-vlak.casz) div per;v2:=1;
             setfillstyle(1,9);setcolor(14);
             bar(200,269,420,282);
             outtextxy(203,269,'Generujem '+sti(v1,3,0)+' vlakov.');
             setfillstyle(1,12);bar(337,271,417,280);
             setfillstyle(1,11);
             reset(svlak);seek(svlak,filesize(svlak));
             repeat
              write(svlak,vlak);
              with vlak do begin
               casz:=casz+per;
               cv1:=cv1+2;cv2:=cv2+2;
               if clo>0 then clo:=clo+2;
               for i:=1 to 10 do if stm[i]>0 then begin
                if stcp[i]=0 then stcp[i]:=0 else stcp[i]:=stcp[i]+per;
                stco[i]:=stco[i]+per;
               end;
              end;
              mx:=(v2*79) div v1;
              bar(337,271,337+mx,280);delay(50);
              inc(v2);
             until vlak.casz>=casp;
             close(svlak);
             setfillstyle(1,2);setcolor(0);
             bar(200,269,420,282);
             outtextxy(203,269,'Usporaduvam vlaky.');
             repeat
              reset(svlak);ok:=false;j:=0;
              for i:=0 to filesize(svlak)-2 do begin
               seek(svlak,i);read(svlak,vlak);read(svlak,vlak2);
               if vlak.casz>vlak2.casz then begin
                ok:=true;seek(svlak,i);inc(j);
                write(svlak,vlak2);write(svlak,vlak);
               end;
              end;
              setfillstyle(1,2);setcolor(0);
              bar(200,269,420,282);
              outtextxy(203,269,'Usporaduvam vlaky. Este '+sti(j,3,0));
             until not ok;
             setfillstyle(1,10);setcolor(0);
             bar(200,269,500,282);
             outtextxy(203,269,'Generovanie uspesne ukoncene ! Enter...');
            end;
        'N':begin
             setfillstyle(1,0);setcolor(7);
             bar(200,269,420,282);
             outtextxy(203,269,'Generovanie zamietnute ! Enter...');
            end;
        end;
        readln;
        settextstyle(0,0,1);
        goto zaciatok;
       end;
   322:{F8-Maz}begin
        setfillstyle(1,4);bar(10,225,630,255);
        setlinestyle(0,0,1);setcolor(14);
        rectangle(12,227,628,252);setcolor(10);
        settextjustify(CenterText,TopText);
        reset(svlak);seek(svlak,no+zac);
        read(svlak,vlak);
        outtextxy(320,237,'??? Naozaj ZMAZAT ??? (Ano-Enter / Nie-Esc)  Vlak '+sti(vlak.cv1,3,0)+' ?');
        settextjustify(LeftText,TopText);
        repeat;kbd(key);until (key=13)or(key=27);
        if key=13 then begin
         assign(svlakp,ss^+naz+'.gv_');
         rewrite(svlakp);reset(svlak);
         while not(eof(svlak)) do begin
          read(svlak,vlak);
          if filepos(svlak)<>no+zac+1 then write(svlakp,vlak);
         end;
         close(svlak);close(svlakp);
         erase(svlak);
         rename(svlakp,ss^+naz+'.gvd');
         assign(svlak,ss^+naz+'.gvd');reset(svlak);
        end;
        setfillstyle(0,0);bar(10,225,630,255);
        goto zaciatok;
       end;
   324:{F10-text}begin
        setfillstyle(1,1);bar(10,225,630,255);
        setcolor(14);
        rectangle(12,227,628,252);setcolor(10);
        reset(svlak);
        outtextxy(20,235,'Vypisujem do textoveho suboru.');
        rectangle(300,232,600,247);k:=filesize(svlak);ook:=1;
        rewrite(pomoc);setfillstyle(1,14);
        while not(eof(svlak)) do begin
         read(svlak,vlak);
         s:='x'+sti1(vlak.cv1,5,0)+' ';
         s1:=sti(vlak.casz div 60,2,0);
         case length(s1) of
          0:s1:='00';
          1:s1:='0'+s1;
         end;
         s:=s+s1;
         s1:=sti(vlak.casz mod 60,2,0);
         case length(s1) of
          0:s1:='00';
          1:s1:='0'+s1;
         end;
         s:=s+s1;
         s1:=typ_vlaku(vlak.cv1);
         case length(s1) of
          1:s1:=s1+'  ';
          2:s1:=s1+' ';
         end;
         s:=s+' '+s1;
         with vlak do begin
          if typ_vlaku(cv1)='Os' then s:=s+'z' else s:=s+' ';
          s:=s+cst(mz)+' '+cst(mo)+' ';
          case vm of
           60:s1:='17';
           70:s1:='19';
           80:s1:='22';
           90:s1:='25';
           100:s1:='28';
           120:s1:='33';
           140:s1:='39';
           160:s1:='44';
          end;
          s:=s+s1+'   ';
          s1:=sti(dl,2,0);if dl<10 then s1:=' '+s1;
          s:=s+s1+'    ';
          if clo>0 then s:=s+sti1(clo,5,0)+'   ' else s:=s+'        ';
          if cv1<>cv2 then s:=s+sti1(cv2,5,0) else s:=s+'     ';
          for i:=1 to mstan do
           if vlak.stm[i]>0 then begin
            if stcp[i]>0 then begin
             if i=1 then begin
              if stcp[1]<casz then s1:=sti(stcp[1]+1440-casz,2,0)
              else s1:=sti(stcp[1]-casz,2,0);end
             else begin
              if stcp[i]<stco[i-1] then s1:=sti(1440+stcp[i]-stco[i-1],2,0)
              else s1:=sti(stcp[i]-stco[i-1],2,0);
             end;
             case length(s1) of
              0:s1:='00';
              1:s1:='0'+s1;
             end;
             s:=s+cst(stm[i])+s1;
             if stco[i]<stcp[i] then s1:=sti(1440+stco[i]-stcp[i],2,0)
              else s1:=sti(stco[i]-stcp[i],2,0);
             case length(s1) of
              0:s:=s+'00';
              1:s:=s+'0'+s1;
              2:s:=s+s1;
             end;
            end else begin
             if i=1 then begin
              if stco[1]<casz then s1:=sti(stco[1]+1440-casz,2,0)
              else s1:=sti(stco[1]-casz,2,0)
             end
             else begin
              if stco[i]<stco[i-1] then s1:=sti(1440+stco[i]-stco[i-1],2,0)
              else s1:=sti(stco[i]-stco[i-1],2,0);
             end;
             case length(s1) of
              0:s1:='00';
              1:s1:='0'+s1;
             end;
             s:=s+cst(stm[i])+s1+'00';
            end;
           end;
          for i:=length(s) to 101 do s:=s+' ';
          s:=s+'x';
         end;
         writeln(pomoc,s);
         mx:=(ook*296) div k;
         bar(301,233,301+mx,246);delay(10);
         inc(ook);
        end;
        delay(500);
        close(pomoc);new(ss);getdir(0,ss^);
        assign(von1,'c:\Tp7\grafikon\data\Gvd_03.dat');
        erase(von1);
        rename(pomoc,'c:\Tp7\grafikon\data\Gvd_03.dat');
        assign(pomoc,ss^+'\pomoc.txt');rewrite(pomoc);close(pomoc);
        setfillstyle(0,0);bar(10,225,630,255);
        goto zaciatok;
       end;

  end;
 until key=323{F9};
 setfillstyle(0,0);bar(10,120,630,475);
end;

procedure editzav;
label zaciatok;
var zac,kon,pocp:word;
    st,no,key:integer;
    r:real;

 procedure riadok(ind,farba:word);
  var i:byte;
      s:string;
  begin
   setcolor(farba);settextjustify(RightText,TopText);settextstyle(2,0,4);
   reset(vlc);
   if ind<filesize(vlc) then begin
    seek(vlc,ind);read(vlc,vlakc);
    outtextxy(42,145+(ind-zac)*11,sti(vlakc.zc,4,0));
    outtextxy(85,145+(ind-zac)*11,sti(vlakc.kc,4,0));
    outtextxy(105,145+(ind-zac)*11,sti(vlakc.ch,2,0));
    case vlakc.ch of
     1:setfillstyle(1,15);
     2:setfillstyle(1,2);
    end;
    bar(115,149+(ind-zac)*11,125,154+(ind-zac)*11);
    settextjustify(LeftText,TopText);
    setcolor(9);outtextxy(44,146+(ind-zac)*11,'ฏ');
    s:='';setcolor(farba);
    for i:=1 to 20 do s:=s+prvct(vlakc.vyh[i]);
    outtextxy(142,145+(ind-zac)*11,s);
   end;
   settextstyle(0,0,1);settextjustify(LeftText,TopText);
  end;

 procedure pohyb;
  begin
   riadok(st+zac,11);
   riadok(no+zac,14);
  end;

 procedure tabulka(ind:word);
  var i,fx,fy:word;
      inn,gx,gy:integer;
  begin
   setfillstyle(1,1);bar(40,200,600,325);
   setcolor(9);rectangle(40,200,600,325);line(200,200,200,325);
   settextjustify(LeftText,TopText);
   setcolor(14);setfillstyle(1,9);settextstyle(2,0,4);
   reset(vlc);
   if ind<filesize(vlc) then begin
    seek(vlc,ind);read(vlc,vlakc);
    outtextxy(45,205,'Typ vlak. c. : '+sti(vlakc.ch,2,0));
    outtextxy(45,218,'Od navestidla: '+sti(vlakc.zc,4,0));
    outtextxy(45,231,'Na kolaj     : '+sti(vlakc.kc,4,0));
    case vlakc.ch of
     1:setfillstyle(1,15);
     2:setfillstyle(1,2);
    end;
    bar(165,205,190,215);s:='';
    for i:=1 to 20 do s:=s+prvct(vlakc.vyh[i]);
    outtextxy(45,243,'Vyh.: '+s);
    setfillstyle(0,0);setcolor(9);
    bar(205,205,595,320);rectangle(205,205,595,320);
    fx:=390 div krokx;fy:=115 div kroky;
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
       {krstav(charusk.xs);
       if charusk.ch[2]='T'then prvky(charusk.xs,pozicia[charusk.xs]^.stav);}
      end;
     end;
    end;
    case pozicia[vlakc.zc]^.sm and 3 of
     1:gx:=-3;
     2:gx:=3-fx;
    end;
    if vlakc.zc<vlakc.kc then inn:=1 else inn:=-1;
    gy:=(abs(vlakc.zc-vlakc.kc) div xmax)*inn;
    gy:=(fy div 2)-gy;

   end;
  end;

begin
 zac:=0;no:=0;st:=0;
 zaciatok:
 setfillstyle(0,0);bar(10,120,630,475);
 setcolor(14);rectangle(10,464,630,475);rectangle(10,120,630,455);
 setcolor(6);line(11,132,629,132);line(11,144,629,144);
 line(87,132,87,454);line(138,132,138,454);
 settextjustify(CenterText,TopText);setcolor(10);
 reset(vlc);kon:=filesize(vlc);
 outtextxy(320,123,'Editovanie z v. tabu–ky v UnIsiM-e. Ciest - '+sti(kon,3,0));
 settextstyle(2,0,4);setcolor(14);
 outtextxy(30,131,'Od');outtextxy(75,131,'Na');
 outtextxy(105,131,'Typ');outtextxy(250,131,'V์hybky');
 settextjustify(LeftText,TopText);
 setcolor(15);
 outtextxy(18,463,'F4-Sk.DEL  F5-Pridaj  F6-Edituj  F7-Generuj  F8-Zmaz  F9-Ukonc edit.   F10-text');
 settextstyle(0,0,1);setcolor(9);
 ca:=false;i:=0;
 if kon>0 then begin
  if kon-zac-1<27 then begin
   pocp:=kon-zac-1;
  end else pocp:=27;
  for i:=0 to pocp do riadok(i+zac,11);
  riadok(no+zac,14);
 end;
 repeat;kbd(key);
  case key of
   329:{pgUP}begin if zac<27 then zac:=0 else dec(zac,27);
              no:=0;st:=0;goto zaciatok;end;
   337:{pgDN}begin if kon-zac>27 then inc(zac,27);
              no:=0;st:=0;goto zaciatok;end;
   336:{}begin st:=no;no:=no+1;if no=(pocp+1) then no:=0;pohyb;end;
   328:{}begin st:=no;no:=no-1;if no=-1 then no:=pocp;pohyb;end;
   13:begin {Enter-zobraz cestu}
       tabulka(no+zac);
       readln;
       setfillstyle(0,0);bar(10,225,630,255);
       goto zaciatok;
      end;
  end;
 until key=323{F9};
 setfillstyle(0,0);bar(10,120,630,475);
end;

procedure mazcis;
begin
setfillstyle(0,0);bar(11,436,149,461);
end;

procedure dlkr;
var dlhe:word;
    r:real;
begin
mazcis;dlhe:=0;setcolor(10);
outtextxy(14,438,'Dlhe:');
outtextxy(14,450,'Kratke x=');outtextxy(110,450,'y=');
dnu(60,438,8,15,5,'',r);dlhe:=trunc(r);
setcolor(15);
outtextxy(86,450,sti(sux(dlhe),2,0));
outtextxy(126,450,sti(suy(dlhe),2,0));
end;

procedure krdl;
var krx,kry:word;
    r:real;
begin
mazcis;setcolor(10);
outtextxy(14,438,'Dlhe:');
outtextxy(14,450,'Kratke x=');outtextxy(110,450,'y=');
dnu(86,450,8,15,2,'',r);krx:=trunc(r);
dnu(126,450,8,15,2,'',r);kry:=trunc(r);
setcolor(15);
outtextxy(60,438,sti(cis(krx,kry),5,0));
end;


{--- Zaciatok Hlavneho Programu ---}
begin
igraph;imenu('prevod');
new(ss);
getdir(0,ss^);
ss^:=ss^+'\trschemy\';
setbkcolor(0);
v1:=0;
setcolor(15);rectangle(0,0,638,478);
setcolor(10);rectangle(1,1,639,479);
setcolor(14);rectangle(10,435,150,462);
{logo(420,440);}
naz:='MALA';
settextstyle(0,0,1);
setfillstyle(0,0);bar(10,100,150,112);
setcolor(10);rectangle(10,100,150,112);
settextjustify(CenterText,TopText);
setcolor(14);outtextxy(80,102,'Subor :'+naz);
settextjustify(LeftText,TopText);
repeat
 vmenu(1,3,10,10,1,14,6,v1);
 case v1 of
  1:begin
     repeat
      vmenu(4,6,90,15,1,14,6,v2);
      case v2 of
       4:begin
          vmenu(7,8,180,20,1,15,6,v3);
          case v3 of
           7:chutotxt;
           8:txttochu;
          end;
          nullmenu(7,8,180,20);
         end;
       5:begin
          vmenu(9,10,180,40,1,15,6,v3);
          case v3 of
           09:vlatotxt;
           10:txttovla;
          end;
          nullmenu(09,10,180,40);
         end;
       6:begin
          vmenu(17,19,180,50,1,15,6,v3);
          case v3 of
           17:dlkr;
           18:krdl;
           19:mazcis;
          end;
          nullmenu(17,19,180,50);
         end;
      end;
     until v2=255;
     nullmenu(4,6,90,15);
    end;
  2:begin
     repeat
      vmenu(11,12,90,25,1,14,6,v2);
      case v2 of
       11:nazov;
       12:begin
           vmenu(13,16,195,50,1,15,6,v3);
           case v3 of
            13:begin nullmenu(15,18,195,50);end;
            14:begin nullmenu(15,18,195,50);edittxt;end;
            15:begin nullmenu(15,18,195,50);editzav;end;
            16:begin nullmenu(15,18,195,50);editvlak;end;
           end;
          end;
      end;
     until v2=255;
     nullmenu(11,12,90,25);
    end;
 end;
until (v1=3)or(v1=255);
closegraph;
writeln('            ษอออออออออออออออออออออออออออออหออออออออหออออออออป');
writeln('            บ (c) Ing. Peter Vojtech 2004 บ UnIsiM บ (R) Vฆ บ');
writeln('            ศอออออออออออออออออออออออออออออสออออออออสออออออออผ');
delay(500);
dispose(ss);
end.