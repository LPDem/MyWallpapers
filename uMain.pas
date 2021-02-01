unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, ImgList,
  ExtCtrls, Jpeg, Menus, ActnList, ExtDlgs, ExtActns, XPListView, System.Actions;

type
  TFmMain = class(TForm)
    Images: TImageList;
    Pnl_Collections: TPanel;
    Clb_Collections: TCheckListBox;
    Splitter1: TSplitter;
    Pnl_Right: TPanel;
    Pnl_Pictures: TPanel;
    LV_Pictures: TXPListView;
    Pnl_Preview: TPanel;
    Img_Preview: TImage;
    Splitter2: TSplitter;
    Pbar_Progress: TProgressBar;
    Btn_SetWallPaper: TButton;
    Menu_Collections: TPopupMenu;
    MI_AddCollection: TMenuItem;
    MI_RenameCollection: TMenuItem;
    MI_DeleteCollection: TMenuItem;
    Menu_Pictures: TPopupMenu;
    ActionList: TActionList;
    ai_AddCollection: TAction;
    ai_RenameCollection: TAction;
    ai_DeleteCollection: TAction;
    ai_InsertPicture: TAction;
    ai_EditPicture: TAction;
    ai_DeletePicture: TAction;
    MI_AddPicture: TMenuItem;
    MI_EditPicture: TMenuItem;
    MI_DeletePicture: TMenuItem;
    OPD: TOpenPictureDialog;
    Btn_Settings: TButton;
    Bevel_Right: TBevel;
    Bevel_Top: TBevel;
    Edt_Descr: TEdit;
    ai_SetPicture: TAction;
    N1: TMenuItem;
    ai_OpenPicture: TAction;
    N2: TMenuItem;
    ai_UpdateThumbnail: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    ai_SelectAllPictures: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Clb_CollectionsClickCheck(Sender: TObject);
    procedure Clb_CollectionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LV_PicturesClick(Sender: TObject);
    procedure Pnl_PreviewResize(Sender: TObject);
    procedure Btn_SetWallPaperClick(Sender: TObject);
    procedure LV_PicturesEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure MI_RenameCollectionClick(Sender: TObject);
    procedure MI_AddCollectionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MI_DeleteCollectionClick(Sender: TObject);
    procedure ai_RenameCollectionUpdate(Sender: TObject);
    procedure ai_DeleteCollectionUpdate(Sender: TObject);
    procedure ai_EditPictureUpdate(Sender: TObject);
    procedure ai_DeletePictureUpdate(Sender: TObject);
    procedure ai_EditPictureExecute(Sender: TObject);
    procedure ai_InsertPictureUpdate(Sender: TObject);
    procedure MI_DeletePictureClick(Sender: TObject);
    procedure ai_InsertPictureExecute(Sender: TObject);
    procedure Btn_SettingsClick(Sender: TObject);
    procedure ai_SetPictureUpdate(Sender: TObject);
    procedure ai_OpenPictureUpdate(Sender: TObject);
    procedure ai_OpenPictureExecute(Sender: TObject);
    procedure ai_UpdateThumbnailExecute(Sender: TObject);
    procedure ai_UpdateThumbnailUpdate(Sender: TObject);
    procedure ai_SelectAllPicturesExecute(Sender: TObject);
    procedure LV_PicturesEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure NormalizePictureName(var FileName: string);
    procedure LV_PicturesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  private
    { Private declarations }
    ai_SetPicture_ShortCut: TShortCut;
    Pictures: TStringList;
    Folder: string;
    Preview_Bitmap: TBitmap;
    procedure ClearPreview;
  public
    { Public declarations }
    procedure FillCollectionsList(const Folder: string);
    procedure FillCollection;
    procedure LoadCollectionSettings;
    procedure SaveCollectionSettings;
    procedure NotifyTrayApp;
    procedure CloseTrayApp;
    function GetAutorunFolder: string;
    procedure StartMyWallPapersTray;
    procedure OpenPictureForEdit(FileName: string);
  end;

var
  FmMain: TFmMain;
  TrayMessageID: Integer;

procedure SetShortCut(Path, Cmd, Icon, WorkFolder, Name, Arg: string);

implementation

uses
  uCommon, Thumbnails, Resample, ShellAPI, Math, uInputQuery,
  uSettings, Registry, ActiveX, ShlObj, ComObj, System.IOUtils, FormPlacement;

{$R *.dfm}

procedure TFmMain.FillCollectionsList(const Folder: string);
var
  FolderName: string;
begin
  Clb_Collections.Items.BeginUpdate;
  Clb_Collections.Items.Clear;
  try
    for FolderName in TDirectory.GetDirectories(Folder, '*.*') do
      Clb_Collections.Items.Add(ExtractFileName(FolderName));
  finally
    Clb_Collections.Items.EndUpdate;
  end;
  LoadCollectionSettings;
end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
  InitFormPlacement(RegKey);
  Caption := Application.Title;
  Edt_Descr.Text := '';
  Preview_Bitmap := TBitmap.Create;
  Preview_Bitmap.PixelFormat := pf24bit;
  Images.Width := Thumb_Width;
  Images.Height := Thumb_Height;
  Pictures := TStringList.Create;
  Pictures.NameValueSeparator := '=';
  LoadSettings;
  FillCollectionsList(CollectionsFolder);
  TrayMessageID := RegisterWindowMessage('MyWallPapersTray.exe');
  LoadFormPlacement(Self);
  Pnl_Collections.Width := LoadFormValue(Self, 'Pnl_Collections_Width', Pnl_Collections.Width);
  Pnl_Preview.Height := LoadFormValue(Self, 'Pnl_Preview_Height', Pnl_Preview.Height);
  Clb_Collections.ItemIndex := LoadFormValue(Self, 'ActiveCollection', -1);
  Clb_CollectionsClick(Self);
end;

procedure TFmMain.LoadCollectionSettings;
var
  Reg: TRegistry;
  i: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\MyWallPapers\Used Collections', True);
    for i := 0 to Clb_Collections.Count - 1 do
      Clb_Collections.Checked[i] := Reg.ValueExists(Clb_Collections.Items[i]);
  finally
    Reg.Free;
  end;
end;

procedure TFmMain.SaveCollectionSettings;
var
  Reg: TRegistry;
  i: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.DeleteKey('Software\MyWallPapers\Used Collections');
    Reg.OpenKey('Software\MyWallPapers\Used Collections', True);
    for i := 0 to Clb_Collections.Count - 1 do
      if Clb_Collections.Checked[i] then
        Reg.WriteBool(Clb_Collections.Items[i], True) else
        Reg.DeleteValue(Clb_Collections.Items[i]);
  finally
    Reg.Free;
  end;
end;

procedure TFmMain.Clb_CollectionsClickCheck(Sender: TObject);
begin
  SaveCollectionSettings;
end;

procedure TFmMain.FillCollection;
var
  i: Integer;
  L_Item: TListItem;
  Thumbnail: TBitmap;
  Thumbnails: TThumbnails;
  FileName: string;
begin
  ClearPreview;
  Edt_Descr.Text := '';
  try
    Screen.Cursor := crHourGlass;
    Pictures.Clear;

    for FileName in TDirectory.GetFiles(CollectionsFolder + '\' + Folder, '*.jpg') do
      Pictures.Add(FileName + '=' + ExtractFileName(FileName));

    if Pictures.Count = 0 then
    begin
      LV_Pictures.Items.Clear;
      Images.Clear;
      Exit;
    end;

    Thumbnail := TBitmap.Create;
    Thumbnails := TThumbnails.Create(CollectionsFolder + '\' + Folder + '\' + ThumbnailsFile);
    try
      Thumbnail.Width := Images.Width;
      Thumbnail.Height := Images.Height;
      Thumbnail.PixelFormat := pf24bit;
      Thumbnail.Transparent := False;
      Thumbnail.Canvas.Brush.Color := clWhite;
      LV_Pictures.Items.BeginUpdate;
      LV_Pictures.Items.Clear;
      Images.Clear;
      Images.AllocBy := Pictures.Count;
      Pbar_Progress.Max := Pictures.Count - 1;
      Pbar_Progress.Position := 0;
      Pbar_Progress.Visible := True;
      for i := 0 to Pictures.Count - 1 do
      begin
        L_Item := LV_Pictures.Items.Add;
        L_Item.Caption := Pictures.ValueFromIndex[i];

        Thumbnails.GetThumbnail(Thumbnail, ExtractFileName(Pictures.Names[i]));

        Images.Add(Thumbnail, nil);
        L_Item.ImageIndex := i;

        Pbar_Progress.StepIt;
      end;

      LV_Pictures.Items.EndUpdate;
    finally
      Thumbnail.Free;
      Thumbnails.Free;
      Pbar_Progress.Visible := False;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFmMain.Clb_CollectionsClick(Sender: TObject);
var
  k: Integer;
begin
  k := Clb_Collections.ItemIndex;
  if k = -1 then
    Exit;
  Folder := Clb_Collections.Items[k];
  FillCollection;
end;

procedure TFmMain.FormDestroy(Sender: TObject);
begin
  Preview_Bitmap.Free;
  Pictures.Free;
end;

procedure TFmMain.LV_PicturesClick(Sender: TObject);
var
  k: Integer;
  FileName: string;
  Jpg_Preview: TJPEGImage;
  F: TFileStream;
begin
  k := LV_Pictures.ItemIndex;
  if k <> -1 then
  begin
    Screen.Cursor := crHourGlass;
    try
      FileName := CollectionsFolder + '\' + Folder + '\' + LV_Pictures.Items[k].Caption;
      Jpg_Preview := TJpegImage.Create;
      try
        Jpg_Preview.PixelFormat := jf24Bit;
        Jpg_Preview.Performance := {jpBestQuality}jpBestSpeed;
        Jpg_Preview.Smoothing := False;
        Jpg_Preview.Scale := jsFullSize;
        Jpg_Preview.LoadFromFile(FileName);
        Jpg_Preview.DIBNeeded;

        F := TFileStream.Create(FileName, fmOpenRead);
        Edt_Descr.Text := IntToStr(Jpg_Preview.Width) + ' x ' + IntToStr(Jpg_Preview.Height) +
          ', ' + IntToStr(F.Size div 1024) + ' Кб. ' +
          '(' + FileName + ')';
        F.Free;

        Preview_Bitmap.Width := Jpg_Preview.Width;
        Preview_Bitmap.Height := Jpg_Preview.Height;
        Preview_Bitmap.Canvas.Draw(0, 0, Jpg_Preview);
      finally
        Jpg_Preview.Free;
      end;
      Pnl_PreviewResize(Sender);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFmMain.Pnl_PreviewResize(Sender: TObject);
begin
  if Preview_Bitmap.Width <> 0 then
  begin
    Img_Preview.Picture.Bitmap.Width := Img_Preview.Width;
    Img_Preview.Picture.Bitmap.Height := Img_Preview.Height;
    Img_Preview.Picture.Bitmap.PixelFormat := pf24bit;
    ClearPreview;
    CreateThumbnail(Preview_Bitmap, Img_Preview.Picture.Bitmap);
  end;
end;

procedure TFmMain.Btn_SetWallPaperClick(Sender: TObject);
var
  k: Integer;
  FileName: string;
begin
  k := LV_Pictures.ItemIndex;
  if k <> -1 then
  begin
    Screen.Cursor := crHourGlass;
    try
      FileName := CollectionsFolder + '\' + Folder + '\' + LV_Pictures.Items[k].Caption;
      SetWallPaper(FileName);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFmMain.LV_PicturesEdited(Sender: TObject; Item: TListItem; var S: String);
var
  Old_FileName, New_FileName: string;
begin
  Old_FileName := CollectionsFolder + '\' + Folder + '\' + Item.Caption;
  NormalizePictureName(S);
  New_FileName := CollectionsFolder + '\' + Folder + '\' + S;
  if not ShellRenameFile(Self.Handle, Old_FileName, New_FileName) then
  begin
    S := Item.Caption;
  end;
  ai_SetPicture.ShortCut := ai_SetPicture_ShortCut;
end;

procedure TFmMain.MI_RenameCollectionClick(Sender: TObject);
var
  k: Integer;
  S: string;
begin
  k := Clb_Collections.ItemIndex;
  if k = -1 then
    Exit;
  S := Clb_Collections.Items[k];
  if MyInputQuery('Переименование коллекции', 'Новое название', S) then
  begin
    if ShellRenameFile(Self.Handle, CollectionsFolder + '\' + Clb_Collections.Items[k],
      CollectionsFolder + '\' + S) then
      Clb_Collections.Items[k] := S;
  end;
end;

procedure TFmMain.MI_AddCollectionClick(Sender: TObject);
var
  S: string;
begin
  S := 'Новая коллекция';
  if MyInputQuery('Создание коллекции', 'Название', S) then
  begin
    Clb_Collections.Items.Add(S);
    MkDir(CollectionsFolder + '\' + S);
  end;
end;

procedure TFmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveCollectionSettings;
  SaveSettings;
  SaveFormPlacement(Self);
  SaveFormValue(Self, 'Pnl_Collections_Width', Pnl_Collections.Width);
  SaveFormValue(Self, 'Pnl_Preview_Height', Pnl_Preview.Height);
  SaveFormValue(Self, 'ActiveCollection', Clb_Collections.ItemIndex);
end;

procedure TFmMain.MI_DeleteCollectionClick(Sender: TObject);
var
  k: Integer;
begin
  k := Clb_Collections.ItemIndex;
  if k = -1 then
    Exit;
  if ShellDeleteFile(Self.Handle, CollectionsFolder + '\' + Clb_Collections.Items[k]) then
  begin
    Clb_Collections.Items.Delete(k);
  end;
  Clb_Collections.ItemIndex := Max(0, k - 1);
  Clb_CollectionsClick(Sender);
end;

procedure TFmMain.ai_RenameCollectionUpdate(Sender: TObject);
begin
  ai_RenameCollection.Enabled := (Clb_Collections.ItemIndex <> -1);
end;

procedure TFmMain.ai_DeleteCollectionUpdate(Sender: TObject);
begin
  ai_DeleteCollection.Enabled := (Clb_Collections.ItemIndex <> -1);
end;

procedure TFmMain.ai_EditPictureUpdate(Sender: TObject);
begin
  ai_EditPicture.Enabled := (LV_Pictures.ItemIndex <> -1);
end;

procedure TFmMain.ai_DeletePictureUpdate(Sender: TObject);
begin
  ai_DeletePicture.Enabled := ((LV_Pictures.ItemIndex <> -1) or (LV_Pictures.SelCount > 0));
end;

procedure TFmMain.ai_EditPictureExecute(Sender: TObject);
var
  k: Integer;
  S: string;
begin
  k := LV_Pictures.ItemIndex;
  S := LV_Pictures.Items[k].Caption;
  if MyInputQuery('Переименование файла', 'Новое название', S) then
  begin
    NormalizePictureName(S);
    if ShellRenameFile(Self.Handle, CollectionsFolder + '\' + Folder + '\' + LV_Pictures.Items[k].Caption,
      CollectionsFolder + '\' + Folder + '\' + S) then
      LV_Pictures.Items[k].Caption := S;
  end;
end;

procedure TFmMain.ai_InsertPictureUpdate(Sender: TObject);
begin
  ai_InsertPicture.Enabled := (Clb_Collections.ItemIndex <> -1);
end;

procedure TFmMain.MI_DeletePictureClick(Sender: TObject);
var
  i: Integer;
  Files: TStringList;
begin
  Files := TStringList.Create;
  try
    for i := LV_Pictures.Selected.Index to LV_Pictures.Items.Count - 1 do
    begin
      if LV_Pictures.Items[i].Selected then
        Files.Add(CollectionsFolder + '\' + Folder + '\' + LV_Pictures.Items[i].Caption);
    end;
    ShellBatchDeleteFiles(Self.Handle, Files);
  finally
    Files.Free;
  end;
  FillCollection;
end;

procedure TFmMain.ai_InsertPictureExecute(Sender: TObject);
var
  i: Integer;
  FirstFile: string;
begin
  if OPD.Execute then
  begin
    ShellBatchCopyFiles(Self.Handle, OPD.Files, PChar(CollectionsFolder + '\' + Folder + '\'));
    FillCollection;
    FirstFile := ExtractFileName(OPD.Files[0]);
    for i := 0 to LV_Pictures.Items.Count - 1 do
      if LV_Pictures.Items[i].Caption = FirstFile then
      begin
        LV_Pictures.Selected := LV_Pictures.Items[i];
        LV_Pictures.Items[i].MakeVisible(False);
        Break;
      end;
  end;
end;

procedure TFmMain.ClearPreview;
begin
  Img_Preview.Canvas.Brush.Color := Pnl_Preview.Color;
  Img_Preview.Canvas.FillRect(Rect(0, 0, Img_Preview.Width, Img_Preview.Height));
end;

procedure TFmMain.Btn_SettingsClick(Sender: TObject);
var
  ShortCutFile: string;
begin
  if TFmSettings.EditSettings then
  begin
    Screen.Cursor := crHourGlass;
    try
      UpdateCurrentWallPaper;
      NotifyTrayApp;
      ShortCutFile := GetAutorunFolder + '\' + 'Мои заставки.lnk';
      if FileExists(ShortCutFile) then
        DeleteFile(ShortCutFile);
      if ShowInTray then
      begin
        SetShortCut(ShortCutFile, ExtractFilePath(Application.ExeName) + 'MyWallPapersTray.exe',
          ExtractFilePath(Application.ExeName) + 'MyWallPapersTray.exe', ExtractFilePath(Application.ExeName),
          'Мои заставки', '');
        StartMyWallPapersTray;
      end else
      begin
        CloseTrayApp;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFmMain.NotifyTrayApp;
var
  BSMRecipients: DWORD;
begin
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE, @BSMRecipients, TrayMessageID, 0, 0);
end;

procedure TFmMain.CloseTrayApp;
var
  BSMRecipients: DWORD;
begin
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE, @BSMRecipients, TrayMessageID, 1, 0);
end;

function TFmMain.GetAutorunFolder: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
    Result := Reg.ReadString('StartUp');
  finally
    Reg.Free;
  end;
end;

procedure SetShortCut(Path, Cmd, Icon, WorkFolder, Name, Arg: string);
var
  ShellObject: IUnknown;
  LinkFile: IPersistFile;
  ShellLink: IShellLink;
begin
  try
    CoInitialize(nil);
    ShellObject := CreateComObject(CLSID_ShellLink);
    LinkFile := ShellObject as IPersistFile;
    ShellLink := ShellObject as IShellLink;
    ShellLink.SetPath(PChar(Cmd));
    ShellLink.SetWorkingDirectory(PChar(WorkFolder));
    ShellLink.SetIconLocation(PChar(Icon), 0);
    ShellLink.SetDescription(PChar(Name));
    ShellLink.SetArguments(PChar(Arg));
    LinkFile.Save(PWChar(WideString(Path)), True);
  finally
    ShellObject := Unassigned;
    CoUninitialize;
  end;
end;

procedure TFmMain.StartMyWallPapersTray;
var
  STARTUPINFO: _STARTUPINFOW;
  ProcInfo: _PROCESS_INFORMATION;
  Curr_Dir: string;
begin
  Curr_Dir := ExtractFilePath(ParamStr(0));
  STARTUPINFO.cb := SizeOf(STARTUPINFO);
  ZeroMemory(@STARTUPINFO, STARTUPINFO.cb);
  if  CreateProcess(nil,
    PChar(Curr_Dir + 'MyWallPapersTray.exe'),
    nil, nil, False, 0, nil, PChar(Curr_Dir), STARTUPINFO, ProcInfo) = False then
    MessageBox(Self.Handle, PChar('Не удалось найти файл ' + Curr_Dir + 'MyWallPapersTray.exe'),
      PChar('Мои заставки'), MB_OK + MB_ICONWARNING);
end;

procedure TFmMain.ai_SetPictureUpdate(Sender: TObject);
begin
  ai_SetPicture.Enabled := (LV_Pictures.ItemIndex <> -1);
end;

procedure TFmMain.OpenPictureForEdit(FileName: string);
var
  Curr_Dir: string;
begin
  Curr_Dir := ExtractFilePath(ParamStr(0));
  ShellExecute(Self.Handle, 'open', PChar(FileName), '', PChar(Curr_Dir), SW_SHOW);
end;

procedure TFmMain.ai_OpenPictureUpdate(Sender: TObject);
begin
  ai_OpenPicture.Enabled := (LV_Pictures.ItemIndex <> -1);
end;

procedure TFmMain.ai_OpenPictureExecute(Sender: TObject);
var
  k: Integer;
begin
  k := LV_Pictures.ItemIndex;
  OpenPictureForEdit(CollectionsFolder + '\' + Folder + '\' + LV_Pictures.Items[k].Caption);
end;

procedure TFmMain.ai_UpdateThumbnailExecute(Sender: TObject);
var
  i: Integer;
  Thumbnail: TBitmap;
  Thumbnails: TThumbnails;
begin
  Thumbnail := TBitmap.Create;
  Thumbnails := TThumbnails.Create(CollectionsFolder + '\' + Folder + '\' + ThumbnailsFile);
  try
    Thumbnail.Width := Images.Width;
    Thumbnail.Height := Images.Height;
    Thumbnail.PixelFormat := pf24bit;
    Thumbnail.Transparent := False;
    Thumbnail.Canvas.Brush.Color := clWhite;

    for i := LV_Pictures.Selected.Index to LV_Pictures.Items.Count - 1 do
    begin
      if LV_Pictures.Items[i].Selected then
      begin
        Thumbnails.RefreshThumbnail(Thumbnail, LV_Pictures.Items[i].Caption);
        Images.Replace(i, Thumbnail, nil);
      end;
    end;
  finally
    Thumbnail.Free;
    Thumbnails.Free;
  end;
end;

procedure TFmMain.ai_UpdateThumbnailUpdate(Sender: TObject);
begin
  ai_UpdateThumbnail.Enabled := (LV_Pictures.ItemIndex <> -1) or (LV_Pictures.SelCount > 0);
end;

procedure TFmMain.ai_SelectAllPicturesExecute(Sender: TObject);
begin
  LV_Pictures.SelectAll;
end;

procedure TFmMain.LV_PicturesEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  ai_SetPicture_ShortCut := ai_SetPicture.ShortCut;
  ai_SetPicture.ShortCut := 0;
end;

procedure TFmMain.NormalizePictureName(var FileName: string);
begin
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.jpg';
end;

procedure TFmMain.LV_PicturesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  LV_PicturesClick(Sender);
end;

end.
