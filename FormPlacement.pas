unit FormPlacement;

interface

uses
  Windows, Forms;

procedure InitFormPlacement(const RegKey: string);
procedure LoadFormPlacement(const Form: TForm);
procedure SaveFormPlacement(const Form: TForm);
function LoadFormValue(const Form: TForm; const ValueName: string; const Default: Variant): Variant;
procedure SaveFormValue(const Form: TForm; const ValueName: string; const Value: Variant);

implementation

uses
  Registry, Variants;

var
  FormPlacementRegKey: string = '';

procedure InitFormPlacement(const RegKey: string);
begin
  FormPlacementRegKey := RegKey;
end;  

function CheckFormPlacement: Boolean;
begin
  Result := (FormPlacementRegKey <> '');
  if not Result then
    MessageBox(Application.Handle, 'Form placement engine is not initialized!', 'Ошибка', MB_ICONWARNING or MB_OK);
end;

procedure LoadFormPlacement(const Form: TForm);
var
  Reg: TRegistry;
  X, Y, W, H: Integer;
  S: TWindowState;
begin
  if not CheckFormPlacement then
    Exit;
  W := Form.Width;
  H := Form.Height;
  S := Form.WindowState;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(FormPlacementRegKey) then
    begin
      Reg.OpenKey(FormPlacementRegKey + '\' + Form.Name, False);
      if Reg.ValueExists('Width') then
        W := Reg.ReadInteger('Width');
      if Reg.ValueExists('Height') then
        H := Reg.ReadInteger('Height');
      if Reg.ValueExists('State') then
        S := TWindowState(Reg.ReadInteger('State'));
    end;
    X := ((Screen.WorkAreaWidth div 2) + Screen.WorkAreaLeft - (W div 2));
    Y := ((Screen.WorkAreaHeight div 2) + Screen.WorkAreaTop - (H div 2));
    if X < Screen.WorkAreaLeft then
      X := Screen.WorkAreaLeft;
    if Y < Screen.WorkAreaTop then
      Y := Screen.WorkAreaTop;
    Form.SetBounds(X, Y, W, H);
    Form.WindowState := S;
  finally
    Reg.Free;
  end;
end;

procedure SaveFormPlacement(const Form: TForm);
var
  Reg: TRegistry;
  WP: TWindowPlacement;
begin
  if not CheckFormPlacement then
    Exit;
  WP.length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Form.Handle, @WP);
  if Form.WindowState = wsMinimized then
  begin
    if WP.flags = WPF_RESTORETOMAXIMIZED then
      Form.WindowState := wsMaximized
    else
      Form.WindowState := wsNormal;
  end;
  Reg := TRegistry.Create(KEY_WRITE + KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(FormPlacementRegKey + '\' + Form.Name, True);
    Reg.WriteInteger('Width', WP.rcNormalPosition.Right - WP.rcNormalPosition.Left);
    Reg.WriteInteger('Height', WP.rcNormalPosition.Bottom - WP.rcNormalPosition.Top);
    Reg.WriteInteger('State', Integer(Form.WindowState));
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function LoadFormValue(const Form: TForm; const ValueName: string; const Default: Variant): Variant;
var
  Reg: TRegistry;
begin
  if not CheckFormPlacement then
    Exit;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.KeyExists(FormPlacementRegKey) then
    begin
      Reg.OpenKey(FormPlacementRegKey + '\' + Form.Name, False);
      if Reg.ValueExists(ValueName) then
      case VarType(Default) of
        varInteger, varSmallint, varShortInt,
        varByte, varWord, varLongWord,
        varInt64, varUInt64: Result := Reg.ReadInteger(ValueName);
      else
        Result := Reg.ReadString(ValueName);
      end else
        Result := Default;
    end else
      Result := Default;
  finally
    Reg.Free;
  end;
end;

procedure SaveFormValue(const Form: TForm; const ValueName: string; const Value: Variant);
var
  Reg: TRegistry;
begin
  if not CheckFormPlacement then
    Exit;
  Reg := TRegistry.Create(KEY_WRITE + KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(FormPlacementRegKey + '\' + Form.Name, True);
    case VarType(Value) of
      varInteger: Reg.WriteInteger(ValueName, Value);
    else
      Reg.WriteString(ValueName, VarToStr(Value));
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

end.
