program MyWallPapersTray;

uses
  Windows,
  uMainTray in 'uMainTray.pas',
  uCommon in 'uCommon.pas';

var
  MutHandle: THandle = 0;

begin
  ReportMemoryLeaksOnShutdown := True;
  UniqueAppStr := 'MyWallPapersTray.exe';
  MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, UniqueAppStr);
  if MutHandle = 0 then
  begin
    MutHandle := CreateMutex(nil, False, UniqueAppStr);
    MainStart;
  end;
end.

