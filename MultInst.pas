unit MultInst;

interface

uses Forms, Windows, Dialogs, SysUtils;

const
  MI_NO_ERROR = 0;
  MI_FAIL_SUBCLASS = 1;
  MI_FAIL_CREATE_MUTEX = 2;

  { �������� ������������ ������� ���������� � ������� ��������� ���� �������. }
  { ���������� ������ ������ MI_* ����� ���� ����� ������. }

function GetMIError: Integer;
function InitInstance: Boolean;

implementation

var
  UniqueAppStr: PChar;
  MessageId: Cardinal;
  WProc: TFNWndProc = nil;
  MutHandle: THandle = 0;
  MIError: Integer = 0;

function GetMIError: Integer;
begin
  Result := MIError;
end;

function NewWndProc(Handle: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): Longint; stdcall;
begin
  Result := 0;
  { ���� ��� - ��������� � �����������... }
  if Msg = MessageId then
  begin
    { ���� �������� ����� ��������������, ��������������� �� }
    { �������� ����� ���������� }
    if IsIconic(Application.Handle) then
    begin
      Application.MainForm.WindowState := wsNormal;
      ShowWindow(Application.MainForm.Handle, SW_RESTORE);
    end;
    SetForegroundWindow(Application.MainForm.Handle);
    Application.MainForm.BringToFront;
  end { � ��������� ������ �������� ��������� ����������� ���� }
  else
    Result := CallWindowProc(WProc, Handle, Msg, wParam, lParam);
end;

procedure SubClassApplication;
begin
  { ������������ ���������. ����������, ����� ���������� }
  { Application.OnMessage ��� �������� ��� �������������. }
  WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC, Longint(@NewWndProc)));
  { ���� ���������� ������, ������������� ���������� ���� }
  if WProc = nil then
    MIError := MIError or MI_FAIL_SUBCLASS;
end;

procedure DoFirstInstance;
begin
  SubClassApplication;
  MutHandle := CreateMutex(nil, False, UniqueAppStr);
  if MutHandle = 0 then
    MIError := MIError or MI_FAIL_CREATE_MUTEX;
end;

procedure BroadcastFocusMessage;
{ ��������� ����������, ���� ��� ������� ���������� ����� ����� ���������. }
var
  BSMRecipients: DWORD;
begin
  { �� ���������� �������� ����� }
  Application.ShowMainForm := False;
  { �������� ������� ���������� ��������� � ����������� � ������������� }
  { ��������� ����� �� ���� }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE, @BSMRecipients, MessageId, 0, 0);
end;

function InitInstance: Boolean;
begin
  MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, UniqueAppStr);
  if MutHandle = 0 then
  begin
    { ������ Mutex ��� �� ������, �������, ��� ��� �� ������� }
    { ������ ����������. }
    DoFirstInstance;
    Result := True;
  end
  else
  begin
    BroadcastFocusMessage;
    Result := False;
  end;
end;

initialization

begin
  UniqueAppStr := 'MyWallPapers.exe';
  MessageId := RegisterWindowMessage(UniqueAppStr);
end;

finalization

begin
  if WProc <> nil then
    { �������� ���������� � �������� ��������� }
    SetWindowLong(Application.Handle, GWL_WNDPROC, Longint(WProc));
end;

end.
