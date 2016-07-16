{$R-}    {Range checking off}
{$B-}    {Boolean complete evaluation off}
{$S-}    {Stack checking off}
{$I+}    {I/O checking on}


unit show_pcx;
interface
uses Crt, Dos,graph,menus;
type str80 = string [80];

procedure Read_PCX (name: str80);

implementation
const MAX_WIDTH = 4000;    { arbitrary - maximum width (in bytes) of a PCX image }
      COMPRESS_NUM = $C0;  { this is the upper two bits that indicate a count }
      MAX_BLOCK = 4096;
      RED = 0;GREEN = 1;BLUE = 2;
type file_buffer = array [0..127] of byte;
     block_array = array [0..MAX_BLOCK] of byte;
     line_array = array [0..MAX_WIDTH] of byte;
     pcx_header = record
        Manufacturer: byte;     { Always 10 for PCX file }
        Version: byte;          { 2 - old PCX - no palette (not used anymore),
                                  3 - no palette,
                                  4 - Microsoft Windows - no palette (only in
                                      old files, new Windows version uses 3),
                                  5 - with palette }
        Encoding: byte;         { 1 is PCX, it is possible that we may add
                                  additional encoding methods in the future }
        Bits_per_pixel: byte;   { Number of bits to represent a pixel
                                  (per plane) - 1, 2, 4, or 8 }
        Xmin: integer;          { Image window dimensions (inclusive) }
        Ymin: integer;          { Xmin, Ymin are usually zero (not always) }
        Xmax: integer;
        Ymax: integer;
        Hdpi: integer;          { Resolution of image (dots per inch) }
        Vdpi: integer;          { Set to scanner resolution - 300 is default }
        ColorMap: array [0..15, RED..BLUE] of byte;
                                { RGB palette data (16 colors or less)
                                  256 color palette is appended to end of file }
        Reserved: byte;         { (used to contain video mode)
                                  now it is ignored - just set to zero }
        Nplanes: byte;          { Number of planes }
        Bytes_per_line_per_plane: integer;   { Number of bytes to allocate
                                               for a scanline plane.
                                               MUST be an an EVEN number!
                                               Do NOT calculate from Xmax-Xmin! }
        PaletteInfo: integer;   { 1 = black & white or color image,
                                  2 = grayscale image - ignored in PB4, PB4+
                                  palette must also be set to shades of gray! }
        HscreenSize: integer;   { added for PC Paintbrush IV Plus ver 1.0,  }
        VscreenSize: integer;   { PC Paintbrush IV ver 1.02 (and later)     }
                                { I know it is tempting to use these fields
                                  to determine what video mode should be used
                                  to display the image - but it is NOT
                                  recommended since the fields will probably
                                  just contain garbage. It is better to have
                                  the user install for the graphics mode he
                                  wants to use... }
        Filler: array [74..127] of byte;     { Just set to zeros }
        end;
var
   Name: str80;                        { Name of PCX file to load }
   BlockFile: file;                    { file for reading block data }
   BlockData: block_array;             { 4k data buffer }
   Header: pcx_header;                 { PCX file header }
   PCXline: line_array;                { place to put uncompressed data }
   Ymax: integer;                      { maximum Y value on screen }
   NextByte: integer;                  { index into file buffer in ReadByte }
   Index: integer;                     { PCXline index - where to put Data }
   Data: byte;                         { PCX compressed data byte }

procedure ShowEGA (Y: integer);
var i,t:integer;
begin
with header do
 for i:=0 to (xmax-xmin) do begin
  putpixel(2*i,y,Pcxline[i] shr 4);
  putpixel(2*i+1,y,Pcxline[i] and 15);
 end;
end;

procedure ReadByte;{ read a single byte of data - use BlockRead because it is FAST! }
var NumBlocksRead: integer;
begin
if NextByte = MAX_BLOCK then begin
 BlockRead (BlockFile, BlockData, MAX_BLOCK, NumBlocksRead);NextByte := 0;
end;
data := BlockData [NextByte];inc (NextByte);
end;

procedure Read_PCX_Line;{ Read a line from a PC Paintbrush PCX file }
var count,bytes_per_line: integer;
begin
{$I-}
bytes_per_line := Header.Bytes_per_line_per_plane * Header.Nplanes;
if Index <> 0 then FillChar (PCXline [0], Index, data);    { fills a contiguous block of data }
while (Index < bytes_per_line) do begin  { read 1 line of data (all planes) }
 ReadByte;
 if (data and $C0) = compress_num then begin
  count := data and $3F;ReadByte;
  FillChar (PCXline [Index], count, data);  { fills a contiguous block }
  inc (Index, count);end
 else begin PCXline [Index] := data;inc (Index);end;
end;
Index := Index - bytes_per_line;
{$I+}
end;

procedure Read_PCX (name: str80);{ Read PC Paintbrush PCX file and put it on the screen }
const colnum:array[0..15] of byte=(0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
var k, kmax: integer;
begin
{$I-}
assign (BlockFile, name);reset (BlockFile, 1);{ use 1 byte blocks }
BlockRead (BlockFile, Header, 128);         { read 128 byte PCX header }
Index := 0;NextByte := MAX_BLOCK;          { indicates no data read in yet... }
Ymax:=479;kmax := Header.Ymin + Ymax;
if Header.Ymax < kmax then          { don't show more than the screen can display }
   kmax := Header.ymax+header.ymin;
for k := Header.Ymin to kmax do begin  { each loop is separate for speed }
 Read_PCX_Line;
 ShowEGA (k);
 end;
with header do
 for k:=0 to 15 do begin
  colormap[k,red]:=round(colormap[k,red]/4);
  colormap[k,green]:=round(colormap[k,green]/4);
  colormap[k,blue]:=round(colormap[k,blue]/4);
  setRGBpalette(colnum[k],colormap[k,red],colormap[k,green],colormap[k,blue]);
 end;
close (BlockFile);
{$I+}
end;
end.
