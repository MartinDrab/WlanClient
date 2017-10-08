object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Vyberte vys'#237'la'#269'e'
  ClientHeight = 221
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 531
    Height = 160
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'MAC adresa'
        Width = 125
      end
      item
        AutoSize = True
        Caption = 'SSID'
      end
      item
        Caption = 'V'#253'kon (dB)'
        Width = 75
      end
      item
        Caption = 'Kvalita spojen'#237
        Width = 95
      end
      item
        Caption = 'Frekvence'
        Width = 80
      end
      item
        Caption = 'Kan'#225'l'
        Width = 75
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 160
    Width = 531
    Height = 61
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 30
      Width = 65
      Height = 25
      Caption = 'P'#345'ipojit'
      TabOrder = 0
      OnClick = Button1Click
    end
    object CreateProfileCheckBox: TCheckBox
      Left = 0
      Top = 6
      Width = 89
      Height = 17
      Caption = 'Vytvo'#345'it profil'
      Enabled = False
      TabOrder = 1
    end
    object AutoConnectCheckBox: TCheckBox
      Left = 95
      Top = 6
      Width = 130
      Height = 17
      Caption = 'P'#345'ipojovat automaticky'
      Enabled = False
      TabOrder = 2
    end
    object HiddenNetworkCheckBox: TCheckBox
      Left = 224
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Skryt'#225' s'#237#357
      Enabled = False
      TabOrder = 3
    end
  end
end
