unit uCommon;

interface

uses Windows, Classes, Graphics, Math, Resample, Jpeg, Registry;

const
  RegKey = 'Software\MyWallpapers';

type
  TDefRegistry = class(TRegistry)
  public
    function ReadBoolDef(const Name: string; Default: Boolean): Boolean;
    function ReadStringDef(const Name: string; Default: string): string;
    function ReadIntegerDef(const Name: string; Default: Integer): Integer;
  end;

var
  //Настройки
  //Обои
  ShowInTray: Boolean;
  StretchAnyway: Boolean;
  UseWorkArea: Boolean;
  HotKey: TShortCut;
  AutoChangePeriod: Integer;
  UseCurrResolution: Boolean;
  //Календарь
  UseCalendar: Boolean;
  CalendarLayout: Integer;
  HorizSpace: Integer;
  VertSpace: Integer;
  CalendarCaption: string;
  FontCaption: TFont;
  CurrentDayColor: TColor;
  HolidayColor: TColor;
  ShadowColor: TColor;
  ShadowHor: Integer;
  ShadowVert: Integer;
  //Другое
  CollectionsFolder: string;
  ThumbnailsFile: string;

  //Разрешение экрана при запуске
  Screen_W, Screen_H: Integer;
  WorkArea_W, WorkArea_H: Integer;

procedure LoadSettings;
procedure SaveSettings;
procedure CreateThumbnail(const Source: TBitmap; const Dest: TBitmap);
procedure SetWallPaper(FileName: string);
procedure UpdateCurrentWallPaper;
function ShellDeleteFile(const Handle: HWND; const FileName: string): Boolean;
function ShellRenameFile(const Handle: HWND; const OldName, NewName: string): Boolean;
function ShellCopyFile(const Handle: HWND; const OldName, NewName: string): Boolean;
function ShellBatchCopyFiles(const Handle: HWND; const Files: TStrings; const Folder: string): Boolean;
function ShellBatchDeleteFiles(const Handle: HWND; const Files: TStrings): Boolean;
procedure CreateCalendar(const Calendar: TBitmap);
procedure GetScreenResolution;
function GetSystemFolder(const nFolder: Integer): string;

implementation

uses SysUtils, ShlObj, DateUtils, ShellAPI;

function TDefRegistry.ReadBoolDef(const Name: string; Default: Boolean): Boolean;
begin
  if ValueExists(Name) then
    Result := ReadBool(Name) else
    Result := Default;
end;

function TDefRegistry.ReadIntegerDef(const Name: string; Default: Integer): Integer;
begin
  if ValueExists(Name) then
    Result := ReadInteger(Name) else
    Result := Default;
end;

function TDefRegistry.ReadStringDef(const Name: string; Default: string): string;
begin
    if ValueExists(Name) then
    Result := ReadString(Name) else
    Result := Default;
end;

procedure LoadSettings;
var
  Reg: TDefRegistry;
  FontCaptionStyle: Integer;
begin
  Reg := TDefRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(RegKey, True);
    //Обои
    StretchAnyway := Reg.ReadBoolDef('StretchAnyway', True);
    UseWorkArea := Reg.ReadBoolDef('UseWorkArea', True);
    ShowInTray := Reg.ReadBoolDef('ShowInTray', True);
    HotKey := Reg.ReadIntegerDef('HotKey', 24663);
    AutoChangePeriod := Reg.ReadIntegerDef('AutoChangePeriod', 60);
    UseCurrResolution := Reg.ReadBoolDef('UseCurrResolution', True);
    //Календарь
    UseCalendar := Reg.ReadBoolDef('UseCalendar', True);
    CalendarLayout := Reg.ReadIntegerDef('CalendarLayout', 2);
    HorizSpace := Reg.ReadIntegerDef('HorizSpace', 20);
    VertSpace := Reg.ReadIntegerDef('VertSpace', 20);
    CalendarCaption := Reg.ReadStringDef('CalendarCaption', 'd MMMM yyyy');
    FontCaption.Name := Reg.ReadStringDef('FontCaptionName', 'Arial');
    FontCaption.Size := Reg.ReadIntegerDef('FontCaptionSize', 12);
    FontCaption.Color := Reg.ReadIntegerDef('FontCaptionColor', clWhite);
    FontCaptionStyle := Reg.ReadIntegerDef('FontCaptionStyle', 1);
    case FontCaptionStyle of
      0: FontCaption.Style := [];
      1: FontCaption.Style := [fsBold];
      2: FontCaption.Style := [fsItalic];
      else
        FontCaption.Style := [fsBold, fsItalic];
    end;
    CurrentDayColor := Reg.ReadIntegerDef('CurrentDayColor', $008000);
    HolidayColor := Reg.ReadIntegerDef('HolidayColor', $FF8000);
    ShadowColor := Reg.ReadIntegerDef('ShadowColor', clBlack);
    ShadowHor := Reg.ReadIntegerDef('ShadowHor', 2);
    ShadowVert := Reg.ReadIntegerDef('ShadowVert', 2);
    //Другое
    CollectionsFolder := Reg.ReadStringDef('CollectionsFolder', ExtractFilePath(ParamStr(0)));
    ThumbNailsFile := Reg.ReadStringDef('ThumbnailsFile', 'Thumbnails.db');
  finally
    Reg.Free;
  end;

  GetScreenResolution;
end;

procedure GetScreenResolution;
var
  Dsk_Rect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Dsk_Rect, 0);
  Screen_W := Dsk_Rect.Right - Dsk_Rect.Left;
  Screen_H := Dsk_Rect.Bottom - Dsk_Rect.Top;
  WorkArea_W := GetSystemMetrics(SM_CXVIRTUALSCREEN);
  WorkArea_H := GetSystemMetrics(SM_CYVIRTUALSCREEN);
end;

procedure SaveSettings;
var
  Reg: TRegistry;
  FontCaptionStyle: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(RegKey, True);
    //Обои
    Reg.WriteBool('StretchAnyway', StretchAnyway);
    Reg.WriteBool('UseWorkArea', UseWorkArea);
    Reg.WriteBool('ShowInTray', ShowInTray);
    Reg.WriteInteger('HotKey', HotKey);
    Reg.WriteInteger('AutoChangePeriod', AutoChangePeriod);
    Reg.WriteBool('UseCurrResolution', UseCurrResolution);
    //Календарь
    Reg.WriteBool('UseCalendar', UseCalendar);
    Reg.WriteInteger('CalendarLayout', CalendarLayout);
    Reg.WriteInteger('HorizSpace', HorizSpace);
    Reg.WriteInteger('VertSpace', VertSpace);
    Reg.WriteString('CalendarCaption', CalendarCaption);
    Reg.WriteString('FontCaptionName', FontCaption.Name);
    Reg.WriteInteger('FontCaptionSize', FontCaption.Size);
    Reg.WriteInteger('FontCaptionColor', FontCaption.Color);
    if (fsBold in FontCaption.Style) and (fsItalic in FontCaption.Style) then
      FontCaptionStyle := 3
    else
    if fsItalic in FontCaption.Style then
      FontCaptionStyle := 2
    else
    if fsBold in FontCaption.Style then
      FontCaptionStyle := 1
    else
      FontCaptionStyle := 0;
    Reg.WriteInteger('FontCaptionStyle', FontCaptionStyle);
    Reg.WriteInteger('CurrentDayColor', CurrentDayColor);
    Reg.WriteInteger('HolidayColor', HolidayColor);
    Reg.WriteInteger('ShadowColor', ShadowColor);
    Reg.WriteInteger('ShadowHor', ShadowHor);
    Reg.WriteInteger('ShadowVert', ShadowVert);
    //Другое
    Reg.WriteString('CollectionsFolder', CollectionsFolder);
    Reg.WriteString('ThumbnailsFile', ThumbnailsFile);
  finally
    Reg.Free;
  end;
end;

procedure CreateThumbnail(const Source: TBitmap; const Dest: TBitmap);
var
  Coeff_X, Coeff_Y, Coeff_Res: Single;
  Res_W, Res_H: Integer;
  Bitmap: TBitmap;
begin
  Coeff_X := Dest.Width / Source.Width;
  Coeff_Y := Dest.Height / Source.Height;
  Coeff_Res := Min(Coeff_X, Coeff_Y);
  Res_W := Round(Source.Width * Coeff_Res);
  Res_H := Round(Source.Height * Coeff_Res);
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Res_W;
    Bitmap.Height := Res_H;
    Bitmap.PixelFormat := pf24bit;

    SmoothResize(Source, Bitmap);

    Dest.Canvas.FillRect(Rect(0, 0, Dest.Width + 1, Dest.Height + 1));
    BitBlt(Dest.Canvas.Handle, (Dest.Width - Res_W) div 2, (Dest.Height - Res_H) div 2,
      Res_W, Res_H, Bitmap.Canvas.Handle, 0, 0, SRCCOPY);

  finally
    Bitmap.Free;
  end;
end;

procedure SetWallPaper(FileName: string);
var
  JpegImage: TJPEGImage;
  Bitmap: TBitmap;
  WallPaper: TBitmap;
  Reg: TRegistry;
  WallPaperName: string;
  DataFolder: string;
begin
  if not FileExists(FileName) then
    Exit;
  JpegImage := TJPEGImage.Create;
  try
    JpegImage.PixelFormat := jf24Bit;
    JpegImage.Performance := jpBestQuality;
    JpegImage.Smoothing := True;
    JpegImage.Scale := jsFullSize;
    JpegImage.LoadFromFile(FileName);
    JpegImage.DIBNeeded;

    Bitmap := TBitmap.Create;
    try
      Bitmap.PixelFormat := pf24bit;
      Bitmap.Width := JpegImage.Width;
      Bitmap.Height := JpegImage.Height;
      Bitmap.Canvas.Draw(0, 0, JpegImage);

      WallPaper := TBitmap.Create;
      try
        WallPaper.PixelFormat := pf24bit;

        if not UseCurrResolution then
          GetScreenResolution;

        if UseWorkArea then
        begin
          WallPaper.Width := Screen_W;
          WallPaper.Height := Screen_H;
        end else
        begin
          WallPaper.Width := WorkArea_W;
          WallPaper.Height := WorkArea_H;
        end;

        if StretchAnyway then
        begin
          SmoothResize(Bitmap, WallPaper);
        end else
        begin
          CreateThumbnail(Bitmap, WallPaper);
        end;

        if UseCalendar then
          CreateCalendar(WallPaper);

        DataFolder := GetSystemFolder(CSIDL_APPDATA);
        WallPaperName := DataFolder + '\WallPaper.bmp';
        WallPaper.SaveToFile(WallPaperName);

        Reg := TRegistry.Create;
        try
          Reg.RootKey := HKEY_CURRENT_USER;
          Reg.OpenKey('Control Panel\Desktop', True);
          Reg.WriteString('WallpaperStyle', '0');
          Reg.WriteString('TileWallpaper', '1');
          Reg.CloseKey;
          Reg.OpenKey(RegKey, True);
          Reg.WriteString('CurrentWallPaper', FileName);
          Reg.WriteDate('WallPaperDate', Now);

          SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, PChar(WallPaperName), SPIF_UPDATEINIFILE or SPIF_SENDWININICHANGE);

        finally
          Reg.Free;
        end;
      finally
        WallPaper.Free;
      end;
    finally
      Bitmap.Free;
    end;
  finally
    JpegImage.Free;
  end;
end;

procedure UpdateCurrentWallPaper;
var
  Reg: TRegistry;
  FileName: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\MyWallPapers', True);
    FileName := Reg.ReadString('CurrentWallPaper');
  finally
    Reg.Free;
  end;
  SetWallPaper(FileName);
end;

function ShellDeleteFile(const Handle: HWND; const FileName: string): Boolean;
var
  File_Op: TSHFileOpStruct;
begin
  File_Op.Wnd := Handle;
  File_Op.wFunc := FO_DELETE;
  File_Op.pFrom := PChar(FileName + #0);
  File_Op.pTo := nil;
  File_Op.fFlags := FOF_ALLOWUNDO;
  File_Op.fAnyOperationsAborted := False;
  File_Op.hNameMappings := nil;
  Result := (SHFileOperation(File_Op) = 0) and (not File_Op.fAnyOperationsAborted);
end;

function ShellRenameFile(const Handle: HWND; const OldName, NewName: string): Boolean;
var
  File_Op: TSHFileOpStruct;
begin
  File_Op.Wnd := Handle;
  File_Op.wFunc := FO_RENAME;
  File_Op.pFrom := PChar(OldName + #0);
  File_Op.pTo := PChar(NewName + #0);
  File_Op.fFlags := FOF_ALLOWUNDO;
  File_Op.fAnyOperationsAborted := False;
  File_Op.hNameMappings := nil;
  Result := (SHFileOperation(File_Op) = 0) and (not File_Op.fAnyOperationsAborted);
end;

function ShellCopyFile(const Handle: HWND; const OldName, NewName: string): Boolean;
var
  File_Op: TSHFileOpStruct;
begin
  File_Op.Wnd := Handle;
  File_Op.wFunc := FO_COPY;
  File_Op.pFrom := PChar(OldName + #0);
  File_Op.pTo := PChar(NewName + #0);
  File_Op.fFlags := FOF_ALLOWUNDO;
  File_Op.fAnyOperationsAborted := False;
  File_Op.hNameMappings := nil;
  Result := (SHFileOperation(File_Op) = 0) and (not File_Op.fAnyOperationsAborted);
end;

function ShellBatchCopyFiles(const Handle: HWND; const Files: TStrings; const Folder: string): Boolean;
var
  File_Op: TSHFileOpStruct;
  AllFiles: string;
  i: Integer;
begin
  AllFiles := '';
  for i := 0 to Files.Count - 1 do
    AllFiles := AllFiles + Files[i] + #0;
  File_Op.Wnd := Handle;
  File_Op.wFunc := FO_COPY;
  File_Op.pFrom := PChar(AllFiles + #0);
  File_Op.pTo := PChar(Folder + #0);
  File_Op.fFlags := FOF_ALLOWUNDO;
  File_Op.fAnyOperationsAborted := False;
  File_Op.hNameMappings := nil;
  Result := (SHFileOperation(File_Op) = 0) and (not File_Op.fAnyOperationsAborted);
end;

function ShellBatchDeleteFiles(const Handle: HWND; const Files: TStrings): Boolean;
var
  File_Op: TSHFileOpStruct;
  AllFiles: string;
  i: Integer;
begin
  AllFiles := '';
  for i := 0 to Files.Count - 1 do
    AllFiles := AllFiles + Files[i] + #0;
  File_Op.Wnd := Handle;
  File_Op.wFunc := FO_DELETE;
  File_Op.pFrom := PChar(AllFiles + #0);
  File_Op.pTo := nil;
  File_Op.fFlags := FOF_ALLOWUNDO;
  File_Op.fAnyOperationsAborted := False;
  File_Op.hNameMappings := nil;
  Result := (SHFileOperation(File_Op) = 0) and (not File_Op.fAnyOperationsAborted);
end;

procedure CreateCalendar(const Calendar: TBitmap);
var
  Caption: PChar;
  CaptionLen: Integer;
  W, H: Integer;
  i, k: Integer;
  CurrDay: TDateTime;
  U, V: Integer;
  Cell_W, Cell_H: Integer;
  Space: Integer;
  Day: string;
  Day_W, Caption_W: Integer;
  X, Y: Integer;
begin
  CaptionLen := GetDateFormat(LOCALE_USER_DEFAULT, 0, nil, PChar(CalendarCaption), nil, 0);
  GetMem(Caption, CaptionLen * SizeOf(Char));
  GetDateFormat(LOCALE_USER_DEFAULT, 0, nil, PChar(CalendarCaption), PChar(Caption), CaptionLen);

  Calendar.Canvas.Font.Assign(FontCaption);

  Space := Calendar.Canvas.TextWidth(' ');
  Caption_W := Calendar.Canvas.TextWidth(Caption);
  W := Caption_W;
  H := Calendar.Canvas.TextHeight(Caption);
  Cell_W := 0;
  Cell_H := 0;
  for i := 1 to 7 do
  begin
    Cell_W := Max(Cell_W, Calendar.Canvas.TextWidth(FormatSettings.ShortDayNames[i]));
    Cell_H := Max(Cell_H, Calendar.Canvas.TextHeight(FormatSettings.ShortDayNames[i]));
  end;
  for i := 1 to DaysInMonth(Date) do
  begin
    Cell_W := Max(Cell_W, Calendar.Canvas.TextWidth(IntToStr(i)));
    Cell_H := Max(Cell_H, Calendar.Canvas.TextHeight(IntToStr(i)));
  end;
  Cell_W := Cell_W + Space;
  Cell_H := Cell_H + Space;
  k := DayOfTheWeek(RecodeDay(Date, 1)) - 1;
  W := Max(W, (Cell_W) * 7);
  H := Max(H, (Cell_H) * (((k + DaysInMonth(Date)) div 7) + 3));

  case CalendarLayout of
    0:
    begin
      X := HorizSpace;
      Y := VertSpace;
    end;
    1:
    begin
      X := HorizSpace;
      Y := Calendar.Height - H - VertSpace;
    end;
    2:
    begin
      X := Calendar.Width - W - HorizSpace;
      Y := VertSpace;
    end;
    else
    begin
      X := Calendar.Width - W - HorizSpace;
      Y := Calendar.Height - H - VertSpace;
    end;
  end;

  SetBkMode(Calendar.Canvas.Handle, TRANSPARENT);
  //Заголовок
  Calendar.Canvas.Font.Color := ShadowColor;
  Calendar.Canvas.TextOut(X + ShadowHor + (W - Caption_W) div 2, Y + ShadowVert + 0, Caption);
  Calendar.Canvas.Font.Color := FontCaption.Color;
  Calendar.Canvas.TextOut(X + (W - Caption_W) div 2, Y, Caption);

  //Названия дней
  for i := 1 to 7 do
  begin
    Day := GetLocaleStr(GetThreadLocale, LOCALE_SABBREVDAYNAME1 + i - 1, '?');
    Day_W := Calendar.Canvas.TextWidth(Day);
    Calendar.Canvas.Font.Color := ShadowColor;
    Calendar.Canvas.TextOut(X + ShadowHor + (i - 1) * Cell_W + ((Cell_W - Day_W) div 2),
      Y + ShadowVert + Cell_H, Day);
    if i < 6 then
      Calendar.Canvas.Font.Color := FontCaption.Color
    else
      Calendar.Canvas.Font.Color := HolidayColor;
    Calendar.Canvas.TextOut(X + (i - 1) * Cell_W + ((Cell_W - Day_W) div 2), Y + Cell_H, Day);
  end;

  //Числа
  for i := 1 to DaysInMonth(Date) do
  begin
    CurrDay := RecodeDay(Date, i);
    U := (k div 7) + 1;
    V := DayOfTheWeek(CurrDay);
    Day := IntToStr(i);
    Day_W := Calendar.Canvas.TextWidth(Day);
    Calendar.Canvas.Font.Color := ShadowColor;
    Calendar.Canvas.TextOut(X + ShadowHor + (V - 1) * Cell_W + ((Cell_W - Day_W) div 2),
      Y + ShadowVert + (U + 1) * Cell_H, Day);
    if Date = CurrDay then
      Calendar.Canvas.Font.Color := CurrentDayColor
    else
    if V < 6 then
      Calendar.Canvas.Font.Color := FontCaption.Color
    else
      Calendar.Canvas.Font.Color := HolidayColor;
    Calendar.Canvas.TextOut(X + (V - 1) * Cell_W + ((Cell_W - Day_W) div 2), Y + (U + 1) * Cell_H, Day);
    k := k + 1;
  end;
  FreeMem(Caption);
end;

function GetSystemFolder(const nFolder: Integer): string;
var
  PIDL: PItemIDList;
  Path: PChar;
begin
  SHGetSpecialFolderLocation(0, nFolder, PIDL);
  GetMem(Path, MAX_PATH * SizeOf(Char));
  try
    SHGetPathFromIDList(PIDL, Path);
    Result := Path;
  finally
    FreeMem(Path);
  end;
end;

initialization
  FontCaption := TFont.Create;

finalization
  FontCaption.Free;

end.

