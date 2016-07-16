Unit SGraph;

interface

Const
  { Konstanty pro typ kreslení }
  NormalPut = 0;              { Pøepisování }
  ANDPut    = 8;              { Logické AND }
  ORPut     = 16;             { Logické OR }
  XORPut    = 24;             { Logické XOR }

{ Hlavièky exportovaných procedur }
procedure Line1( X1, Y1, X2, Y2: word);  { Kreslení èáry }
procedure InitGraph1;                    { Inicializace grafiky }
procedure CloseGraph1;                   { Obnovení pùvodního videomódu }
procedure SetColor1( Color: byte);       { Nastavení barvy pro kreslení èar }
procedure SetWriteMode( Mode: byte);    { Volba druhu kombinace kreslených a
                                          ji¾ zobrazených dat }

implementation

Const
  ActColor: byte = 15;          { Promìná slou¾ící k ulo¾ení aktuální barvy
                                  Standardnì je nastavena bílá barva }
  WriteMode: byte = 0;          { Zapisovací re¾im 0 = pøepisování
                                                   8 = AND
                                                  16 = OR
                                                  24 = XOR          }
  BytesPerRow = 80;             { Poèet byte v jedné øádce (640/8 = 80) }
  IsGraphicsMode: boolean
                  = false;      { Indikace zda jsme v grafice }
  PixelsPerByte      = 3;            { Poèet bodù v jednom bite udaný
                                       v bitových posuvech }
  ModMask            = 7;            { Bitová maska pro získání MOD 8 (zbytku
                                       po dìlení osmi }
  BMask              = 128;          { Bitová maska pro kreslení bodu }
  VRAMSegment        = $a000;        { Segment poèátku obrazové pamìti }
  GraphicsAR         = $3ce;         { Port Graphics 1 and 2 Address Register }
  ModeRegister       = 5;            { Index registru zapisovacího módu }
  DataRotate         = 3;            { Index registru pro rotaci a kombinaci dat }
  BitMask            = 8;            { Index registru bitové masky }

var
   OldVMode: byte;                   { Promìná slou¾ící pro uchování èísla
                                       zobrazovacího re¾imu }
   delta: word;                      { Pomocné promìné pro uchování 2dx nebo 2dy}


procedure Line1( X1, Y1, X2, Y2: word); assembler;
{ Kreslí èáru z X1, Y1 do X2, Y2 }
const
     neg_dx     = 2;            { Znaménko od delta x }
     neg_dy     = 4;            { Znaménko od delta y }

asm
        push    BP              { Uchování registrù BP }
        push    DS              {                 a DS }

        mov     AX, X1          { Naètení souøadnic do registrù procesoru }
        mov     BX, Y1
        mov     CX, X2
        mov     DX, Y2

        xor     BP, BP          { Smazání registru BP }
        mov     DI, CX          { Spoèítání hodnoty deltax }
        sub     DI, AX
        jg      @p_dx           { Je deltax kladné ? }
        or      BP, neg_dx      { ne => ulo¾ znaménko do BP }
        neg     DI              {       absolutní hodnota DI tj. deltax }

  @p_dx:
        mov     SI, DX          { Urèení hodnoty deltay }
        sub     SI, BX
        jg      @p_dy           { Je deltay kladné ? }
        or      BP, neg_dy      { ne => ulo¾ znaménko do BP }
        neg     SI              {       absolutní hodnota delaty }

  @p_dy:
        cmp     DI, SI          { Porovnání deltax a deltay }
        jb      @vertical_dir   { deltax > deltay <=> absolutní hodnota smìrnice > 1
                                                          => vertikální smìr
                                  deltax <= deltay <=> absolutní hodnota smìrnice <= 1
                                                          => horizontální smìr          }

  @horizontal_dir:
        test    BP, neg_dx      { Porovnání X1 a X2 }
        jz      @hor_init       { Je smìr zprava doleva ? }
        xchg    AX, CX          { ne => vymìn souøadnice poèátku a konce èáry }
        xchg    BX, DX
        xor     BP, neg_dy      { uprav znaménko deltay }

  @hor_init:                    { Výpoèet adresy prvního bodu }
        mov     CX, AX          { Do CX X1 }
        xchg    AX, BX          { BX = X1, AX = X2 }
        mov     DX, BytesPerRow        { DX = Poèet byte na jedné øádce (80) }
        mul     DX                     { AX:DX = Y1 * 80 }
        shr     BX, PixelsPerByte      { BX = BX div 8 }
        add     BX, AX                 { V BX je offset prvního bodu èáry }

        mov     AX, DS                 { Do ES pøesuneme DS }
        mov     ES, AX

        mov     AX, VRAMSegment        { Segment obrazové pamìti do DS }
        mov     DS, AX
        mov     DX, GraphicsAR            { Port adresového registru grafického kontroleru }
        mov     AX, ModeRegister + $0200  { Nastaví zapisovací mód 2 }
        out     DX, AX

        mov     AL, DataRotate            { Nastaví zpùsob kombinace dat z CPU }
        mov     AH, ES: WriteMode         { s latch-registry }
        out     DX, AX

        and     CX, ModMask             { CX = X1 and 7 }
        mov     AH, BMask               { AH = 80h, tj. nastaven je levý pixel }
        shr     AH, CL                  { Rotace AH. Po rotaci je v AH bitová maska bodu }

        mov     DX, BP                  { Uchová znaménka deltax a deltay v DX }

        mov     CX, DI                  { CX = deltax }
        inc     CX                      { CX = deltax - 1, tj. poèet bodù na èáøe }
                                        { Výpoèet predikce do BP: }
        shl     SI, 1                   { SI = 2*deltay }
        mov     BP, SI                  { BP = 2*deltay }
        sub     BP, DI                  { BP = 2*deltax - deltay }
        shl     DI, 1                   { DI = 2*deltax }

        mov     ES: delta, DI           { Ulo¾ení hodnoty 2*deltax }

        mov     DI, BX                  { Do DI offset adresy 1. bodu }

        test    DX, neg_dy              { Urèení smìru }
        pushf                           { Uchování flagù }
        mov     DX, GraphicsAR          { Nastaví index graf. kontroleru na Bit mask reg. }
        mov     AL, BitMask
        out     DX, AL
        inc     DX                      { DX = datový port graf. kontroleru }
        popf                            { Obnoví flagy s výsledkem testu smìru }
        jnz     @hor_neg_dy_init        { Rozskok, podle znaménka smìrnice }

  @hor_pos_dy_init:                     { Kladná smìrnice, y souøadnice je zvy¹ována }
        mov     BL, ES: ActColor        { BL = Barva èáry }
        mov     BH, BL                  { BH = Barva èáry }
        mov     AL, AH                  { AL = Bitová maska prvního bodu }

  @hor_pos_dy:
        cmp      BP, 0                  { Test predikce }
        jng      @hor_pos_dy_L1
        out      DX, AL                 { predikce >= 0 }
        mov      BL, BH                 { BL = Barva bodu }
        xchg     [DI], BL               { Nakresli bod }
        xor      AL, AL                 { Vynuluje støádanou masku }
        sub      BP, ES: delta          { Upraví predikaci P = P - 2*deltax }
        add      DI, BytesPerRow        { Zvìt¹ení y souøadnice }
  @hor_pos_dy_L1:
        add      BP, SI                 { Úprava predikce P = P + 2*deltay }
        ror      AH, 1                  { Zvìt¹ení x souøadnice }
        jc       @hor_pos_dy_L2         { Pøesáhli jsme jeden byte ? }
        or       AL, AH                 { Uprav masku byte }
        loop     @hor_pos_dy            { Dal¹í bod }
        jmp      @hor_pos_dy_lastbyte   { Do¹li jsme do koncového bodu }
  @hor_pos_dy_L2:
        out      DX, AL                 { Nastaví novou bitovou masku }
        mov      BL, BH
        xchg     [DI], BL               { Nakreslí body jednoho byte }
        mov      AL, AH                 { Inicializuje bitovou masku }
        inc      DI                     { Zvìt¹í x souøadnici }
        loop     @hor_pos_dy            { Byl to poslední bod ? }
        jmp      @l_done                {        => konec kreslení èáry }
  @hor_pos_dy_lastbyte:
        xor      AL, AH                 { Poslední bit je neplatný, odstranit }
        out      DX, AL                 { Nastavení bitové masky }
        mov      BL, BH                 { BL = Barva èáry }
        xchg     [DI], BL               { Nakreslení bodu }
        jmp      @l_done                { Ukonèení kreslení èáry }

  @hor_neg_dy_init:                     { Záporná smìrnice, y souøadnice je zmen¹ována }
        mov     BL, ES: ActColor        { BL = Barva èáry }
        mov     BH, BL                  { BH = Barva èáry }
        mov     AL, AH                  { AL = Bitová maska prvního bodu }

  @hor_neg_dy:
        cmp      BP, 0                  { Test predikce }
        jng      @hor_neg_dy_L1
        out      DX, AL                 { predikce >= 0 }
        mov      BL, BH                 { BL = Barva bodu }
        xchg     [DI], BL               { Nakresli bod }
        xor      AL, AL                 { Vynuluje støádanou masku }
        sub      BP, ES: delta          { Upraví predikaci P = P - 2*deltax }
        sub      DI, BytesPerRow        { Zmen¹ení y souøadnice }
  @hor_neg_dy_L1:
        add      BP, SI                 { Úprava predikce P = P + 2*deltay }
        ror      AH, 1                  { Zvìt¹ení x souøadnice }
        jc       @hor_neg_dy_L2         { Pøesáhli jsme jeden byte ? }
        or       AL, AH                 { Uprav masku byte }
        loop     @hor_neg_dy            { Dal¹í bod }
        jmp      @hor_neg_dy_lastbyte   { Do¹li jsme do koncového bodu }
  @hor_neg_dy_L2:
        out      DX, AL                 { Nastaví novou bitovou masku }
        mov      BL, BH
        xchg     [DI], BL               { Nakreslí body jednoho byte }
        mov      AL, AH                 { Inicializuje bitovou masku }
        inc      DI                     { Zvìt¹í x souøadnici }
        loop     @hor_neg_dy            { Byl to poslední bod ? }
        jmp      @l_done                {        => konec kreslení èáry }
  @hor_neg_dy_lastbyte:
        xor      AL, AH                 { Poslední bit je neplatný, odstranit }
        out      DX, AL                 { Nastavení bitové masky }
        mov      BL, BH                 { BL = Barva èáry }
        xchg     [DI], BL               { Nakreslení bodu }
        jmp      @l_done                { Ukonèení kreslení èáry }


  @vertical_dir:                        { Výpoèet adresy 1. bodu }
        test    BP, neg_dy              { Kreslíme shora dolù ? }
        jz      @vert_init
        xchg    AX, CX                  { Prohození souøadnic }
        xchg    BX, DX
        xor     BP, neg_dx              { Úprava znaménka }

  @vert_init:
        mov     CX, AX                  { CX = X1 }
        xchg    AX, BX                  { AX = Y1, BX = X1 }
        mov     DX, BytesPerRow         { DX = Poèet byte na øádku (80) }
        mul     DX                      { AX:DX = Y1 * 80 }
        shr     BX, PixelsPerByte       { BX = X1 div 8 }
        add     BX, AX                  { BX = Offset adresy 1. bodu }

        mov     AX, DS                  { Ulo¾í datový segment do ES }
        mov     ES, AX

        mov     AX, VRAMSegment         { DS = Segment obrazové pamìti }
        mov     DS, AX
        mov     DX, GraphicsAR             { Port adresového registru graf. kontroleru }
        mov     AX, ModeRegister + $0200   { Nastaví zapisovací mód 2 }
        out     DX, AX

        mov     AL, DataRotate          { Nastavení zpùsobu kombinování dat z CPU }
        mov     AH, ES: WriteMode       { s latch-registry                        }
        out     DX, AX

        and     CX, ModMask             { CX = X1 and 7 }
        mov     AH, BMask               { Bitová maska pro levý bod (80h) }
        shr     AH, CL                  { Rotací vytvoøí správnou masku }

        mov     DX, BP                  { Ulo¾í znaménka do DX }

        mov     CX, SI                  { CX = Délka èáry }
        inc     CX
                                        { Urèení predikace }
        shl     DI, 1                   { DI = 2*deltax }
        add     BP, DI                  { BP = 2*deltax }
        sub     BP, SI                  { BP = 2*deltax - deltay }
        shl     SI, 1                   { SI = 2*deltay }

        mov     ES: delta, SI           { ulo¾í 2*deltay }
        mov     SI, DI                  { SI = 2*deltax }

        mov     DI, BX                  { DI = Offset adresy 1. bodu }

        test    DX, neg_dx              { Zji¹tìní smìru }
        mov     DX, GraphicsAR          { DX = adresový port graf. kontroleru }
        jnz     @vert_neg_dx_init       { Rozskok podle znaménka smìrnice }

  @vert_pos_dx_init:                    { Kladná smìrnice }
        mov     BL, ES: ActColor        { BL = Barva èáry }
        mov     BH, BL                  { BH = Barva èáry }
        mov     AL, BitMask             { Index Bit mask registru }
        out     DX, AX
        inc     DX                      { DX = datový registr graf. kontroleru }
        mov     AL, AH                  { AL = Bitová maska }

  @vert_pos_dx:
        mov     BL, BH                  { BL = Barva èáry }
        xchg    [DI], BL                { Nakreslí bod }
        cmp     BP, 0                   { Test predikce }
        jng     @vert_pos_dx_L1
        sub     BP, ES: delta           { P >= 0, P = P - 2*deltay }
        ror     AL, 1                   { Zvy¹ souøadnici x }
        adc     DI, 0                   { Pøesun do dal¹ího byte }
        out     DX, AL                  { Nastav novou bitovou masku }

  @vert_pos_dx_L1:
        add     BP, SI                  { P = P + 2*deltax }
        add     DI, BytesPerRow         { Zvy¹ souøadnici y }
        loop    @vert_pos_dx            { Dal¹í bod }
        jmp     @l_done                 { Konec èáry }

  @vert_neg_dx_init:                    { Záporná smìrnice }
        mov     BL, ES: ActColor        { BL = Barva èáry }
        mov     BH, BL                  { BH = Barva èáry }
        mov     AL, BitMask             { Index Bit mask registru }
        out     DX, AX
        inc     DX                      { DX = datový registr graf. kontroleru }
        mov     AL, AH                  { AL = Bitová maska }

  @vert_neg_dx:
        mov     BL, BH                  { BL = Barva èáry }
        xchg    [DI], BL                { Nakreslí bod }
        cmp     BP, 0                   { Test predikce }
        jng     @vert_neg_dx_L1
        sub     BP, ES: delta           { P >= 0, P = P - 2*deltay }
        rol     AL, 1                   { Zmen¹i souøadnici x }
        sbb     DI, 0                   { Pøesun do dal¹ího byte }
        out     DX, AL                  { Nastav novou bitovou masku }

  @vert_neg_dx_L1:
        add     BP, SI                  { P = P + 2*deltax }
        add     DI, BytesPerRow         { Zvy¹ souøadnici y }
        loop    @vert_neg_dx            { Dal¹í bod }
        jmp     @l_done                 { Konec èáry }

  @l_done:
        mov     DX, GraphicsAR          { Smazání bitové masky }
        mov     AX, BitMask
        out     DX, AX
        mov     AX, ModeRegister
        out     DX, AX                  { Nastaví zapisovací mód 0 }
        mov     AX, DataRotate
        out     DX, AX                  { Vypne rotyci dat, standardní kombinování dat }

  @exit:
        pop      DS                     { Obnoví obsah registrù DS }
        pop      BP                     {                       BP }
end;

procedure SetMode( Mode: byte); assembler;
{ Nastaví aktuální zobrazovací re¾im pomocí slu¾by 00h BIOS }
asm
        mov     AH, 00h
        mov     AL, Mode
        int     10h
end;
function GetMode: byte; assembler;
{ Slu¾bou BIOS zjistí zobrazovací re¾im }
asm
        mov     AH, 0fh
        int     10h
end;

procedure InitGraph1;
{ Inicializace grafiky }
begin
  if not IsGraphicsMode then
    OldVMode := GetMode;        { Ulo¾í èíslo aktivního zobrazovacího re¾imu }
  SetMode( $12);                { Nastaví zobrazovací re¾im 640 x 480, 16 barev }
  IsGraphicsMode := True;       { Nastaví pøíznak pøepnutí do grafiky }
end;

procedure CloseGraph1;
{ Ukonèí grafický re¾im }
begin
  if IsGraphicsMode then SetMode( OldVMode);    { Obnoví pùvodní zobr. re¾im }
  IsGraphicsMode := False;
end;

procedure SetColor1( Color: byte);
{ Nastaví barvu pou¾itou pro kreslení }
begin

end;

procedure SetWriteMode( Mode: byte);
{ Nastaví zapisovací re¾im pro kreslení }
begin
  WriteMode := Mode;
end;

begin
end.

