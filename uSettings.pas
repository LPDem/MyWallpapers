unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, EditWithButton, NumericEdit;

type
  TFmSettings = class(TForm)
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    PG_Settings: TPageControl;
    TS_WallPapers: TTabSheet;
    TS_Calendar: TTabSheet;
    TS_Other: TTabSheet;
    Cb_ShowInTray: TCheckBox;
    Edt_HotKey: THotKey;
    Label1: TLabel;
    Cb_StretchAnyway: TCheckBox;
    Cb_UseWorkArea: TCheckBox;
    Label2: TLabel;
    Edt_Time: TNumericEdit;
    Label3: TLabel;
    Edt_Layout: TRadioGroup;
    Label4: TLabel;
    Edt_Hor_Space: TNumericEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edt_Vert_Space: TNumericEdit;
    Label7: TLabel;
    Cb_Use_Calendar: TCheckBox;
    Edt_Caption: TLabeledEdit;
    FD_Calendar: TFontDialog;
    CD_Calendar: TColorDialog;
    GroupBox1: TGroupBox;
    Pnl_FontCaptionColor: TPanel;
    Label8: TLabel;
    Btn_FontCaption: TButton;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Pnl_FontShadowColor: TPanel;
    Edt_Shadow_Hor: TNumericEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edt_Shadow_Vert: TNumericEdit;
    Label13: TLabel;
    Label14: TLabel;
    Edt_CollectionsFolder: TEdit;
    Btn_CollectionsFolder: TButton;
    Cb_UseCurrResolution: TCheckBox;
    Edt_ThumbnailsFile: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Pnl_FontHolidayColor: TPanel;
    Label17: TLabel;
    Pnl_FontCurrentDayColor: TPanel;
    procedure Edt_TimeKeyPress(Sender: TObject; var Key: Char);
    procedure Btn_FontCaptionClick(Sender: TObject);
    procedure Pnl_FontCaptionColorClick(Sender: TObject);
    procedure Pnl_FontShadowColorClick(Sender: TObject);
    procedure Btn_CollectionsFolderClick(Sender: TObject);
    procedure Pnl_FontHolidayColorClick(Sender: TObject);
    procedure Pnl_FontCurrentDayColorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function EditSettings: Boolean;
  end;

implementation

uses uCommon, uMain, uMisc, FormPlacement;

{$R *.dfm}

class function TFmSettings.EditSettings: Boolean;
var
  FmSettings: TFmSettings;
begin
  FmSettings := Self.Create(Application);
  try
    //Обои
    FmSettings.Cb_ShowInTray.Checked := ShowInTray;
    FmSettings.Cb_StretchAnyway.Checked := StretchAnyway;
    FmSettings.Cb_UseWorkArea.Checked := UseWorkArea;
    FmSettings.Edt_HotKey.HotKey := HotKey;
    FmSettings.Edt_Time.Text := IntToStr(AutoChangePeriod);
    FmSettings.Cb_UseCurrResolution.Checked := UseCurrResolution;
    //Календарь
    FmSettings.Cb_Use_Calendar.Checked := UseCalendar;
    FmSettings.Edt_Layout.ItemIndex := CalendarLayout;
    FmSettings.Edt_Hor_Space.Text := IntToStr(HorizSpace);
    FmSettings.Edt_Vert_Space.Text := IntToStr(VertSpace);
    FmSettings.Edt_Caption.Text := CalendarCaption;
    FmSettings.FD_Calendar.Font.Assign(FontCaption);
    FmSettings.Pnl_FontCaptionColor.Color := FontCaption.Color;
    FmSettings.Pnl_FontShadowColor.Color := ShadowColor;
    FmSettings.Edt_Shadow_Hor.Text := IntToStr(ShadowHor);
    FmSettings.Edt_Shadow_Vert.Text := IntToStr(ShadowVert);
    FmSettings.Pnl_FontHolidayColor.Color := HolidayColor;
    FmSettings.Pnl_FontCurrentDayColor.Color := CurrentDayColor;
    //Другое
    FmSettings.Edt_CollectionsFolder.Text := CollectionsFolder;
    FmSettings.Edt_CollectionsFolder.Hint := CollectionsFolder;
    FmSettings.Edt_ThumbnailsFile.Text := ThumbnailsFile;

    Result := (FmSettings.ShowModal = mrOK);
    if Result then
    begin
      //Обои
      ShowInTray := FmSettings.Cb_ShowInTray.Checked;
      StretchAnyway := FmSettings.Cb_StretchAnyway.Checked;
      UseWorkArea := FmSettings.Cb_UseWorkArea.Checked;
      HotKey := FmSettings.Edt_HotKey.HotKey;
      AutoChangePeriod := StrToInt(FmSettings.Edt_Time.Text);
      UseCurrResolution := FmSettings.Cb_UseCurrResolution.Checked;
      //Календарь
      UseCalendar := FmSettings.Cb_Use_Calendar.Checked;
      CalendarLayout := FmSettings.Edt_Layout.ItemIndex;
      HorizSpace := StrToInt(FmSettings.Edt_Hor_Space.Text);
      VertSpace := StrToInt(FmSettings.Edt_Vert_Space.Text);
      CalendarCaption := FmSettings.Edt_Caption.Text;
      FontCaption.Assign(FmSettings.FD_Calendar.Font);
      ShadowColor := FmSettings.Pnl_FontShadowColor.Color;
      ShadowHor := StrToInt(FmSettings.Edt_Shadow_Hor.Text);
      ShadowVert := StrToInt(FmSettings.Edt_Shadow_Vert.Text);
      HolidayColor := FmSettings.Pnl_FontHolidayColor.Color;
      CurrentDayColor := FmSettings.Pnl_FontCurrentDayColor.Color;
      //Другое
      if CollectionsFolder <> FmSettings.Edt_CollectionsFolder.Text then
      begin
        CollectionsFolder := FmSettings.Edt_CollectionsFolder.Text;
        FmMain.FillCollectionsList(CollectionsFolder);
        FmMain.Clb_Collections.ItemIndex := 0;
        FmMain.FillCollection;
      end;
      ThumbnailsFile := FmSettings.Edt_ThumbnailsFile.Text;

      SaveSettings;
    end;
  finally
    FmSettings.Free;
  end;
end;

procedure TFmSettings.Edt_TimeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key < '0') or (Key > '9') then
    Key := #0;
end;

procedure TFmSettings.FormCreate(Sender: TObject);
begin
  //LoadFormPlacement(Self);
  PG_Settings.TabIndex := LoadFormValue(Self, 'PG_Settings_TabIndex', 0);
end;

procedure TFmSettings.FormDestroy(Sender: TObject);
begin
  //SaveFormPlacement(Self);
  SaveFormValue(Self, 'PG_Settings_TabIndex', PG_Settings.TabIndex);
end;

procedure TFmSettings.Btn_FontCaptionClick(Sender: TObject);
begin
  FD_Calendar.Execute;
end;

procedure TFmSettings.Pnl_FontCaptionColorClick(Sender: TObject);
begin
  CD_Calendar.Color := Pnl_FontCaptionColor.Color;
  if CD_Calendar.Execute then
  begin
    Pnl_FontCaptionColor.Color := CD_Calendar.Color;
    FD_Calendar.Font.Color := CD_Calendar.Color;
  end;
end;

procedure TFmSettings.Pnl_FontCurrentDayColorClick(Sender: TObject);
begin
  CD_Calendar.Color := Pnl_FontCurrentDayColor.Color;
  if CD_Calendar.Execute then
    Pnl_FontCurrentDayColor.Color := CD_Calendar.Color;
end;

procedure TFmSettings.Pnl_FontHolidayColorClick(Sender: TObject);
begin
  CD_Calendar.Color := Pnl_FontHolidayColor.Color;
  if CD_Calendar.Execute then
    Pnl_FontHolidayColor.Color := CD_Calendar.Color;
end;

procedure TFmSettings.Pnl_FontShadowColorClick(Sender: TObject);
begin
  CD_Calendar.Color := Pnl_FontShadowColor.Color;
  if CD_Calendar.Execute then
    Pnl_FontShadowColor.Color := CD_Calendar.Color;
end;

procedure TFmSettings.Btn_CollectionsFolderClick(Sender: TObject);
var
  s: string;
begin
  s := Edt_CollectionsFolder.Text;
  if SelectFolder('Выбор папки с коллекциями', '', s) and (s <> '') then
  begin
    Edt_CollectionsFolder.Text := s;
    Edt_CollectionsFolder.Hint := s;
  end;
end;

end.
