object FmInputQuery: TFmInputQuery
  Left = 356
  Top = 446
  BorderStyle = bsDialog
  Caption = 'FmInputQuery'
  ClientHeight = 74
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    447
    74)
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_Prompt: TLabel
    Left = 5
    Top = 5
    Width = 53
    Height = 13
    Caption = 'Lbl_Prompt'
  end
  object Btn_OK: TButton
    Left = 146
    Top = 45
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Btn_Cancel: TButton
    Left = 226
    Top = 45
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Edt_Value: TEdit
    Left = 5
    Top = 20
    Width = 437
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'Edt_Value'
  end
end
