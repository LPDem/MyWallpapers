unit XPListView;

interface

uses
  SysUtils, Classes, Controls, ComCtrls, Messages;

type
  TXPListView = class(TListView)
  private
    { Private declarations }
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  end;

procedure Register;

implementation

{$R XPListView.res}

{ TXPListView }

procedure TXPListView.WMVScroll(var Message: TWMVScroll);
begin
  DefaultHandler(Message);
end;

procedure Register;
begin
  RegisterComponents('Win32', [TXPListView]);
end;

end.
