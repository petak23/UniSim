Unit DswMouse;
Interface
Const InstalM: Boolean = False;  Dvojklik:Boolean = False;
      PocTlac: Byte    = 0;      PoslTlac:Byte    = 0;
      CasStlac:LongInt = 0;      CasPauza:Byte    = 5;
      Zap:     Boolean = False;  Tlac:Byte        = 0;
Var Casovac:LongInt Absolute $0:$046C;  { Interny casovac pre INTEL 80x86 }
    MX,MY,mouseon:Word;                 { S£radnice mysi                  }

Procedure MouseInst;                    { Zaktivuje driver pre mys v pam„ti }
Procedure MouseZap;                { Zapne mysac¡ kurzor v aktu lnom rezime }
Procedure MouseVyp;                { Vypne mysac¡ kutzor v aktu lnom rezime }
Procedure GetMousePos(Var X,Y:Word);          { Vr ti okamzit£ poz¡ciu mysi }
Procedure SetMousePos(X,Y:Word);         { Nastav¡ mys na stanoven£ poz¡ciu }
Procedure SetX(Xmin,Xmax:Word);         { Nastav¡ rozsah horizont. s£radn¡c }
Procedure SetY(Ymin,Ymax:Word);         { Nastav¡ rozsah vertik l. s£radn¡c }
Procedure MouseCitl(Kx,Ky:Word);                { Nastav¡ mysaciu citlivost }
Function Tlacitka(Var Dvojklik:Boolean):Word;     { Zist¡ stlacen‚ tlac¡tka }

Implementation
Uses Dos,Crt;
Var Regs:Registers;

Procedure MouseInst;
Begin
  Regs.AX:=0;Intr($33,Regs);PocTlac:=Regs.BX;
  If Regs.AX>0 Then InstalM:=True;
End;


Procedure MouseZap;
Begin
 If (InstalM) and (Not Zap) Then
 Begin Regs.AX:=1; Intr($33,Regs); Zap:=True; End;
End;

Procedure MouseVyp;
Begin
 If (InstalM) and (Zap) Then
 Begin Regs.AX:=2; Intr($33,Regs); Zap:=False; End;
End;

Procedure GetMousePos(Var X,Y:Word);
Begin
 Regs.AX:=3; Intr($33,Regs); X:=Regs.CX; Y:=Regs.DX;
End;

Procedure SetMousePos(X,Y:Word);
Begin
 If InstalM Then Begin Regs.AX:=4; Regs.CX:=X; Regs.DX:=Y; Intr($33,Regs);
End; End;

Procedure SetX(Xmin,Xmax:Word);
Begin
 Regs.AX:=7; Regs.CX:=Xmin; Regs.DX:=Xmax; Intr($33,Regs);
End;

Procedure SetY(Ymin,Ymax:Word);
Begin
 Regs.AX:=8; Regs.CX:=Ymin; Regs.DX:=Ymax; Intr($33,Regs);
End;

Procedure MouseCitl(Kx,Ky:Word);
Begin
 Regs.AX:=15; Regs.CX:=Kx; Regs.DX:=Ky; Intr($33,Regs);
End;

Function Tlacitka(Var Dvojklik:Boolean):Word;
Var Buttons:Byte;
Begin
 If InstalM Then Begin
  Regs.AX:=3; Intr($33,Regs); Buttons:=Regs.BX;
  Tlacitka:=Buttons; Dvojklik:=False;
  Case Buttons Of 1:Buttons:=0;     2:Buttons:=1;
                  4:Buttons:=2;  Else Buttons:=3; End;
  If Buttons<3 Then Begin
   Regs.AX:=6; Regs.BX:=Buttons; Intr($33,Regs);
   If (Buttons=PoslTlac) And (Regs.BX>0) And (Casovac<CasStlac+CasPauza)
    Then Dvojklik:=True
    Else Begin CasStlac:=Casovac; PoslTlac:=Buttons; End;
  End;
 End Else Tlacitka:=0;
End;

End.