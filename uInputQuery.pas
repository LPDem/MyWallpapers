unit uInputQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFmInputQuery = class(TForm)
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    Edt_Value: TEdit;
    Lbl_Prompt: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MyInputQuery(const ACaption, APrompt: string; var Value: string): Boolean;

implementation

{$R *.dfm}

function MyInputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
var
  FmInputQuery: TFmInputQuery;
begin
  FmInputQuery := TFmInputQuery.Create(Application);
  try
    FmInputQuery.Caption := ACaption;
    FmInputQuery.Lbl_Prompt.Caption := APrompt;
    FmInputQuery.Edt_Value.Text := Value;
    Result := (FmInputQuery.ShowModal = mrOk);
    if Result then
      Value := FmInputQuery.Edt_Value.Text;
  finally
    FmInputQuery.Free;
  end;
end;

end.
