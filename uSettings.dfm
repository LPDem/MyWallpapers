object FmSettings: TFmSettings
  Left = 300
  Top = 221
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 342
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    513
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object Btn_OK: TButton
    Left = 168
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Btn_Cancel: TButton
    Left = 248
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object PG_Settings: TPageControl
    Left = 0
    Top = 0
    Width = 513
    Height = 309
    ActivePage = TS_WallPapers
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TS_WallPapers: TTabSheet
      Caption = #1054#1073#1086#1080
      object Label1: TLabel
        Left = 4
        Top = 108
        Width = 234
        Height = 13
        Caption = #1050#1086#1084#1073#1080#1085#1072#1094#1080#1103' '#1082#1083#1072#1074#1080#1096' '#1076#1083#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1082#1072#1088#1090#1080#1085#1082#1080
      end
      object Label2: TLabel
        Left = 370
        Top = 133
        Width = 23
        Height = 13
        Caption = #1084#1080#1085'.'
      end
      object Label3: TLabel
        Left = 30
        Top = 133
        Width = 210
        Height = 13
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1084#1077#1085#1103#1090#1100' '#1082#1072#1088#1090#1080#1085#1082#1091' '#1082#1072#1078#1076#1099#1077
      end
      object Cb_ShowInTray: TCheckBox
        Left = 5
        Top = 5
        Width = 241
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1079#1085#1072#1095#1086#1082' '#1074' '#1089#1080#1089#1090#1077#1084#1085#1086#1081' '#1086#1073#1083#1072#1089#1090#1080
        TabOrder = 0
      end
      object Edt_HotKey: THotKey
        Left = 245
        Top = 105
        Width = 121
        Height = 21
        HotKey = 24663
        InvalidKeys = [hcNone, hcShift, hcCtrl, hcAlt, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = [hkShift, hkCtrl]
        TabOrder = 3
      end
      object Cb_StretchAnyway: TCheckBox
        Left = 5
        Top = 30
        Width = 141
        Height = 17
        Hint = 
          #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1087#1088#1086#1087#1086#1088#1094#1080#1080' '#1082#1072#1088#1090#1080#1085#1082#1080', '#1074#1089#1077#1075#1076#1072' '#1088#1072#1089#1090#1103#1075#1080#1074#1072#1090#1100' '#1085#1072' '#1074#1077#1089#1100' '#1101#1082#1088#1072 +
          #1085
        Caption = #1047#1072#1073#1080#1090#1100' '#1085#1072' '#1087#1088#1086#1087#1086#1088#1094#1080#1080
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object Cb_UseWorkArea: TCheckBox
        Left = 5
        Top = 55
        Width = 266
        Height = 17
        Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1073#1083#1072#1089#1100' '#1101#1082#1088#1072#1085#1072', '#1079#1072#1085#1103#1090#1091#1102' '#1087#1072#1085#1077#1083#1100#1102' '#1079#1072#1076#1072#1095
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1091#1102' '#1086#1073#1083#1072#1089#1090#1100' '#1101#1082#1088#1072#1085#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object Edt_Time: TNumericEdit
        Left = 245
        Top = 130
        Width = 121
        Height = 21
        Hint = '0 - '#1085#1077' '#1084#1077#1085#1103#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
        ButtonVisible = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Format = '0'
        Value = Null
      end
      object Cb_UseCurrResolution: TCheckBox
        Left = 5
        Top = 80
        Width = 426
        Height = 17
        Caption = 
          #1047#1072#1087#1086#1084#1085#1080#1090#1100' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1101#1082#1088#1072#1085#1072' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1080' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1077#1075#1086', '#1072' '#1085#1077 +
          ' '#1090#1077#1082#1091#1097#1077#1077
        TabOrder = 5
      end
    end
    object TS_Calendar: TTabSheet
      Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100
      ImageIndex = 1
      DesignSize = (
        505
        281)
      object Label4: TLabel
        Left = 255
        Top = 49
        Width = 121
        Height = 13
        Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1099#1081' '#1086#1090#1089#1090#1091#1087
      end
      object Label5: TLabel
        Left = 450
        Top = 49
        Width = 28
        Height = 13
        Caption = #1090#1086#1095#1077#1082
      end
      object Label6: TLabel
        Left = 266
        Top = 74
        Width = 110
        Height = 13
        Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1099#1081' '#1086#1090#1089#1090#1091#1087
      end
      object Label7: TLabel
        Left = 450
        Top = 74
        Width = 28
        Height = 13
        Caption = #1090#1086#1095#1077#1082
      end
      object Edt_Layout: TRadioGroup
        Left = 5
        Top = 25
        Width = 241
        Height = 86
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '
        Columns = 2
        ItemIndex = 2
        Items.Strings = (
          #1057#1083#1077#1074#1072' '#1074#1074#1077#1088#1093#1091
          #1057#1083#1077#1074#1072' '#1074#1085#1080#1079#1091
          #1057#1087#1088#1072#1074#1072' '#1074#1074#1077#1088#1093#1091
          #1057#1087#1088#1072#1074#1072' '#1074#1085#1080#1079#1091)
        TabOrder = 0
      end
      object Edt_Hor_Space: TNumericEdit
        Left = 385
        Top = 46
        Width = 61
        Height = 21
        ButtonVisible = False
        TabOrder = 1
        Text = '0'
        Format = '0'
        Value = 0.000000000000000000
      end
      object Edt_Vert_Space: TNumericEdit
        Left = 385
        Top = 71
        Width = 61
        Height = 21
        ButtonVisible = False
        TabOrder = 2
        Text = '0'
        Format = '0'
        Value = 0.000000000000000000
      end
      object Cb_Use_Calendar: TCheckBox
        Left = 5
        Top = 5
        Width = 146
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1082#1072#1083#1077#1085#1076#1072#1088#1100
        TabOrder = 3
      end
      object Edt_Caption: TLabeledEdit
        Left = 60
        Top = 120
        Width = 438
        Height = 21
        Hint = 
          'd - '#1076#1077#1085#1100' '#1073#1077#1079' '#1085#1072#1095#1072#1083#1100#1085#1086#1075#1086' '#1085#1091#1083#1103#13#10'dd - '#1076#1077#1085#1100' '#1080#1079' '#1076#1074#1091#1093' '#1094#1080#1092#1088#13#10'ddd - '#1089#1086#1082#1088 +
          #1072#1097#1105#1085#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1076#1085#1103#13#10'dddd - '#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1076#1085#1103#13#10'M - '#1084#1077#1089#1103#1094' '#1073#1077#1079' ' +
          #1085#1072#1095#1072#1083#1100#1085#1086#1075#1086' '#1085#1091#1083#1103#13#10'MM - '#1084#1077#1089#1103#1094' '#1080#1079' '#1076#1074#1091#1093' '#1094#1080#1092#1088#13#10'MMM - '#1089#1086#1082#1088#1072#1097#1105#1085#1085#1086#1077' '#1085#1072#1079#1074 +
          #1072#1085#1080#1077' '#1084#1077#1089#1103#1094#1072#13#10'MMMM - '#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1084#1077#1089#1103#1094#1072#13#10'y - '#1075#1086#1076' '#1073#1077#1079' '#1085#1072#1095#1072#1083#1100#1085#1086 +
          #1075#1086' '#1085#1091#1083#1103#13#10'yy - '#1075#1086#1076' '#1080#1079' '#1076#1074#1091#1093' '#1094#1080#1092#1088#13#10'yyyy - '#1075#1086#1076' '#1080#1079' '#1095#1077#1090#1099#1088#1105#1093' '#1094#1080#1092#1088#13#10#1057#1080#1084#1074 +
          #1086#1083#1099' '#1074' '#1072#1087#1086#1089#1090#1088#1086#1092#1072#1093' ('#39') '#1074#1099#1074#1086#1076#1103#1090#1089#1103' "'#1082#1072#1082' '#1077#1089#1090#1100'"'
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
        LabelPosition = lpLeft
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = 'd mmmm yyyy'
      end
      object GroupBox1: TGroupBox
        Left = 5
        Top = 145
        Width = 493
        Height = 51
        Anchors = [akLeft, akTop, akRight]
        Caption = #1064#1088#1080#1092#1090' '
        TabOrder = 5
        object Label8: TLabel
          Left = 100
          Top = 21
          Width = 70
          Height = 13
          Caption = #1062#1074#1077#1090' '#1096#1088#1080#1092#1090#1072':'
        end
        object Label16: TLabel
          Left = 214
          Top = 21
          Width = 91
          Height = 13
          Caption = #1062#1074#1077#1090' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074':'
        end
        object Label17: TLabel
          Left = 348
          Top = 21
          Width = 100
          Height = 13
          Caption = #1062#1074#1077#1090' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1076#1085#1103':'
        end
        object Pnl_FontCaptionColor: TPanel
          Left = 175
          Top = 15
          Width = 31
          Height = 26
          Hint = #1062#1074#1077#1090' '#1096#1088#1080#1092#1090#1072'...'
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Ctl3D = True
          ParentBackground = False
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = Pnl_FontCaptionColorClick
        end
        object Btn_FontCaption: TButton
          Left = 10
          Top = 16
          Width = 85
          Height = 25
          Caption = #1064#1088#1080#1092#1090'...'
          TabOrder = 1
          OnClick = Btn_FontCaptionClick
        end
        object Pnl_FontHolidayColor: TPanel
          Left = 311
          Top = 15
          Width = 31
          Height = 26
          Hint = #1062#1074#1077#1090' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074'...'
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Ctl3D = True
          ParentBackground = False
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = Pnl_FontHolidayColorClick
        end
        object Pnl_FontCurrentDayColor: TPanel
          Left = 454
          Top = 15
          Width = 31
          Height = 26
          Hint = #1062#1074#1077#1090' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1076#1085#1103'...'
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Ctl3D = True
          ParentBackground = False
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = Pnl_FontCurrentDayColorClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 5
        Top = 200
        Width = 493
        Height = 76
        Anchors = [akLeft, akTop, akRight]
        Caption = #1058#1077#1085#1100' '
        TabOrder = 6
        object Label9: TLabel
          Left = 7
          Top = 21
          Width = 54
          Height = 13
          Caption = #1062#1074#1077#1090' '#1090#1077#1085#1080':'
        end
        object Label10: TLabel
          Left = 5
          Top = 53
          Width = 139
          Height = 13
          Caption = #1057#1084#1077#1097#1077#1085#1080#1077': '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080
        end
        object Label11: TLabel
          Left = 213
          Top = 53
          Width = 28
          Height = 13
          Caption = #1090#1086#1095#1077#1082
        end
        object Label12: TLabel
          Left = 255
          Top = 53
          Width = 70
          Height = 13
          Caption = #1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080
        end
        object Label13: TLabel
          Left = 393
          Top = 53
          Width = 28
          Height = 13
          Caption = #1090#1086#1095#1077#1082
        end
        object Pnl_FontShadowColor: TPanel
          Left = 66
          Top = 15
          Width = 85
          Height = 26
          Hint = #1062#1074#1077#1090' '#1090#1077#1085#1080'...'
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Ctl3D = True
          ParentBackground = False
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = Pnl_FontShadowColorClick
        end
        object Edt_Shadow_Hor: TNumericEdit
          Left = 150
          Top = 50
          Width = 61
          Height = 21
          ButtonVisible = False
          TabOrder = 1
          Text = '0'
          Format = '0'
          Value = 0.000000000000000000
        end
        object Edt_Shadow_Vert: TNumericEdit
          Left = 330
          Top = 50
          Width = 61
          Height = 21
          ButtonVisible = False
          TabOrder = 2
          Text = '0'
          Format = '0'
          Value = 0.000000000000000000
        end
      end
    end
    object TS_Other: TTabSheet
      Caption = #1044#1088#1091#1075#1086#1077
      ImageIndex = 2
      DesignSize = (
        505
        281)
      object Label14: TLabel
        Left = 0
        Top = 28
        Width = 123
        Height = 13
        Caption = #1056#1072#1079#1084#1077#1097#1077#1085#1080#1077' '#1082#1086#1083#1083#1077#1082#1094#1080#1081
      end
      object Label15: TLabel
        Left = 23
        Top = 53
        Width = 99
        Height = 13
        Caption = #1060#1072#1081#1083#1099' '#1089' '#1101#1082#1089#1080#1079#1072#1084#1080
      end
      object Edt_CollectionsFolder: TEdit
        Left = 130
        Top = 25
        Width = 353
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        AutoSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object Btn_CollectionsFolder: TButton
        Left = 483
        Top = 25
        Width = 21
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = Btn_CollectionsFolderClick
      end
      object Edt_ThumbnailsFile: TEdit
        Left = 130
        Top = 50
        Width = 353
        Height = 21
        Hint = 
          #1042' '#1101#1090#1080#1093' '#1092#1072#1081#1083#1072#1093' '#1093#1088#1072#1085#1103#1090#1089#1103' '#1091#1084#1077#1085#1100#1096#1077#1085#1085#1099#1077' '#1082#1086#1087#1080#1080' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' '#13#10#1076#1083#1103' '#1073#1086#1083#1077#1077 +
          ' '#1073#1099#1089#1090#1088#1086#1075#1086' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1075#1086' '#1082#1086#1083#1083#1077#1082#1094#1080#1081
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
  end
  object FD_Calendar: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = []
    Left = 364
    Top = 65535
  end
  object CD_Calendar: TColorDialog
    Options = [cdFullOpen, cdAnyColor]
    Left = 434
    Top = 65535
  end
end
