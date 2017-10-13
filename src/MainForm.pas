Unit MainForm;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, WLanAPI,
  WlanAPIClient, WlanBus, WlanInterface, wlanNetwork, WlanHostedNetwork, Vcl.ComCtrls,
  WlanBssEntry, WlanProfile, Vcl.OleCtrls, SHDocVw, Generics.Collections;

Type
  TMainWlanClientForm = Class (TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    PageControl1: TPageControl;
    WirelessNetworksTabSheet: TTabSheet;
    ListView1: TListView;
    CardListTimer: TTimer;
    Panel2: TPanel;
    NetworkConnectButton: TButton;
    Button2: TButton;
    Label1: TLabel;
    ProfileSheet: TTabSheet;
    ProfileMenuPanel: TPanel;
    ProfileListView: TListView;
    ProfileConnectButton: TButton;
    ProfileDeleteButton: TButton;
    HostedNetworkTabSheet: TTabSheet;
    HostedNetworkLowerPanel: TPanel;
    HostedNetworkMenuPanel: TPanel;
    HNSSIDEdit: TEdit;
    HNPasswordEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    HNAuthenticationComboBox: TComboBox;
    HNEncryptionComboBox: TComboBox;
    HNMaxPeersEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    HNSavePasswordCheckBox: TCheckBox;
    HNRefreshButton: TButton;
    HNEnableDisableButton: TButton;
    HNStartStopButton: TButton;
    HNApplyButton: TButton;
    HNMACAddressEdit: TEdit;
    HNDeviceIdGuid: TEdit;
    HNFrequencyEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    HNPeerCountEdit: TEdit;
    Label10: TLabel;
    HNPeerListView: TListView;
    InterfaceInfoSheet: TTabSheet;
    InterfaceNameEdit: TEdit;
    InterfaceGuidEdit: TEdit;
    InterfaceMACEdit: TEdit;
    InterfaceProfileEdit: TEdit;
    InterfaceSSIDEdit: TEdit;
    InterfaceChannelEdit: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    InterfaceAuthEdit: TEdit;
    InterfaceEncryptionEdit: TEdit;
    InterfaceStateEdit: TEdit;
    InterfaceModeEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RefreshNetworks(Sender: TObject);
    procedure ListView1Deletion(Sender: TObject; Item: TListItem);
    procedure RefreshNetworkCards(Sender: TObject);
    Procedure RefreshAll(Sender:TObject);
    procedure Button2Click(Sender: TObject);
    procedure NetworkConnectButtonClick(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ProfileListViewData(Sender: TObject; Item: TListItem);
    procedure ProfileSheetShow(Sender: TObject);
    procedure ProfileListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ProfileDeleteButtonClick(Sender: TObject);
    procedure HostedNetworkTabSheetShow(Sender: TObject);
    procedure HNRefreshButtonClick(Sender: TObject);
    procedure HNEnableDisableButtonClick(Sender: TObject);
    procedure HNStartStopButtonClick(Sender: TObject);
    procedure HNApplyButtonClick(Sender: TObject);
    procedure HNPeerListViewData(Sender: TObject; Item: TListItem);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ProfileListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure InterfaceInfoSheetShow(Sender: TObject);
  Private
    FCurrentCard : TWlanInterface;
    FHostedNetwork : TWlanHostedNetwork;
    FWlanClient : TWlanAPICLient;
    FWlanBus : TWlanBus;
    FProfileList : TObjectList<TWlanProfile>;
    FInterfaceInfo : TWlanInterfaceInfo;
    Function BooleanToStr(X:Boolean):WideSTring;
    Procedure RefreshProfiles(AComboBox:TComboBox);
  end;

Var
  MainWlanClientForm: TMainWlanClientForm;

Implementation

{$R *.DFM}

Uses
  APSelectionForm;


Procedure TMainWlanClientForm.RefreshAll(Sender:TObject);
begin
RefreshNetworkCards(ComboBox1);
RefreshNetworks(Nil);
end;

Function TMainWlanClientForm.BooleanToStr(X:Boolean):WideSTring;
begin
If X Then
  Result := 'Yes'
Else Result := 'No';
end;

Procedure TMainWlanClientForm.RefreshNetworkCards(Sender: TObject);
Var
 CardList : TObjectList<TWlanInterface>;
 Ret : Boolean;
 I : Integer;
 ItemGuid : TGUID;
 LastState : TWlanInterfaceState;
 SelectedSurvived : Boolean;
begin
CardList := TObjectList<TWlanInterface>.Create(False);
If FWlanBus.EnumInterfaces(CardList) Then
  begin
  SelectedSurvived := False;
  If ComboBox1.ItemIndex > -1 Then
    begin
    FCurrentCard := TWlanInterface(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    ItemGuid := FCurrentCard.Guid;
    LastState := FCurrentCard.State;
    end;

  For I := 0 To CardList.Count - 1 Do
    begin
    FCurrentCard := CardList[I];
    If I < ComboBox1.Items.Count Then
      begin
      ComboBox1.Items.Strings[I] := Format('%s (%s)', [FCurrentCard.Description, TWlanInterface.StateToStr(FCurrentCard.State)]);
      ComboBox1.Items.Objects[I].Free;
      ComboBox1.Items.Objects[I] := FCurrentCard;
      If ItemGuid = FCurrentCard.Guid Then
        begin
        SelectedSurvived := True;
        ComboBox1.ItemIndex := I;
        end;

      If FCurrentCard.State <> LastState Then
        RefreshNetworks(Nil);
      end
    Else ComboBox1.AddItem(Format('%s (%s)', [FCurrentCard.Description, TWlanInterface.StateToStr(FCurrentCard.State)]), FCurrentCard);
    end;

  While ComboBox1.Items.Count > CardList.Count Do
    ComboBox1.Items.Delete(ComboBox1.Items.Count - 1);

  If Not SelectedSurvived Then
    ComboBox1.ItemIndex := 0;

  ComboBox1.Invalidate;
  FCurrentCard := Nil;
  If ComboBox1.Items.Count > 0 Then
    begin
    FCurrentCard := TWlanInterface(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    FCurrentCard.QueryConnectionInfo(FInterfaceInfo);
    end;
  end;

CardList.Free;
end;

Procedure TMainWlanClientForm.RefreshProfiles(AComboBox:TComboBox);
Var
  tmpList2 : TObjectList<TWlanProfile>;
  tmpList : TObjectList<TWlanProfile>;
begin
tmpList := TObjectList<TWlanProfile>.Create;
If FCurrentCard.EnumProfiles(tmpList) Then
  begin
  ProfileListView.Items.Count := 0;
  tmpList2 := FProfileList;
  FProfileList := tmpList;
  tmpList := tmpList2;
  ProfileListView.Items.Count := FProfileList.Count;
  end;

If Assigned(tmpList) Then
  tmpList.Free;
end;

Procedure TMainWlanClientForm.RefreshNetworks(Sender: TObject);
Var
  I : Integer;
  NetworkList : TObjectList<TWlanNetwork>;
  WlanNetwork : TWlanNetwork;
  L : TListItem;
begin
NetworkList := TObjectList<TWlanNetwork>.Create(False);
If FCurrentCard.EnumNetworks(NetworkList) Then
  begin
  ListView1.Items.BeginUpdate;
  For I := 0 To NetworkList.Count - 1 Do
    begin
    WlanNetwork := NetworkList[I];
    If I < ListView1.Items.Count Then
      begin
      L := ListVIew1.Items[I];
      With L Do
        begin
        TWlanNetwork(Data).Free;
        Data := WlanNetwork;
        Caption := WlanNetwork.SSID;
        SubItems[0] := TWlanNetwork.AuthAlgoToStr(WlanNetwork.AuthenticationAlgo);
        SubItems[1] := TWlanNetwork.CipherAlgoToSTr(WLanNetwork.CipherAlgo);
        SubItems[2] := TWlanNetwork.BSSTypeToSTr(WlanNetwork.BSSType);
        SubItems[3] := Format('%d', [WlanNetwork.NumberOfBSSIDs]);
        SubItems[4] := Format('%d %%', [WlanNetwork.SignalQuality]);
        SubItems[5] := BooleanToStr(WlanNetwork.Connected);
        end;
      end
    Else begin
      L := ListView1.Items.Add;
      With L Do
        begin
        Data := WlanNetwork;
        Caption := WlanNetwork.SSID;
        SubItems.Add(TWlanNetwork.AuthAlgoToStr(WlanNetwork.AuthenticationAlgo));
        SubItems.Add(TWlanNetwork.CipherAlgoToSTr(WLanNetwork.CipherAlgo));
        SubItems.Add(TWlanNetwork.BSSTypeToSTr(WlanNetwork.BSSType));
        SubItems.Add(Format('%d', [WlanNetwork.NumberOfBSSIDs]));
        SubItems.Add(Format('%d %%', [WlanNetwork.SignalQuality]));
        SubItems.Add(BooleanToStr(WlanNetwork.Connected));
        end;
      end;
    end;

  While ListView1.Items.Count > NetworkList.Count Do
    ListView1.Items.Delete(ListView1.Items.Count - 1);

  ListView1.Items.EndUpdate;
  end
Else ListView1.Clear;

NetworkList.Free;
end;

Procedure TMainWlanClientForm.NetworkConnectButtonClick(Sender: TObject);
Var
  I : Integer;
  L : TListItem;
  P : TWlanProfile;
  N : TWlanNetwork;
  C : TWlanInterface;
begin
N := Nil;
P := Nil;
C := Nil;
CardListTimer.Enabled := False;
If Sender = NetworkConnectButton Then
  begin
  L := ListView1.Selected;
  If Assigned(L) Then
    begin
    ListView1.Selected := Nil;
    N := TWlanNetwork(L.Data);
    end;
  end
Else If Sender = ProfileConnectButton Then
  begin
  L := ProfileListView.Selected;
  If Assigned(L) Then
    begin
    ProfileListView.Selected := Nil;
    P := FProfileList[L.Index];
    C := FWlanBus.InterfaceByGuid(P.InterfaceGuid);
    end;
  end;

If (Assigned(N) Or Assigned(P)) Then
  begin
  With TConnectionSettingsForm.Create(Application, N, P, C) Do
    begin
    ShowModal;
    If Not Cancelled Then
      begin
      if Assigned(N) Then
        N.Connect(MacList, HiddenNetwork, CreateProfile, AutoConnect)
      Else If Assigned(P) Then
        P.Connect(MacList);

      MacList.Free;
      end;

    Free;
    end;
  end;

CardListTimer.Enabled := True;
end;

Procedure TMainWlanClientForm.Button2Click(Sender: TObject);
Var
  L : TListItem;
  N : TWlanNetwork;
begin
CardListTimer.Enabled := False;
L := ListView1.Selected;
If Assigned(L) Then
  begin
  N := TWlanNetwork(L.Data);
  ListView1.Selected := Nil;
  N.Disconnect;
  end;

CardListTimer.Enabled := True;
end;

Procedure TMainWlanClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CardListTimer.Enabled := False;
If Assigned(FProfileList) Then
  FreeAndNil(FProfileList);

If Assigned(FWlanBus) Then
  FreeAndNil(FWlanBus);

If Assigned(FWlanClient) Then
  FreeAndNil(FWlanClient);
end;

Procedure TMainWlanClientForm.FormCreate(Sender: TObject);
Var
  I : Integer;
  CardList : TObjectList<TWlanInterface>;
  Tmp : TWlanInterface;
begin
FWlanClient := TWlanAPIClient.NewInstance;
If Not Assigned(FWlanClient) THen
  Raise Exception.Create('Nepodaøilo se pøipojit ke službì Automatická konfigurace bezdrátových sítí');

FWlanBus := TWlanBus.Create(FWlanClient);
CardList := TObjectList<TWlanInterface>.Create(False);
If Not FWlanBus.EnumInterfaces(CardList) Then
  begin
  CardList.Free;
  FreeAndNil(FWlanClient);
  Raise Exception.Create('Nepodaøilo se získat seznam dostupných síových karet');
  end;

If CardList.Count > 0 Then
  begin
  For I := 0 To CardList.Count - 1 Do
    begin
    Tmp := CardList[I];
    ComboBox1.AddItem(Format('%s (%s)', [Tmp.Description, TWlanInterface.StateToStr(Tmp.State)]), Tmp);
    end;

  CardList.Free;
  ComboBox1.ItemIndex := 0;
  FCurrentCard := ComboBox1.Items.Objects[COmbobox1.ItemIndex] As TWlanInterface;
  RefreshNetworks(Nil);
  CardListTimer.Enabled := True;
  end;
end;

Procedure TMainWlanClientForm.HNApplyButtonClick(Sender: TObject);
begin
FHostedNetwork.SetConnectionSettings(HNSSIDEdit.Text, StrToInt(HNMaxPeersEdit.Text));
FHostedNetwork.SetSecuritySettings(HNAuthenticationComboBox.ItemIndex, HNEncryptionComboBox.ItemIndex);
FHostedNetwork.SetPassword(HNPasswordEdit.Text, HNSavePasswordCheckBox.Checked);
HostedNetworkTabSheetShow(Nil);
end;

procedure TMainWlanClientForm.HNEnableDisableButtonClick(Sender: TObject);
begin
If FHostedNetwork.Enabled Then
  begin
  If FHostedNetwork.Disable Then
    HNEnableDisableButton.Caption := 'Enable';
  end
Else begin
  If FHostedNetwork.Enable Then
    HNEnableDisableButton.Caption := 'Disable';
  end;

HNStartStopButton.Enabled := FHostedNetwork.Enabled;
HostedNetworkTabSheetShow(Nil);
end;

Procedure TMainWlanClientForm.HNPeerListViewData(Sender: TObject; Item: TListItem);
Var
  peer : TWlanHostedNetworkPeer;
begin
With Item Do
  begin
  peer := FHostedNetwork.Peers[Index];
  Caption := Format('%x-%x-%x-%x-%x=%x', [peer.MACAddress[0], peer.MACAddress[1], peer.MACAddress[2], peer.MACAddress[3], peer.MACAddress[4], peer.MACAddress[5]]);
  SubItems.Add(BooleanToStr(peer.Authenticated))
  end;
end;

Procedure TMainWlanClientForm.HNRefreshButtonClick(Sender: TObject);
begin
FHostedNetwork.Refresh;
end;

Procedure TMainWlanClientForm.HNStartStopButtonClick(Sender: TObject);
begin
If FHostedNetwork.Active Then
  begin
  If FHostedNetwork.Stop(True) Then
    HNStartStopButton.Caption := 'Start';
  end
Else begin
  If FHostedNetwork.Start(True) Then
    HNStartStopButton.Caption := 'Stop';
  end;

HNEnableDisableButton.Enabled := Not FHostedNetwork.Active;
HostedNetworkTabSheetShow(Nil);
end;

Procedure TMainWlanClientForm.HostedNetworkTabSheetShow(Sender: TObject);
begin
HNPeerListView.Items.Count := 0;
If Not Assigned(FHostedNetwork) Then
  FHostedNetwork := TWlanHostedNetwork.Create(FWlanClient)
Else FHostedNetwork.Refresh;

HNSSIDEdit.Text := FHostedNetwork.SSID;
HNPasswordEdit.Text := FHostedNetwork.Password;
If FHostedNetwork.AuthAlgo < HNAuthenticationComboBox.Items.Count Then
  HNAuthenticationComboBox.ItemIndex := FHostedNetwork.AuthAlgo;

If FHostedNetwork.CipherAlog < HNEncryptionComboBox.Items.Count Then
  HNEncryptionComboBox.ItemIndex := FHostedNetwork.CipherAlog;

HNMaxPeersEdit.Text := Format('%d', [FHostedNetwork.MaxPeers]);
HNSavePasswordCheckBox.Checked := FHostedNetwork.Persistent;
If FHostedNetwork.Enabled Then
  HNEnableDisableButton.Caption := 'Disable'
Else HNEnableDisableButton.Caption := 'Enable';

If FHostedNetwork.Active Then
  HNStartStopButton.Caption := 'Stop'
Else HNStartStopButton.Caption := 'Start';

HNStartStopButton.Enabled := FHostedNetwork.Enabled;
HNEnableDisableButton.Enabled := Not FHostedNetwork.Active;
If FHostedNetwork.Active Then
  begin
  HNMACAddressEdit.Text := Format('%x-%x-%x-%x-%x-%x', [FHostedNetwork.MACAddress[0], FHostedNetwork.MACAddress[1], FHostedNetwork.MACAddress[2], FHostedNetwork.MACAddress[3], FHostedNetwork.MACAddress[4], FHostedNetwork.MACAddress[5]]);
  HNDeviceIdGuid.Text := GUIDToString(FHostedNetwork.DeviceID);
  HNFrequencyEdit.Text := Format('%d', [FHostedNetwork.Channel]);
  HNPeerCountEdit.Text := Format('%d', [FHostedNetwork.PeerCount]);
  HNPeerListView.Items.Count := FHostedNetwork.PeerCount;
  end;
end;

Procedure TMainWlanClientForm.InterfaceInfoSheetShow(Sender: TObject);
begin
If Assigned(FCurrentCard) Then
  begin
  If FCurrentCard.QueryConnectionInfo(FInterfaceInfo) Then
    begin
    InterfaceNameEdit.Text := FCurrentCard.Description;
    InterfaceGuidEdit.Text := GUIDToString(FCurrentCard.Guid);
    InterfaceStateEdit.Text := TWlanInterface.StateToStr(FInterfaceInfo.State);
    InterfaceSSIDEdit.Text := FInterfaceInfo.SSID;
    InterfaceProfileEdit.Text := FInterfaceInfo.ProfileName;
    InterfaceAuthEdit.Text := TWlanNetwork.AuthAlgoToStr(TWlanNetworkAuthAlgorithm(FInterfaceInfo.AuthAlog));
    InterfaceEncryptionEdit.Text := TWlanNetwork.CipherAlgoToSTr(FInterfaceInfo.CipherAlgo);
    InterfaceMACEdit.Text := Format('%.2x-%.2x-%.2x-%.2x-%.2x-%.2x', [FInterfaceInfo.MACAddress[0], FInterfaceInfo.MACAddress[1], FInterfaceInfo.MACAddress[2], FInterfaceInfo.MACAddress[3], FInterfaceInfo.MACAddress[4], FInterfaceInfo.MACAddress[5]]);
    InterfaceChannelEdit.Text := Format('%d', [FInterfaceInfo.Channel]);
    InterfaceModeEdit.Text := TWlanInterface.ConnectonModeToStr(FInterfaceInfo.ConnectionMode);
    end;
  end;
end;

procedure TMainWlanClientForm.ListView1AdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
Var
  N : TWlanNetwork;
begin
N := Item.Data;
If N.SSID = FInterfaceInfo.SSID Then
  Sender.Canvas.Font.Style := [fsBold]
Else Sender.Canvas.Font.Style := [];
end;

Procedure TMainWlanClientForm.ListView1Deletion(Sender: TObject; Item: TListItem);
begin
If Assigned(Item.Data) Then
  TWlanNetwork(Item.Data).Free;

Item.Data := Nil;
end;

Procedure TMainWlanClientForm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);

Var
  Net : TWlanNetwork;
begin
Net := Item.Data;
NetworkConnectButton.Enabled := (Selected) And (Not Net.Connected);
Button2.Enabled := (Selected) And (Net.Connected);
end;

Procedure TMainWlanClientForm.ProfileDeleteButtonClick(Sender: TObject);
Var
  L : TListItem;
  profile : TWlanProfile;
begin
L := ProfileListView.Selected;
If Assigned(L) Then
  begin
  profile := FProfileList[L.Index];
  profile.Delete;
  RefreshProfiles(ComboBox1);
  end;
end;

Procedure TMainWlanClientForm.ProfileListViewAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
Var
  P : TWlanProfile;
begin
P := FProfileList[Item.Index];
If P.Name = FInterfaceInfo.ProfileName Then
  Sender.Canvas.Font.Style := [fsBold]
Else Sender.Canvas.Font.Style := [];
end;

Procedure TMainWlanClientForm.ProfileListViewData(Sender: TObject; Item: TListItem);
Var
  typeStr : WideString;
  profile : TWlanProfile;
begin
With Item Do
  begin
  profile := FProfileList[Index];
  Caption := profile.Name;
  typeStr := '';
  If profile.User Then
    typeStr := ' User';

  If profile.GroupPolicy Then
    typeStr := typeStr + ' GP';

  If typeStr = '' Then
    typeStr := 'Global';

  SubItems.Add(typeStr);
  SubItems.Add(profile.SSID);
  SubItems.Add(profile.Password);
  end;
end;

Procedure TMainWlanClientForm.ProfileListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
ProfileConnectButton.Enabled := Assigned(Item);
ProfileDeleteButton.Enabled := Assigned(Item);
end;

Procedure TMainWlanClientForm.ProfileSheetShow(Sender: TObject);
begin
RefreshProfiles(ComboBox1);
end;

End.

