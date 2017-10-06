object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Bezdr'#225'tov'#253' klient'
  ClientHeight = 337
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 14
      Width = 59
      Height = 13
      Caption = 'S'#237#357'ov'#225' karta'
    end
    object ComboBox1: TComboBox
      Left = 69
      Top = 14
      Width = 345
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = RefreshNetworks
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 512
    Height = 296
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Bezdr'#225'tov'#233' s'#237't'#283
      object ListView1: TListView
        Left = 0
        Top = 35
        Width = 504
        Height = 233
        Align = alClient
        Columns = <
          item
            Caption = 'SSID'
            Width = 75
          end
          item
            Caption = 'Autentizace'
            Width = 75
          end
          item
            Caption = #352'ifrov'#225'n'#237
            Width = 75
          end
          item
            Caption = 'Typ s'#237't'#283
            Width = 100
          end
          item
            Caption = 'Vys'#237'la'#269#367
          end
          item
            Caption = 'Sign'#225'l'
          end
          item
            Caption = 'P'#345'ipojen'
            Width = 75
          end>
        ReadOnly = True
        RowSelect = True
        ShowWorkAreas = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDeletion = ListView1Deletion
        OnSelectItem = ListView1SelectItem
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 504
        Height = 35
        Align = alTop
        TabOrder = 1
        object Button1: TButton
          Left = 8
          Top = 8
          Width = 89
          Height = 25
          Caption = 'P'#345'ipojit'
          Enabled = False
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 103
          Top = 8
          Width = 89
          Height = 25
          Caption = 'Odpojit'
          Enabled = False
          TabOrder = 1
          OnClick = Button2Click
        end
      end
    end
    object ProfileSheet: TTabSheet
      Caption = 'S'#237#357'ov'#233' profily'
      ImageIndex = 1
      OnShow = ProfileSheetShow
      object ProfileMenuPanel: TPanel
        Left = 0
        Top = 0
        Width = 504
        Height = 33
        Align = alTop
        TabOrder = 0
      end
      object ProfileListView: TListView
        Left = 0
        Top = 33
        Width = 504
        Height = 235
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'Name'
          end
          item
            Caption = 'Type'
            Width = 75
          end
          item
            AutoSize = True
            Caption = 'Password'
          end>
        DoubleBuffered = True
        OwnerData = True
        ReadOnly = True
        RowSelect = True
        ParentDoubleBuffered = False
        TabOrder = 1
        ViewStyle = vsReport
        OnData = ProfileListViewData
        ExplicitLeft = 32
        ExplicitWidth = 472
      end
    end
  end
  object CardListTimer: TTimer
    Enabled = False
    OnTimer = RefreshAll
    Left = 280
    Top = 56
  end
end
