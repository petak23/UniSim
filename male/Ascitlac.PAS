program cispok;
uses crt,graph,menus;
var i:longint;

begin
 igraph;
 cleardevice;
 setbkcolor(0);settextstyle(2,0,4);
 for i:=33 to 64 do   outtextxy(10,13*(i-32)+20,chr(i)+' - '+sti(i,3,0));
 for i:=65 to 96 do   outtextxy(100,13*(i-64)+20,chr(i)+' - '+sti(i,3,0));
 for i:=97 to 128 do  outtextxy(190,13*(i-96)+20,chr(i)+' - '+sti(i,3,0));
 for i:=129 to 160 do outtextxy(280,13*(i-128)+20,chr(i)+' - '+sti(i,3,0));
 for i:=161 to 192 do outtextxy(370,13*(i-160)+20,chr(i)+' - '+sti(i,3,0));
 for i:=193 to 224 do outtextxy(460,13*(i-192)+20,chr(i)+' - '+sti(i,3,0));
 for i:=225 to 254 do outtextxy(550,13*(i-224)+20,chr(i)+' - '+sti(i,3,0));
 readln;
 closegraph;
end.
