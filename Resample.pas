unit Resample;

interface

uses
  SysUtils, Classes, Graphics;

procedure SmoothResize(const Src, Dst: TBitmap);

implementation

procedure SmoothResize(const Src, Dst: TBitmap);
var
  x, y, xP, yP, yP2, xP2: Integer;
  Read, Read2: PByteArray;
  t, t3, t13, z, z2, iz2: Integer;
  pc: PBytearray;
  w1, w2, w3, w4: Integer;
  Col1r, col1g, col1b, Col2r, col2g, col2b: Byte;
begin
  xP2 := ((src.Width - 1) shl 15) div Dst.Width;
  yP2 := ((src.Height - 1) shl 15) div Dst.Height;
  yP := 0;
  for y := 0 to Dst.Height - 1 do
  begin
    xP := 0;
    Read := src.ScanLine[yP shr 15];
    if yP shr 16 < src.Height - 1 then
      Read2 := src.ScanLine[yP shr 15 + 1]
    else
      Read2 := src.ScanLine[yP shr 15];
    pc := Dst.scanline[y];
    z2 := yP and $7FFF;
    iz2 := $8000 - z2;
    for x := 0 to Dst.Width - 1 do
    begin
      t := xP shr 15;
      t3 := t * 3;
      t13 := t3 + 3;
      Col1r := Read[t3];
      Col1g := Read[t3 + 1];
      Col1b := Read[t3 + 2];
      Col2r := Read2[t3];
      Col2g := Read2[t3 + 1];
      Col2b := Read2[t3 + 2];
      z := xP and $7FFF;
      w2 := (z * iz2) shr 15;
      w1 := iz2 - w2;
      w4 := (z * z2) shr 15;
      w3 := z2 - w4;
      pc[x * 3 + 2] :=
        (Col1b * w1 + Read[t13 + 2] * w2 +
        Col2b * w3 + Read2[t13 + 2] * w4) shr 15;
      pc[x * 3 + 1] :=
        (Col1g * w1 + Read[t13 + 1] * w2 +
        Col2g * w3 + Read2[t13 + 1] * w4) shr 15;
      // (t+1)*3  is now t13
      pc[x * 3] :=
        (Col1r * w1 + Read2[t13] * w2 +
        Col2r * w3 + Read2[t13] * w4) shr 15;
      Inc(xP, xP2);
    end;
    Inc(yP, yP2);
  end;
end;

end.

