Unit SGraph;

interface

Const
  { Konstanty pro typ kreslen� }
  NormalPut = 0;              { P�episov�n� }
  ANDPut    = 8;              { Logick� AND }
  ORPut     = 16;             { Logick� OR }
  XORPut    = 24;             { Logick� XOR }

{ Hlavi�ky exportovan�ch procedur }
procedure Line1( X1, Y1, X2, Y2: word);  { Kreslen� ��ry }
procedure InitGraph1;                    { Inicializace grafiky }
procedure CloseGraph1;                   { Obnoven� p�vodn�ho videom�du }
procedure SetColor1( Color: byte);       { Nastaven� barvy pro kreslen� �ar }
procedure SetWriteMode( Mode: byte);    { Volba druhu kombinace kreslen�ch a
                                          ji� zobrazen�ch dat }

implementation

Const
  ActColor: byte = 15;          { Prom�n� slou��c� k ulo�en� aktu�ln� barvy
                                  Standardn� je nastavena b�l� barva }
  WriteMode: byte = 0;          { Zapisovac� re�im 0 = p�episov�n�
                                                   8 = AND
                                                  16 = OR
                                                  24 = XOR          }
  BytesPerRow = 80;             { Po�et byte v jedn� ��dce (640/8 = 80) }
  IsGraphicsMode: boolean
                  = false;      { Indikace zda jsme v grafice }
  PixelsPerByte      = 3;            { Po�et bod� v jednom bite udan�
                                       v bitov�ch posuvech }
  ModMask            = 7;            { Bitov� maska pro z�sk�n� MOD 8 (zbytku
                                       po d�len� osmi }
  BMask              = 128;          { Bitov� maska pro kreslen� bodu }
  VRAMSegment        = $a000;        { Segment po��tku obrazov� pam�ti }
  GraphicsAR         = $3ce;         { Port Graphics 1 and 2 Address Register }
  ModeRegister       = 5;            { Index registru zapisovac�ho m�du }
  DataRotate         = 3;            { Index registru pro rotaci a kombinaci dat }
  BitMask            = 8;            { Index registru bitov� masky }

var
   OldVMode: byte;                   { Prom�n� slou��c� pro uchov�n� ��sla
                                       zobrazovac�ho re�imu }
   delta: word;                      { Pomocn� prom�n� pro uchov�n� 2dx nebo 2dy}


procedure Line1( X1, Y1, X2, Y2: word); assembler;
{ Kresl� ��ru z X1, Y1 do X2, Y2 }
const
     neg_dx     = 2;            { Znam�nko od delta x }
     neg_dy     = 4;            { Znam�nko od delta y }

asm
        push    BP              { Uchov�n� registr� BP }
        push    DS              {                 a DS }

        mov     AX, X1          { Na�ten� sou�adnic do registr� procesoru }
        mov     BX, Y1
        mov     CX, X2
        mov     DX, Y2

        xor     BP, BP          { Smaz�n� registru BP }
        mov     DI, CX          { Spo��t�n� hodnoty deltax }
        sub     DI, AX
        jg      @p_dx           { Je deltax kladn� ? }
        or      BP, neg_dx      { ne => ulo� znam�nko do BP }
        neg     DI              {       absolutn� hodnota DI tj. deltax }

  @p_dx:
        mov     SI, DX          { Ur�en� hodnoty deltay }
        sub     SI, BX
        jg      @p_dy           { Je deltay kladn� ? }
        or      BP, neg_dy      { ne => ulo� znam�nko do BP }
        neg     SI              {       absolutn� hodnota delaty }

  @p_dy:
        cmp     DI, SI          { Porovn�n� deltax a deltay }
        jb      @vertical_dir   { deltax > deltay <=> absolutn� hodnota sm�rnice > 1
                                                          => vertik�ln� sm�r
                                  deltax <= deltay <=> absolutn� hodnota sm�rnice <= 1
                                                          => horizont�ln� sm�r          }

  @horizontal_dir:
        test    BP, neg_dx      { Porovn�n� X1 a X2 }
        jz      @hor_init       { Je sm�r zprava doleva ? }
        xchg    AX, CX          { ne => vym�n sou�adnice po��tku a konce ��ry }
        xchg    BX, DX
        xor     BP, neg_dy      { uprav znam�nko deltay }

  @hor_init:                    { V�po�et adresy prvn�ho bodu }
        mov     CX, AX          { Do CX X1 }
        xchg    AX, BX          { BX = X1, AX = X2 }
        mov     DX, BytesPerRow        { DX = Po�et byte na jedn� ��dce (80) }
        mul     DX                     { AX:DX = Y1 * 80 }
        shr     BX, PixelsPerByte      { BX = BX div 8 }
        add     BX, AX                 { V BX je offset prvn�ho bodu ��ry }

        mov     AX, DS                 { Do ES p�esuneme DS }
        mov     ES, AX

        mov     AX, VRAMSegment        { Segment obrazov� pam�ti do DS }
        mov     DS, AX
        mov     DX, GraphicsAR            { Port adresov�ho registru grafick�ho kontroleru }
        mov     AX, ModeRegister + $0200  { Nastav� zapisovac� m�d 2 }
        out     DX, AX

        mov     AL, DataRotate            { Nastav� zp�sob kombinace dat z CPU }
        mov     AH, ES: WriteMode         { s latch-registry }
        out     DX, AX

        and     CX, ModMask             { CX = X1 and 7 }
        mov     AH, BMask               { AH = 80h, tj. nastaven je lev� pixel }
        shr     AH, CL                  { Rotace AH. Po rotaci je v AH bitov� maska bodu }

        mov     DX, BP                  { Uchov� znam�nka deltax a deltay v DX }

        mov     CX, DI                  { CX = deltax }
        inc     CX                      { CX = deltax - 1, tj. po�et bod� na ���e }
                                        { V�po�et predikce do BP: }
        shl     SI, 1                   { SI = 2*deltay }
        mov     BP, SI                  { BP = 2*deltay }
        sub     BP, DI                  { BP = 2*deltax - deltay }
        shl     DI, 1                   { DI = 2*deltax }

        mov     ES: delta, DI           { Ulo�en� hodnoty 2*deltax }

        mov     DI, BX                  { Do DI offset adresy 1. bodu }

        test    DX, neg_dy              { Ur�en� sm�ru }
        pushf                           { Uchov�n� flag� }
        mov     DX, GraphicsAR          { Nastav� index graf. kontroleru na Bit mask reg. }
        mov     AL, BitMask
        out     DX, AL
        inc     DX                      { DX = datov� port graf. kontroleru }
        popf                            { Obnov� flagy s v�sledkem testu sm�ru }
        jnz     @hor_neg_dy_init        { Rozskok, podle znam�nka sm�rnice }

  @hor_pos_dy_init:                     { Kladn� sm�rnice, y sou�adnice je zvy�ov�na }
        mov     BL, ES: ActColor        { BL = Barva ��ry }
        mov     BH, BL                  { BH = Barva ��ry }
        mov     AL, AH                  { AL = Bitov� maska prvn�ho bodu }

  @hor_pos_dy:
        cmp      BP, 0                  { Test predikce }
        jng      @hor_pos_dy_L1
        out      DX, AL                 { predikce >= 0 }
        mov      BL, BH                 { BL = Barva bodu }
        xchg     [DI], BL               { Nakresli bod }
        xor      AL, AL                 { Vynuluje st��danou masku }
        sub      BP, ES: delta          { Uprav� predikaci P = P - 2*deltax }
        add      DI, BytesPerRow        { Zv�t�en� y sou�adnice }
  @hor_pos_dy_L1:
        add      BP, SI                 { �prava predikce P = P + 2*deltay }
        ror      AH, 1                  { Zv�t�en� x sou�adnice }
        jc       @hor_pos_dy_L2         { P�es�hli jsme jeden byte ? }
        or       AL, AH                 { Uprav masku byte }
        loop     @hor_pos_dy            { Dal�� bod }
        jmp      @hor_pos_dy_lastbyte   { Do�li jsme do koncov�ho bodu }
  @hor_pos_dy_L2:
        out      DX, AL                 { Nastav� novou bitovou masku }
        mov      BL, BH
        xchg     [DI], BL               { Nakresl� body jednoho byte }
        mov      AL, AH                 { Inicializuje bitovou masku }
        inc      DI                     { Zv�t�� x sou�adnici }
        loop     @hor_pos_dy            { Byl to posledn� bod ? }
        jmp      @l_done                {        => konec kreslen� ��ry }
  @hor_pos_dy_lastbyte:
        xor      AL, AH                 { Posledn� bit je neplatn�, odstranit }
        out      DX, AL                 { Nastaven� bitov� masky }
        mov      BL, BH                 { BL = Barva ��ry }
        xchg     [DI], BL               { Nakreslen� bodu }
        jmp      @l_done                { Ukon�en� kreslen� ��ry }

  @hor_neg_dy_init:                     { Z�porn� sm�rnice, y sou�adnice je zmen�ov�na }
        mov     BL, ES: ActColor        { BL = Barva ��ry }
        mov     BH, BL                  { BH = Barva ��ry }
        mov     AL, AH                  { AL = Bitov� maska prvn�ho bodu }

  @hor_neg_dy:
        cmp      BP, 0                  { Test predikce }
        jng      @hor_neg_dy_L1
        out      DX, AL                 { predikce >= 0 }
        mov      BL, BH                 { BL = Barva bodu }
        xchg     [DI], BL               { Nakresli bod }
        xor      AL, AL                 { Vynuluje st��danou masku }
        sub      BP, ES: delta          { Uprav� predikaci P = P - 2*deltax }
        sub      DI, BytesPerRow        { Zmen�en� y sou�adnice }
  @hor_neg_dy_L1:
        add      BP, SI                 { �prava predikce P = P + 2*deltay }
        ror      AH, 1                  { Zv�t�en� x sou�adnice }
        jc       @hor_neg_dy_L2         { P�es�hli jsme jeden byte ? }
        or       AL, AH                 { Uprav masku byte }
        loop     @hor_neg_dy            { Dal�� bod }
        jmp      @hor_neg_dy_lastbyte   { Do�li jsme do koncov�ho bodu }
  @hor_neg_dy_L2:
        out      DX, AL                 { Nastav� novou bitovou masku }
        mov      BL, BH
        xchg     [DI], BL               { Nakresl� body jednoho byte }
        mov      AL, AH                 { Inicializuje bitovou masku }
        inc      DI                     { Zv�t�� x sou�adnici }
        loop     @hor_neg_dy            { Byl to posledn� bod ? }
        jmp      @l_done                {        => konec kreslen� ��ry }
  @hor_neg_dy_lastbyte:
        xor      AL, AH                 { Posledn� bit je neplatn�, odstranit }
        out      DX, AL                 { Nastaven� bitov� masky }
        mov      BL, BH                 { BL = Barva ��ry }
        xchg     [DI], BL               { Nakreslen� bodu }
        jmp      @l_done                { Ukon�en� kreslen� ��ry }


  @vertical_dir:                        { V�po�et adresy 1. bodu }
        test    BP, neg_dy              { Kresl�me shora dol� ? }
        jz      @vert_init
        xchg    AX, CX                  { Prohozen� sou�adnic }
        xchg    BX, DX
        xor     BP, neg_dx              { �prava znam�nka }

  @vert_init:
        mov     CX, AX                  { CX = X1 }
        xchg    AX, BX                  { AX = Y1, BX = X1 }
        mov     DX, BytesPerRow         { DX = Po�et byte na ��dku (80) }
        mul     DX                      { AX:DX = Y1 * 80 }
        shr     BX, PixelsPerByte       { BX = X1 div 8 }
        add     BX, AX                  { BX = Offset adresy 1. bodu }

        mov     AX, DS                  { Ulo�� datov� segment do ES }
        mov     ES, AX

        mov     AX, VRAMSegment         { DS = Segment obrazov� pam�ti }
        mov     DS, AX
        mov     DX, GraphicsAR             { Port adresov�ho registru graf. kontroleru }
        mov     AX, ModeRegister + $0200   { Nastav� zapisovac� m�d 2 }
        out     DX, AX

        mov     AL, DataRotate          { Nastaven� zp�sobu kombinov�n� dat z CPU }
        mov     AH, ES: WriteMode       { s latch-registry                        }
        out     DX, AX

        and     CX, ModMask             { CX = X1 and 7 }
        mov     AH, BMask               { Bitov� maska pro lev� bod (80h) }
        shr     AH, CL                  { Rotac� vytvo�� spr�vnou masku }

        mov     DX, BP                  { Ulo�� znam�nka do DX }

        mov     CX, SI                  { CX = D�lka ��ry }
        inc     CX
                                        { Ur�en� predikace }
        shl     DI, 1                   { DI = 2*deltax }
        add     BP, DI                  { BP = 2*deltax }
        sub     BP, SI                  { BP = 2*deltax - deltay }
        shl     SI, 1                   { SI = 2*deltay }

        mov     ES: delta, SI           { ulo�� 2*deltay }
        mov     SI, DI                  { SI = 2*deltax }

        mov     DI, BX                  { DI = Offset adresy 1. bodu }

        test    DX, neg_dx              { Zji�t�n� sm�ru }
        mov     DX, GraphicsAR          { DX = adresov� port graf. kontroleru }
        jnz     @vert_neg_dx_init       { Rozskok podle znam�nka sm�rnice }

  @vert_pos_dx_init:                    { Kladn� sm�rnice }
        mov     BL, ES: ActColor        { BL = Barva ��ry }
        mov     BH, BL                  { BH = Barva ��ry }
        mov     AL, BitMask             { Index Bit mask registru }
        out     DX, AX
        inc     DX                      { DX = datov� registr graf. kontroleru }
        mov     AL, AH                  { AL = Bitov� maska }

  @vert_pos_dx:
        mov     BL, BH                  { BL = Barva ��ry }
        xchg    [DI], BL                { Nakresl� bod }
        cmp     BP, 0                   { Test predikce }
        jng     @vert_pos_dx_L1
        sub     BP, ES: delta           { P >= 0, P = P - 2*deltay }
        ror     AL, 1                   { Zvy� sou�adnici x }
        adc     DI, 0                   { P�esun do dal��ho byte }
        out     DX, AL                  { Nastav novou bitovou masku }

  @vert_pos_dx_L1:
        add     BP, SI                  { P = P + 2*deltax }
        add     DI, BytesPerRow         { Zvy� sou�adnici y }
        loop    @vert_pos_dx            { Dal�� bod }
        jmp     @l_done                 { Konec ��ry }

  @vert_neg_dx_init:                    { Z�porn� sm�rnice }
        mov     BL, ES: ActColor        { BL = Barva ��ry }
        mov     BH, BL                  { BH = Barva ��ry }
        mov     AL, BitMask             { Index Bit mask registru }
        out     DX, AX
        inc     DX                      { DX = datov� registr graf. kontroleru }
        mov     AL, AH                  { AL = Bitov� maska }

  @vert_neg_dx:
        mov     BL, BH                  { BL = Barva ��ry }
        xchg    [DI], BL                { Nakresl� bod }
        cmp     BP, 0                   { Test predikce }
        jng     @vert_neg_dx_L1
        sub     BP, ES: delta           { P >= 0, P = P - 2*deltay }
        rol     AL, 1                   { Zmen�i sou�adnici x }
        sbb     DI, 0                   { P�esun do dal��ho byte }
        out     DX, AL                  { Nastav novou bitovou masku }

  @vert_neg_dx_L1:
        add     BP, SI                  { P = P + 2*deltax }
        add     DI, BytesPerRow         { Zvy� sou�adnici y }
        loop    @vert_neg_dx            { Dal�� bod }
        jmp     @l_done                 { Konec ��ry }

  @l_done:
        mov     DX, GraphicsAR          { Smaz�n� bitov� masky }
        mov     AX, BitMask
        out     DX, AX
        mov     AX, ModeRegister
        out     DX, AX                  { Nastav� zapisovac� m�d 0 }
        mov     AX, DataRotate
        out     DX, AX                  { Vypne rotyci dat, standardn� kombinov�n� dat }

  @exit:
        pop      DS                     { Obnov� obsah registr� DS }
        pop      BP                     {                       BP }
end;

procedure SetMode( Mode: byte); assembler;
{ Nastav� aktu�ln� zobrazovac� re�im pomoc� slu�by 00h BIOS }
asm
        mov     AH, 00h
        mov     AL, Mode
        int     10h
end;
function GetMode: byte; assembler;
{ Slu�bou BIOS zjist� zobrazovac� re�im }
asm
        mov     AH, 0fh
        int     10h
end;

procedure InitGraph1;
{ Inicializace grafiky }
begin
  if not IsGraphicsMode then
    OldVMode := GetMode;        { Ulo�� ��slo aktivn�ho zobrazovac�ho re�imu }
  SetMode( $12);                { Nastav� zobrazovac� re�im 640 x 480, 16 barev }
  IsGraphicsMode := True;       { Nastav� p��znak p�epnut� do grafiky }
end;

procedure CloseGraph1;
{ Ukon�� grafick� re�im }
begin
  if IsGraphicsMode then SetMode( OldVMode);    { Obnov� p�vodn� zobr. re�im }
  IsGraphicsMode := False;
end;

procedure SetColor1( Color: byte);
{ Nastav� barvu pou�itou pro kreslen� }
begin

end;

procedure SetWriteMode( Mode: byte);
{ Nastav� zapisovac� re�im pro kreslen� }
begin
  WriteMode := Mode;
end;

begin
end.

