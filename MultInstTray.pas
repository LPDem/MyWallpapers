unit MultInst;

interface

uses Forms, Windows, Dialogs, SysUtils;

const
  MI_NO_ERROR      = 0;
  MI_FAIL_SUBCLASS = 1;
  MI_FAIL_CREATE_MUTEX = 2;

 { Проверка правильности запуска приложения с помощью описанных ниже функций. }
 { Количество флагов ошибок MI_* может быть более одного. }

function GetMIError: Integer;
function InitInstance: Boolean;

implementation

var
  UniqueAppStr: pchar;
  MessageId: Integer;
  WProc: TFNWndProc = nil;
  MutHandle: THandle = 0;
  MIError: Integer = 0;

function GetMIError: Integer;
begin
  Result := MIError;
end;

function NewWndProc(Handle: HWND; Msg: Integer; wParam, lParam: Longint): Longint; stdcall;
begin
  Result := 0;
  { Если это - сообщение о регистрации... }
  if Msg = MessageID then
  begin
    { если основная форма минимизирована, восстанавливаем ее }
    { передаем фокус приложению }
    if IsIconic(Application.Handle) then
    begin
      Application.MainForm.WindowState := wsNormal;
      ShowWindow(Application.Mainform.Handle, SW_RESTORE);
      Application.MainForm.BringToFront;
    end;
    SetForegroundWindow(Application.MainForm.Handle);
  end { В противном случае посылаем сообщение предыдущему окну }
  else
    Result := CallWindowProc(WProc, Handle, Msg, wParam, lParam);
end;

procedure SubClassApplication;
begin
  { Обязательная процедура. Необходима, чтобы обработчик }
  { Application.OnMessage был доступен для использования. }
  WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
    Longint(@NewWndProc)));
  { Если происходит ошибка, устанавливаем подходящий флаг }
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
{ Процедура вызывается, если уже имеется запущенная копия Вашей программы. }
var
  BSMRecipients: DWORD;
begin
  { Не показываем основную форму }
  Application.ShowMainForm := False;
  { Посылаем другому приложению сообщение и информируем о необходимости }
  { перевести фокус на себя }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE, @BSMRecipients, MessageID, 0, 0);
end;

function InitInstance: Boolean;
begin
  MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, UniqueAppStr);
  if MutHandle = 0 then
  begin
    { Объект Mutex еще не создан, означая, что еще не создано }
    { другое приложение. }
    DoFirstInstance;
    Result := True;
  end else
  begin
    BroadcastFocusMessage;
    Result := False;
  end;
end;

initialization
  begin
    UniqueAppStr := 'LevelEditor.exe';
    MessageID := RegisterWindowMessage(UniqueAppStr);
  end;

finalization
  begin
    if WProc <> nil then
      { Приводим приложение в исходное состояние }
      SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(WProc));
  end;
end.

