unit Thumbnails;

interface

uses
  Classes, Graphics;

const
  Thumb_Width  = 100;
  Thumb_Height = 75;
  Thumb_Size   = Thumb_Width * Thumb_Height * 3;

type
  TThumbnails = class
  private
    Thumbnails: TStringList;
    MainFile: TFileStream;
    Folder: string;
    procedure AddThumbnail(const Thumbnail: TBitmap; const FileName: string);
    procedure LoadHeader;
    procedure SaveHeader;
    procedure ReadBitmapData(const Bitmap: TBitmap; const Thumb_Index: Integer);
    procedure SaveBitmapData(const Bitmap: TBitmap; const Thumb_Index: Integer);
  public
    constructor Create(const ThumbnailsFile: string);
    destructor Destroy; override;
    procedure GetThumbnail(const Thumbnail: TBitmap; const FileName: string);
    procedure RefreshThumbnail(const Thumbnail: TBitmap; const FileName: string);
  end;

implementation

uses
  SysUtils, Jpeg, uCommon, Resample;

constructor TThumbnails.Create(const ThumbnailsFile: string);
var
  Thumb_Count: Integer;
begin
  inherited Create;
  Folder := ExtractFilePath(ThumbnailsFile);
  if not (FileExists(ThumbnailsFile)) then
  begin
    Thumb_Count := 0;
    MainFile := TFileStream.Create(ThumbnailsFile, fmCreate);
    MainFile.Write(Thumb_Count, SizeOF(Thumb_Count));
    MainFile.Free;
  end;
  MainFile := TFileStream.Create(ThumbnailsFile, fmOpenReadWrite);
  Thumbnails := TStringList.Create;
  LoadHeader;
end;

destructor TThumbnails.Destroy;
begin
  Thumbnails.Free;
  MainFile.Free;
  inherited;
end;

procedure TThumbnails.GetThumbnail(const Thumbnail: TBitmap; const FileName: string);
var
  k: Integer;
begin
  k := Thumbnails.IndexOf(FileName);
  if k = -1 then
  begin
    AddThumbnail(Thumbnail, FileName);
  end else
  begin
    ReadBitmapData(Thumbnail, k);
  end;
end;

procedure TThumbnails.AddThumbnail(const Thumbnail: TBitmap; const FileName: string);
var
  JPEGImage: TJPEGImage;
  Bitmap: TBitmap;
begin
  JPEGImage := TJPEGImage.Create;
  try
    JPEGImage.PixelFormat := jf24Bit;
    JPEGImage.Performance := jpBestSpeed;
    JPEGImage.Smoothing := False;
    JPEGImage.Scale := jsQuarter{jsEighth};
    JPEGImage.LoadFromFile(Folder + FileName);
    JPEGImage.DIBNeeded;
    Bitmap := TBitmap.Create;
    try
      Bitmap.PixelFormat := pf24bit;
      Bitmap.Width := JPEGImage.Width;
      Bitmap.Height := JPEGImage.Height;
      Bitmap.Canvas.Draw(0, 0, JPEGImage);

      CreateThumbnail(Bitmap, Thumbnail);

      Thumbnails.Add(FileName);
      SaveBitmapData(Thumbnail, Thumbnails.Count - 1);
      SaveHeader;
    finally
      Bitmap.Free;
    end;
  finally
    JPEGImage.Free;
  end;
end;

procedure TThumbnails.RefreshThumbnail(const Thumbnail: TBitmap; const FileName: string);
var
  JPEGImage: TJPEGImage;
  Bitmap: TBitmap;
  k: Integer;
begin
  JPEGImage := TJPEGImage.Create;
  try
    JPEGImage.PixelFormat := jf24Bit;
    JPEGImage.Performance := jpBestSpeed;
    JPEGImage.Smoothing := False;
    JPEGImage.Scale := jsQuarter{jsEighth};
    JPEGImage.LoadFromFile(Folder + FileName);
    JPEGImage.DIBNeeded;
    Bitmap := TBitmap.Create;
    try
      Bitmap.PixelFormat := pf24bit;
      Bitmap.Width := JPEGImage.Width;
      Bitmap.Height := JPEGImage.Height;
      Bitmap.Canvas.Draw(0, 0, JPEGImage);

      CreateThumbnail(Bitmap, Thumbnail);

      k := Thumbnails.IndexOf(FileName);
      SaveBitmapData(Thumbnail, k);
      SaveHeader;
    finally
      Bitmap.Free;
    end;
  finally
    JPEGImage.Free;
  end;
end;

procedure TThumbnails.LoadHeader;
var
  Thumb_Count: Integer;
  i: Integer;
  FName: AnsiString;
  FName_Len: Integer;
begin
  MainFile.Seek(0, soFromBeginning);
  MainFile.Read(Thumb_Count, SizeOf(Thumb_Count));
  Thumbnails.Clear;
  Thumbnails.Capacity := Thumb_Count;
  MainFile.Seek(Thumb_Size * Thumb_Count, soFromCurrent);
  for i := 0 to Thumb_Count - 1 do
  begin
    MainFile.Read(FName_Len, SizeOf(FName_Len));
    SetLength(FName, FName_Len);
    MainFile.Read(FName[1], FName_Len);
    Thumbnails.Add(FName);
  end;
end;

procedure TThumbnails.SaveHeader;
var
  Thumb_Count: Integer;
  i: Integer;
  FName: AnsiString;
  FName_Len: Integer;
begin
  Thumb_Count := Thumbnails.Count;
  MainFile.Seek(0, soFromBeginning);
  MainFile.Write(Thumb_Count, SizeOf(Thumb_Count));
  MainFile.Seek(Thumb_Size * Thumb_Count, soFromCurrent);
  for i := 0 to Thumb_Count - 1 do
  begin
    FName := Thumbnails[i];
    FName_Len := Length(FName);
    MainFile.Write(FName_Len, SizeOf(FName_Len));
    MainFile.Write(FName[1], FName_Len);
  end;
end;

procedure TThumbnails.ReadBitmapData(const Bitmap: TBitmap; const Thumb_Index: Integer);
var
  i: Integer;
  Line: PByte;
begin
  MainFile.Seek(SizeOf(Integer) + Thumb_Index * Thumb_Size, soFromBeginning);
  for i := 0 to Thumb_Height - 1 do
  begin
    Line := Bitmap.ScanLine[i];
    MainFile.Read(Line^, Thumb_Width * 3);
  end;
end;

procedure TThumbnails.SaveBitmapData(const Bitmap: TBitmap; const Thumb_Index: Integer);
var
  i: Integer;
  Line: PByte;
begin
  MainFile.Seek(SizeOf(Integer) + Thumb_Index * Thumb_Size, soFromBeginning);
  for i := 0 to Thumb_Height - 1 do
  begin
    Line := Bitmap.ScanLine[i];
    MainFile.Write(Line^, Thumb_Width * 3);
  end;
end;

end.

