unit EditWithButton;

interface

uses
  Classes, Controls, StdCtrls, Messages;

type
  TEditWithButton = class(TCustomEdit)
  private
    FAlignment: TAlignment;  
    FButton: TButton;
    FButtonEnabled: Boolean;
    FButtonVisible: Boolean;
    FOnButtonClick: TNotifyEvent;
    procedure ButtonClick(Sender: TObject);
    procedure SetAlignment(const NewValue: TAlignment); virtual;    
    procedure SetButtonEnabled(Value: Boolean);
    procedure SetButtonVisible(const Value: Boolean); virtual;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  protected
    procedure AdjustSize; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function GetButton: TButton; virtual;
    procedure UpdateMargins;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property ButtonEnabled: Boolean read FButtonEnabled write SetButtonEnabled default True;
    property ButtonVisible: Boolean read FButtonVisible write SetButtonVisible default True;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
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
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
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
    property Visible;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  procedure Register;

implementation

uses
  Windows;

{$R EditWithButton.dcr}

constructor TEditWithButton.Create(AOwner: TComponent);
begin
  inherited;
  FAlignment := taLeftJustify;
  ControlStyle := ControlStyle + [csReplicatable];
  FButtonEnabled := True;
  FButtonVisible := True;
end;

procedure TEditWithButton.AdjustSize;
begin
  inherited;
  UpdateMargins;
end;

procedure TEditWithButton.ButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Sender);
end;

procedure TEditWithButton.CreateParams(var Params: TCreateParams);
const
  Alignments: array [TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited;
  Params.Style := Params.Style or WS_CLIPCHILDREN or ES_MULTILINE;
  Params.Style := Params.Style or Alignments[Alignment];
end;

procedure TEditWithButton.CreateWnd;
begin
  inherited;
  UpdateMargins;
end;

function TEditWithButton.GetButton: TButton;
begin
  if FButtonVisible and not Assigned(FButton) and HandleAllocated then
  begin
    FButton := TButton.Create(Self);
    FButton.ControlStyle := FButton.ControlStyle + [csReplicatable, csNoDesignVisible];
    FButton.Parent := Self;
    FButton.Caption := '...';
    FButton.Top := 0;
    FButton.Height := Self.Height - 1;
    FButton.Width := FButton.Height;
    FButton.Left := Self.ClientWidth - FButton.Width;
    FButton.Anchors := [akTop, akRight];
    FButton.TabStop := False;
    FButton.OnClick := ButtonClick;
  end;
  Result := FButton;
end;

procedure TEditWithButton.SetAlignment(const NewValue: TAlignment);
begin
  if FAlignment <> NewValue then
  begin
  FAlignment := NewValue;
    RecreateWnd;
  end;
end;

procedure TEditWithButton.SetButtonEnabled(Value: Boolean);
var
  B: TButton;
begin
  FButtonEnabled := Value;
  B := GetButton;
  if Assigned(B) then
  begin
    B.Enabled := Value;
    if B.HandleAllocated and (csDesigning in B.ComponentState) then
      EnableWindow(B.Handle, B.Enabled);
  end;
end;

procedure TEditWithButton.SetButtonVisible(const Value: Boolean);
var
  B: TButton;
begin
  FButtonVisible := Value;
  if FButtonVisible or Assigned(FButton) then
  begin
    B := GetButton;
    if Assigned(B) then
      GetButton.Visible := Value;
  end;
end;

procedure TEditWithButton.UpdateMargins;
var
  R: TRect;
  L: Integer;
  B: TButton;
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;
  B := GetButton;
  if Assigned(B) then
    B.Height := ClientHeight;
  if FButtonVisible then
    L := FButton.Left
  else
    L := ClientWidth;
  SetRect(R, 0, 0, L, ClientHeight);
  SendMessage(Handle, EM_SETRECTNP, 0, Longint(@R));
end;

procedure TEditWithButton.WMMouseWheel(var Message: TWMMouseWheel);
begin
  inherited;
  if (Message.Result <> 0) and Assigned(Parent) then
  begin
    Message.Result := 0;
    Parent.WindowProc(TMessage(Message));
  end;
end;

procedure Register;
begin
  RegisterComponents('Additional', [TEditWithButton]);
end;

end.
