object FmMain: TFmMain
  Left = 0
  Top = 0
  Caption = 'FmMain'
  ClientHeight = 614
  ClientWidth = 858
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 206
    Top = 0
    Width = 5
    Height = 614
    AutoSnap = False
    Beveled = True
  end
  object Pnl_Collections: TPanel
    Left = 0
    Top = 0
    Width = 206
    Height = 614
    Align = alLeft
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      206
      614)
    object Clb_Collections: TCheckListBox
      Left = 5
      Top = 5
      Width = 196
      Height = 586
      OnClickCheck = Clb_CollectionsClickCheck
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      PopupMenu = Menu_Collections
      Sorted = True
      TabOrder = 0
      OnClick = Clb_CollectionsClick
    end
    object Pbar_Progress: TProgressBar
      Left = 4
      Top = 594
      Width = 198
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      Step = 1
      TabOrder = 1
      Visible = False
    end
  end
  object Pnl_Right: TPanel
    Left = 211
    Top = 0
    Width = 647
    Height = 614
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 360
      Width = 647
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      Beveled = True
    end
    object Pnl_Pictures: TPanel
      Left = 0
      Top = 0
      Width = 647
      Height = 360
      Align = alClient
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        647
        360)
      object LV_Pictures: TXPListView
        Left = 5
        Top = 5
        Width = 637
        Height = 350
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <>
        IconOptions.AutoArrange = True
        LargeImages = Images
        MultiSelect = True
        PopupMenu = Menu_Pictures
        SortType = stText
        TabOrder = 0
        OnDblClick = Btn_SetWallPaperClick
        OnEdited = LV_PicturesEdited
        OnEditing = LV_PicturesEditing
        OnSelectItem = LV_PicturesSelectItem
      end
    end
    object Pnl_Preview: TPanel
      Left = 0
      Top = 365
      Width = 647
      Height = 249
      Align = alBottom
      ParentBackground = False
      TabOrder = 1
      OnResize = Pnl_PreviewResize
      DesignSize = (
        647
        249)
      object Img_Preview: TImage
        Left = 0
        Top = 30
        Width = 556
        Height = 215
        Anchors = [akLeft, akTop, akRight, akBottom]
      end
      object Bevel_Right: TBevel
        Left = 560
        Top = 0
        Width = 6
        Height = 247
        Anchors = [akTop, akRight, akBottom]
        Shape = bsLeftLine
      end
      object Bevel_Top: TBevel
        Left = 0
        Top = 25
        Width = 561
        Height = 6
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
      object Btn_SetWallPaper: TButton
        Left = 566
        Top = 5
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        TabOrder = 0
        OnClick = Btn_SetWallPaperClick
      end
      object Btn_Settings: TButton
        Left = 566
        Top = 33
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        TabOrder = 1
        OnClick = Btn_SettingsClick
      end
      object Edt_Descr: TEdit
        Left = 5
        Top = 5
        Width = 551
        Height = 14
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
        Text = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' '#1092#1072#1081#1083#1072
      end
    end
  end
  object Images: TImageList
    Height = 100
    Width = 100
    Left = 30
    Top = 10
  end
  object Menu_Collections: TPopupMenu
    Left = 105
    Top = 10
    object MI_AddCollection: TMenuItem
      Action = ai_AddCollection
    end
    object MI_RenameCollection: TMenuItem
      Action = ai_RenameCollection
    end
    object MI_DeleteCollection: TMenuItem
      Action = ai_DeleteCollection
    end
  end
  object Menu_Pictures: TPopupMenu
    Left = 241
    Top = 10
    object MI_AddPicture: TMenuItem
      Action = ai_InsertPicture
    end
    object MI_EditPicture: TMenuItem
      Action = ai_EditPicture
    end
    object MI_DeletePicture: TMenuItem
      Action = ai_DeletePicture
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Action = ai_SetPicture
    end
    object N2: TMenuItem
      Action = ai_OpenPicture
    end
    object N3: TMenuItem
      Action = ai_UpdateThumbnail
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = ai_SelectAllPictures
    end
  end
  object ActionList: TActionList
    Left = 30
    Top = 130
    object ai_AddCollection: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      ShortCut = 45
      OnExecute = MI_AddCollectionClick
    end
    object ai_RenameCollection: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100'...'
      ShortCut = 113
      OnExecute = MI_RenameCollectionClick
      OnUpdate = ai_RenameCollectionUpdate
    end
    object ai_DeleteCollection: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      OnExecute = MI_DeleteCollectionClick
      OnUpdate = ai_DeleteCollectionUpdate
    end
    object ai_InsertPicture: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
      ShortCut = 45
      OnExecute = ai_InsertPictureExecute
      OnUpdate = ai_InsertPictureUpdate
    end
    object ai_EditPicture: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100'...'
      ShortCut = 113
      OnExecute = ai_EditPictureExecute
      OnUpdate = ai_EditPictureUpdate
    end
    object ai_DeletePicture: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      OnExecute = MI_DeletePictureClick
      OnUpdate = ai_DeletePictureUpdate
    end
    object ai_SetPicture: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      ShortCut = 13
      OnExecute = Btn_SetWallPaperClick
      OnUpdate = ai_SetPictureUpdate
    end
    object ai_OpenPicture: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnExecute = ai_OpenPictureExecute
      OnUpdate = ai_OpenPictureUpdate
    end
    object ai_UpdateThumbnail: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1101#1089#1082#1080#1079
      ShortCut = 116
      OnExecute = ai_UpdateThumbnailExecute
      OnUpdate = ai_UpdateThumbnailUpdate
    end
    object ai_SelectAllPictures: TAction
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1105
      ShortCut = 16449
      OnExecute = ai_SelectAllPicturesExecute
    end
  end
  object OPD: TOpenPictureDialog
    DefaultExt = 'jpg'
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|JPEG Image File (*.jpg)|*.jpg'
    FilterIndex = 2
    Options = [ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 105
    Top = 130
  end
end
