unit uMisc;

interface

function SelectFolder(const Caption: string; const Root: WideString; var Directory: string): Boolean;

implementation

uses
  Windows, ShlObj, ActiveX, SysUtils, Forms;

type
  TSelectFolderProc = function(const Caption: string; const Root: WideString; var Directory: string): Boolean of object;

function SelectDirCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  Result := 0;
end;

function SelectFolder(const Caption: string; const Root: WideString; var Directory: string): Boolean;
var
  BrInfo: TBrowseInfo;
  ShellMalloc: IMalloc;
  Buffer: PChar;
  RootItemIDList: PItemIDList;
  IDesktopFolder: IShellFolder;
  Eaten: LongWord;
  Flags: LongWord;
  WindowList: Pointer;
  OldErrorMode: Cardinal;
  IDList: PItemIDList;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrInfo, SizeOf(BrInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE or BIF_VALIDATE;
        if Directory <> '' then
        begin
          lpfn := SelectDirCallBack;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        IDList := ShBrowseForFolder(BrInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result := IDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(IDList, Buffer);
        ShellMalloc.Free(IDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

end.
