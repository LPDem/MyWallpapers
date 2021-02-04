unit NumericEdit;

interface

uses
  Windows, Messages, Classes, Controls, StdCtrls, Variants, SysUtils,
  EditWithButton;

type
  TNumericEdit = class(TEditWithButton)
  private
    FFormat: string;
    FMaxValue: Extended;
    FMinValue: Extended;
    FValue: Variant;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    function GetValue: Variant; virtual;
    procedure SetFormat(const NewValue: string); virtual;
    procedure SetMaxValue(const NewValue: Extended);
    procedure SetMinValue(const Value: Extended);
    procedure SetValue(const Value: Variant); virtual;
  protected
    FInnerTextChange: Boolean;
    procedure Change; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    function PrepareText(const AText: string): string; virtual;
    function TextToValue: Variant; virtual;
    procedure UpdateText; virtual;
    procedure ValidateValue; virtual;
    function ValueToText: string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Format: string read FFormat write SetFormat;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property MaxValue: Extended read FMaxValue write SetMaxValue;
    property MinValue: Extended read FMinValue write SetMinValue;
    property OEMConvert;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Value: Variant read GetValue write SetValue;
    property Visible;
  end;

procedure Register;

implementation

uses
  StrUtils;

{$R NumericEdit.dcr}

constructor TNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonVisible := False;
end;

procedure TNumericEdit.Change;
begin
  if not FInnerTextChange then
  begin
    FValue := TextToValue;
  end;
  inherited Change;  
end;

procedure TNumericEdit.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if not FInnerTextChange then
  begin
    FInnerTextChange := True;
    UpdateText;
    FInnerTextChange := False;
  end;
end;

procedure TNumericEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TNumericEdit.DoEnter;
begin
  inherited DoEnter;
  FInnerTextChange := True;
  UpdateText;
  FInnerTextChange := False;
end;

procedure TNumericEdit.DoExit;
begin
  FInnerTextChange := True;
  if Modified then
    Value := TextToValue
  else
    UpdateText;
  FInnerTextChange := False;
  inherited DoExit;
end;

function TNumericEdit.GetValue: Variant;
begin
  Result := FValue;
end;

function TNumericEdit.PrepareText(const AText: string): string;
begin
  Result := AnsiReplaceText(AText, ' ', '');
  Result := AnsiReplaceText(Result, FormatSettings.ThousandSeparator, '');
end;

procedure TNumericEdit.SetFormat(const NewValue: string);
begin
  FFormat := NewValue;
  UpdateText;
end;

procedure TNumericEdit.SetMaxValue(const NewValue: Extended);
begin
  FMaxValue := NewValue;
  ValidateValue;
  UpdateText;
end;

procedure TNumericEdit.SetMinValue(const Value: Extended);
begin
  FMinValue := Value;
  ValidateValue;
  UpdateText;
end;

procedure TNumericEdit.SetValue(const Value: Variant);
begin
  FValue := Value;
  ValidateValue;
  UpdateText;
end;

function TNumericEdit.TextToValue: Variant;
var
  s: string;
  E: Extended;
begin
  s := PrepareText(Text);
  if s = '' then
    Result := Null
  else
  begin
    if not TryStrToFloat(s, E) then
      Result := Null
    else
      Result := E;
  end;
end;

procedure TNumericEdit.UpdateText;
var
  SavedModified: Boolean;
  FText: string;
begin
  //FInnerTextChange := True;
  SavedModified := Modified;
  try
    FText := ValueToText;
    if Focused then
      FText := PrepareText(FText);
    Text := FText;
  finally
    //FInnerTextChange := False;
    Modified := SavedModified;
  end;
end;

procedure TNumericEdit.ValidateValue;
begin
  if not VarIsNull(FValue) and ((FMinValue <> 0) or (FMaxValue <> 0)) then
  begin
    if (FMinValue <> 0) and (FValue < FMinValue) then
      FValue := FMinValue
    else
    if (FMaxValue <> 0) and (FValue > FMaxValue) then
      FValue := FMaxValue;
  end;
end;

function TNumericEdit.ValueToText: string;
begin
  if VarIsNull(Value) then
    Result := ''
  else
    Result := FormatFloat(Format, Value);
end;

procedure Register;
begin
  RegisterComponents('Additional', [TNumericEdit]);
end;

end.

