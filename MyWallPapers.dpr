// JCL_DEBUG_EXPERT_INSERTJDBG OFF
program MyWallPapers;

uses
  Forms,
  uMain in 'uMain.pas' {FmMain},
  uCommon in 'uCommon.pas',
  Resample in 'Resample.pas',
  Thumbnails in 'Thumbnails.pas',
  uInputQuery in 'uInputQuery.pas' {FmInputQuery},
  uSettings in 'uSettings.pas' {FmSettings},
  uMisc in 'uMisc.pas',
  MultInst in 'MultInst.pas',
  FormPlacement in 'FormPlacement.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  if InitInstance then
  begin
    Application.Initialize;
    Application.Title := 'Мои заставки';
    Application.HintHidePause := 15000;
    Application.CreateForm(TFmMain, FmMain);
    Application.Run;
  end;
end.

