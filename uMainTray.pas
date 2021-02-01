unit uMainTray;

interface

{$R MyWallPapersTray.res}

uses
  Classes, Windows, Messages, SysUtils, ShellAPI;

const
  WM_CALLBACKMESSAGE = WM_USER + 1;

var
  UniqueAppStr: PChar;
  hMainWnd: HWND;
  // ComCtl32: HMODULE;
  WinName: PChar;
  PopupMenu: HMENU;
  MyExeName: string;
  Curr_Dir: string;
  MainTimer: Cardinal;
  MessageID: DWord;
  RM_TaskBarCreated: DWord;
  NotifyIconData: TNOTIFYICONDATA;

  Pictures: TStringList;

procedure MainStart;
function WindowFunc(hMainWnd: HWND; iMsg: DWord; wParam: wParam; lParam: lParam): LRESULT; stdcall;
procedure StartMyWallPapersGUI;
procedure SetShortCut;
procedure SetNewWallPaper;
procedure CheckObsoleteWallPaper;
procedure SetMainTimer;
procedure TimerProc(HWND: HWND; uMsg, idEvent: Cardinal; dwTime: DWord); stdcall;
procedure ReloadAllSettings;

implementation

uses uCommon, Registry, DateUtils, System.IOUtils;

procedure MainStart;
var
  wcl: TWNDCLASS;
  msg: TMSG;
begin
  MyExeName := ExtractFileName(ParamStr(0));
  Curr_Dir := ExtractFilePath(ParamStr(0));
  // ComCtl32 := LoadLibrary('ComCtl32.dll');
  try
    Randomize;
    WinName := 'MyWallPapersTrayClass';
    wcl.hInstance := hInstance;
    wcl.lpszClassName := WinName;
    wcl.lpfnWndProc := @WindowFunc;
    wcl.style := 0;
    wcl.hIcon := LoadIcon(hInstance, 'MAINICON');
    wcl.hCursor := LoadCursor(0, IDC_ARROW);
    wcl.lpszMenuName := nil;
    wcl.cbClsExtra := 0;
    wcl.cbWndExtra := 0;
    wcl.hbrBackground := COLOR_WINDOW;
    RegisterClass(wcl);
    try
      hMainWnd := CreateWindow(WinName, 'My WallPapers Tray', WS_OVERLAPPEDWINDOW, 0, 0, 200, 200, 0, 0, hInstance, nil);
      ShowWindow(hMainWnd, SW_HIDE);
      UpdateWindow(hMainWnd);

      ReloadAllSettings;

      MessageID := RegisterWindowMessage(UniqueAppStr);
      RM_TaskBarCreated := RegisterWindowMessage('TaskbarCreated');

      ZeroMemory(@NotifyIconData, SizeOf(NotifyIconData));
      NotifyIconData.cbSize := SizeOf(TNOTIFYICONDATA);
      NotifyIconData.Wnd := hMainWnd;
      NotifyIconData.uID := 0;
      NotifyIconData.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
      NotifyIconData.hIcon := wcl.hIcon;
      NotifyIconData.uCallbackMessage := WM_CALLBACKMESSAGE;
      NotifyIconData.szTip := 'Мои заставки';
      Shell_NotifyIcon(NIM_ADD, @NotifyIconData);

      PopupMenu := CreatePopupMenu;
      InsertMenu(PopupMenu, $FFFFFFFF, MF_BYPOSITION or MF_STRING, 0, 'Выгрузить');

      while (GetMessage(msg, 0, 0, 0)) do
      begin
        TranslateMessage(msg);
        DispatchMessage(msg);
      end;

      Shell_NotifyIcon(NIM_DELETE, @NotifyIconData);
      DestroyMenu(PopupMenu);
    finally
      UnregisterClass(WinName, hInstance);
    end;
  finally
    // FreeLibrary(ComCtl32);
  end;
end;

function WindowFunc(hMainWnd: HWND; iMsg: DWord; wParam: wParam; lParam: lParam): LRESULT; stdcall;
var
  CursorPos: TPoint;
begin
  Result := 0;
  case iMsg of
    WM_DESTROY:
      PostQuitMessage(0);
    WM_HOTKEY:
      begin
        if wParam = 1 then
        begin
          SetNewWallPaper;
          SetMainTimer;
        end;
      end;
    WM_COMMAND:
      PostQuitMessage(0);
    WM_CALLBACKMESSAGE:
      begin
        if lParam = WM_LBUTTONUP then
        begin
          StartMyWallPapersGUI;
        end
        else
          if lParam = WM_RBUTTONUP then
          begin
            GetCursorPos(CursorPos);
            SetForegroundWindow(hMainWnd);
            TrackPopupMenu(PopupMenu, TPM_RIGHTALIGN or TPM_LEFTBUTTON, CursorPos.X, CursorPos.Y, 0, hMainWnd, nil);
            PostMessage(hMainWnd, WM_NULL, 0, 0);
          end;
      end;
  else
    if iMsg = RM_TaskBarCreated then
      Shell_NotifyIcon(NIM_ADD, @NotifyIconData)
    else
      if iMsg = MessageID then
      begin
        if wParam = 0 then
          ReloadAllSettings
        else
          PostQuitMessage(0);
      end
      else
        Result := DefWindowProc(hMainWnd, iMsg, wParam, lParam);
  end;
end;

procedure StartMyWallPapersGUI;
var
  STARTUPINFO: _STARTUPINFOW;
  ProcInfo: _PROCESS_INFORMATION;
begin
  STARTUPINFO.cb := SizeOf(STARTUPINFO);
  ZeroMemory(@STARTUPINFO, STARTUPINFO.cb);
  if CreateProcess(nil, PChar(Curr_Dir + 'MyWallPapers.exe'), nil, nil, False, 0, nil, PChar(Curr_Dir), STARTUPINFO, ProcInfo) = False then
    MessageBox(hMainWnd, PChar('Не удалось найти файл ' + Curr_Dir + 'MyWallPapers.exe'), PChar(MyExeName), MB_OK + MB_ICONWARNING);
end;

procedure SetShortCut;
var
  Key: Cardinal;
begin
  UnregisterHotKey(hMainWnd, 1);
  Key := HotKey and not(scShift + scCtrl + scAlt);
  if not RegisterHotKey(hMainWnd, 1, MOD_CONTROL or MOD_SHIFT, Key) then
    MessageBox(hMainWnd, 'Указанная комбинация клавиш уже занята!', PChar(MyExeName), MB_OK + MB_ICONWARNING);
end;

procedure SetNewWallPaper;
var
  i: Integer;
  Collections: TStringList;
  Reg: TRegistry;
  WallPaper: string;
  FileName: string;
begin
  SetCursor(LoadCursor(0, IDC_APPSTARTING));
  try
    Collections := TStringList.Create;
    Pictures := TStringList.Create;
    try
      Reg := TRegistry.Create;
      try
        Reg.RootKey := HKEY_CURRENT_USER;
        Reg.OpenKey('Software\MyWallPapers\Used Collections', True);
        Reg.GetValueNames(Collections);
        for i := 0 to Collections.Count - 1 do
        begin
          for FileName in TDirectory.GetFiles(CollectionsFolder + '\' + Collections[i], '*.jpg') do
            Pictures.Add(FileName);
        end;
      finally
        Reg.Free;
      end;
      if Pictures.Count = 0 then
        Exit;
      i := Random(Pictures.Count);
      WallPaper := Pictures[i];
    finally
      Pictures.Free;
      Collections.Free;
    end;
    SetWallPaper(WallPaper);
  finally
    SetCursor(LoadCursor(0, IDC_ARROW));
  end;
end;

procedure CheckObsoleteWallPaper;
var
  Reg: TRegistry;
  WP_Date: TDateTime;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if not Reg.OpenKey('Software\MyWallPapers', False) then
      Exit;
    try
      WP_Date := Reg.ReadDate('WallPaperDate');
    except
      WP_Date := 0;
    end;
  finally
    Reg.Free;
  end;

  if MinutesBetween(Now, WP_Date) > AutoChangePeriod then
    SetNewWallPaper
  else
    if Int(WP_Date) <> Date then
      UpdateCurrentWallPaper;
end;

procedure SetMainTimer;
var
  Period: Cardinal;
begin
  if MainTimer <> 0 then
  begin
    KillTimer(hMainWnd, 1);
    MainTimer := 0;
  end;
  if AutoChangePeriod > 0 then
  begin
    Period := AutoChangePeriod * 60 * 1000;
    MainTimer := SetTimer(hMainWnd, 1, Period, @TimerProc);
  end;
end;

procedure TimerProc(HWND: HWND; uMsg, idEvent: Cardinal; dwTime: DWord); stdcall;
begin
  SetNewWallPaper;
end;

procedure ReloadAllSettings;
begin
  LoadSettings;
  CheckObsoleteWallPaper;
  SetMainTimer;
  SetShortCut;
end;

end.
