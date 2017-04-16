object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Vyberte vys'#237'la'#269'e'
  ClientHeight = 221
  ClientWidth = 458
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
    Width = 458
    Height = 182
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
    OnDeletion = ListView1Deletion
    ExplicitLeft = 24
    ExplicitWidth = 434
  end
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 458
    Height = 39
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 6
      Width = 65
      Height = 25
      Caption = 'P'#345'ipojit'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
