object MainWlanClientForm: TMainWlanClientForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Wireless LAN Client'
  ClientHeight = 337
  ClientWidth = 572
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
    Width = 572
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 14
      Width = 64
      Height = 13
      Caption = 'Network card'
    end
    object ComboBox1: TComboBox
      Left = 74
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
    Width = 572
    Height = 296
    ActivePage = WirelessNetworksTabSheet
    Align = alClient
    TabOrder = 1
    object WirelessNetworksTabSheet: TTabSheet
      Caption = 'Wireless networks'
      object ListView1: TListView
        Left = 0
        Top = 35
        Width = 564
        Height = 233
        Align = alClient
        Columns = <
          item
            Caption = 'SSID'
            Width = 75
          end
          item
            Caption = 'Authentication'
            Width = 85
          end
          item
            Caption = 'Encryption'
            Width = 75
          end
          item
            Caption = 'Type'
            Width = 100
          end
          item
            Caption = 'AP count'
            Width = 60
          end
          item
            Caption = 'Quality'
          end
          item
            Caption = 'Connected'
            Width = 75
          end>
        ReadOnly = True
        RowSelect = True
        ShowWorkAreas = True
        TabOrder = 0
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = ListView1AdvancedCustomDrawItem
        OnDeletion = ListView1Deletion
        OnSelectItem = ListView1SelectItem
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 564
        Height = 35
        Align = alTop
        TabOrder = 1
        object NetworkConnectButton: TButton
          Left = 8
          Top = 8
          Width = 89
          Height = 25
          Caption = 'Connect...'
          Enabled = False
          TabOrder = 0
          OnClick = NetworkConnectButtonClick
        end
        object Button2: TButton
          Left = 103
          Top = 4
          Width = 89
          Height = 25
          Caption = 'Disconnect'
          Enabled = False
          TabOrder = 1
          OnClick = Button2Click
        end
      end
    end
    object ProfileSheet: TTabSheet
      Caption = 'Network profiles'
      ImageIndex = 1
      OnShow = ProfileSheetShow
      object ProfileMenuPanel: TPanel
        Left = 0
        Top = 0
        Width = 564
        Height = 33
        Align = alTop
        TabOrder = 0
        object ProfileConnectButton: TButton
          Left = 8
          Top = 2
          Width = 89
          Height = 25
          Caption = 'Connect...'
          Enabled = False
          TabOrder = 0
          OnClick = NetworkConnectButtonClick
        end
        object ProfileDeleteButton: TButton
          Left = 103
          Top = 2
          Width = 89
          Height = 25
          Caption = 'Delete'
          Enabled = False
          TabOrder = 1
          OnClick = ProfileDeleteButtonClick
        end
      end
      object ProfileListView: TListView
        Left = 0
        Top = 33
        Width = 564
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
            Caption = 'SSID'
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
        ShowWorkAreas = True
        TabOrder = 1
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = ProfileListViewAdvancedCustomDrawItem
        OnData = ProfileListViewData
        OnSelectItem = ProfileListViewSelectItem
      end
    end
    object HostedNetworkTabSheet: TTabSheet
      Caption = 'Ad-hoc network'
      ImageIndex = 2
      OnShow = HostedNetworkTabSheetShow
      object HostedNetworkLowerPanel: TPanel
        Left = 0
        Top = 33
        Width = 564
        Height = 235
        Align = alClient
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 9
          Width = 23
          Height = 13
          Caption = 'SSID'
        end
        object Label3: TLabel
          Left = 8
          Top = 33
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object Label4: TLabel
          Left = 8
          Top = 60
          Width = 70
          Height = 13
          Caption = 'Authentication'
        end
        object Label5: TLabel
          Left = 8
          Top = 87
          Width = 51
          Height = 13
          Caption = 'Encryption'
        end
        object Label6: TLabel
          Left = 8
          Top = 111
          Width = 50
          Height = 13
          Caption = 'Max peers'
        end
        object Label7: TLabel
          Left = 240
          Top = 6
          Width = 63
          Height = 13
          Caption = 'MAC address'
        end
        object Label8: TLabel
          Left = 240
          Top = 28
          Width = 46
          Height = 13
          Caption = 'Device ID'
        end
        object Label9: TLabel
          Left = 240
          Top = 55
          Width = 39
          Height = 13
          Caption = 'Channel'
        end
        object Label10: TLabel
          Left = 240
          Top = 82
          Width = 52
          Height = 13
          Caption = 'Peer count'
        end
        object HNSSIDEdit: TEdit
          Left = 97
          Top = 3
          Width = 89
          Height = 21
          TabOrder = 0
        end
        object HNPasswordEdit: TEdit
          Left = 97
          Top = 30
          Width = 89
          Height = 21
          TabOrder = 1
        end
        object HNAuthenticationComboBox: TComboBox
          Left = 97
          Top = 57
          Width = 89
          Height = 21
          Style = csDropDownList
          TabOrder = 2
          Items.Strings = (
            'Invalid'
            'Open'
            'WEP'
            'WPA'
            'WPA-PSK'
            'WPA-NONE'
            'WPA2'
            'WPA2-PSK')
        end
        object HNEncryptionComboBox: TComboBox
          Left = 97
          Top = 84
          Width = 89
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          Items.Strings = (
            'None'
            '40-bit WEP'
            'TKIP'
            'Unused'
            'CCMP'
            '104-bit WEP')
        end
        object HNMaxPeersEdit: TEdit
          Left = 97
          Top = 111
          Width = 89
          Height = 21
          TabOrder = 4
        end
        object HNSavePasswordCheckBox: TCheckBox
          Left = 96
          Top = 136
          Width = 97
          Height = 17
          Caption = 'Save password'
          TabOrder = 5
        end
        object HNMACAddressEdit: TEdit
          Left = 320
          Top = 0
          Width = 233
          Height = 21
          TabOrder = 6
        end
        object HNDeviceIdGuid: TEdit
          Left = 320
          Top = 25
          Width = 233
          Height = 21
          TabOrder = 7
        end
        object HNFrequencyEdit: TEdit
          Left = 320
          Top = 52
          Width = 233
          Height = 21
          TabOrder = 8
        end
        object HNPeerCountEdit: TEdit
          Left = 320
          Top = 79
          Width = 233
          Height = 21
          TabOrder = 9
        end
        object HNPeerListView: TListView
          Left = 240
          Top = 104
          Width = 313
          Height = 121
          Columns = <
            item
              Caption = 'MAC address'
              Width = 100
            end
            item
              Caption = 'Authenticated'
              Width = 90
            end>
          OwnerData = True
          ReadOnly = True
          RowSelect = True
          ShowWorkAreas = True
          TabOrder = 10
          ViewStyle = vsReport
          OnData = HNPeerListViewData
        end
      end
      object HostedNetworkMenuPanel: TPanel
        Left = 0
        Top = 0
        Width = 564
        Height = 33
        Align = alTop
        TabOrder = 1
        object HNRefreshButton: TButton
          Left = 8
          Top = 2
          Width = 89
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = HostedNetworkTabSheetShow
        end
        object HNEnableDisableButton: TButton
          Left = 103
          Top = 2
          Width = 89
          Height = 25
          Caption = 'ED'
          TabOrder = 1
          OnClick = HNEnableDisableButtonClick
        end
        object HNStartStopButton: TButton
          Left = 198
          Top = 2
          Width = 89
          Height = 25
          Caption = 'SS'
          TabOrder = 2
          OnClick = HNStartStopButtonClick
        end
        object HNApplyButton: TButton
          Left = 293
          Top = 2
          Width = 89
          Height = 25
          Caption = 'Apply'
          TabOrder = 3
          OnClick = HNApplyButtonClick
        end
      end
    end
  end
  object CardListTimer: TTimer
    Enabled = False
    OnTimer = RefreshAll
    Left = 64
    Top = 256
  end
end
