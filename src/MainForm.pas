Unit MainForm;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, WLanAPI,
  WlanAPIClient, WlanBus, WlanInterface, wlanNetwork, Vcl.ComCtrls,
  WlanBssEntry, WlanProfile, Vcl.OleCtrls, SHDocVw, Generics.Collections;

Type
  TForm1 = Class (TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListView1: TListView;
    CardListTimer: TTimer;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ProfileSheet: TTabSheet;
    ProfileMenuPanel: TPanel;
    ProfileListView: TListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RefreshNetworks(Sender: TObject);
    procedure ListView1Deletion(Sender: TObject; Item: TListItem);
    procedure RefreshNetworkCards(Sender: TObject);
    Procedure RefreshAll(Sender:TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ProfileListViewData(Sender: TObject; Item: TListItem);
    procedure ProfileSheetShow(Sender: TObject);
  Private
    FWlanClient : TWlanAPICLient;
    FWlanBus : TWlanBus;
    FProfileList : TObjectList<TWlanProfile>;
    Function BooleanToStr(X:Boolean):WideSTring;
    Procedure RefreshProfiles(AComboBox:TComboBox);
  end;

Var
  Form1: TForm1;

Implementation

{$R *.DFM}

Uses
  APSelectionForm;


Procedure TForm1.RefreshAll(Sender:TObject);
begin
RefreshNetworkCards(ComboBox1);
RefreshNetworks(Nil);
end;

Function TForm1.BooleanToStr(X:Boolean):WideSTring;
begin
If X Then
  Result := 'Ano'
Else Result := 'Ne';
end;

Procedure TForm1.RefreshNetworkCards(Sender: TObject);
Var
 CardList : TObjectList<TWlanInterface>;
 Card : TWlanInterface;
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
    Card := TWlanInterface(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    ItemGuid := Card.Guid;
    LastState := Card.State;
    end;

  For I := 0 To CardList.Count - 1 Do
    begin
    Card := CardList[I];
    If I < ComboBox1.Items.Count Then
      begin
      ComboBox1.Items.Strings[I] := Format('%s (%s)', [Card.Description, TWlanInterface.StateToStr(Card.State)]);
      ComboBox1.Items.Objects[I].Free;
      ComboBox1.Items.Objects[I] := Card;
      If ItemGuid = Card.Guid Then
        begin
        SelectedSurvived := True;
        ComboBox1.ItemIndex := I;
        end;

      If Card.State <> LastState Then
        RefreshNetworks(Nil);
      end
    Else ComboBox1.AddItem(Format('%s (%s)', [Card.Description, TWlanInterface.StateToStr(Card.State)]), Card);
    end;

  While ComboBox1.Items.Count > CardList.Count Do
    ComboBox1.Items.Delete(ComboBox1.Items.Count - 1);

  If Not SelectedSurvived Then
    ComboBox1.ItemIndex := 0;

  ComboBox1.Invalidate;
  end;

CardList.Free;
end;

Procedure TForm1.RefreshProfiles(AComboBox:TComboBox);
Var
  tmpList2 : TObjectList<TWlanProfile>;
  tmpList : TObjectList<TWlanProfile>;
  wlanInterface : TWlanInterface;
begin
If ComboBox1.ItemIndex > -1 Then
  begin
  WlanInterface := TWlanInterface(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  tmpList := TObjectList<TWlanProfile>.Create;
  If wlanInterface.EnumProfiles(tmpList) Then
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
end;

Procedure TForm1.RefreshNetworks(Sender: TObject);
Var
  I : Integer;
  NetworkList : TObjectList<TWlanNetwork>;
  WlanInterface : TWlanInterface;
  WlanNetwork : TWlanNetwork;
  L : TListItem;
begin
If ComboBox1.ItemIndex > -1 Then
  begin
  WlanInterface := TWlanInterface(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  NetworkList := TObjectList<TWlanNetwork>.Create(False);
  If WlanInterface.EnumNetworks(NetworkList) Then
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
  end
Else ListView1.Clear;
end;

Procedure TForm1.Button1Click(Sender: TObject);
Var
  I : Integer;
  L : TListItem;
  N : TWlanNetwork;
begin
CardListTimer.Enabled := False;
L := ListView1.Selected;
If Assigned(L) Then
  begin
  ListView1.Selected := Nil;
  N := TWlanNetwork(L.Data);
  With TForm2.Create(Application, N) Do
    begin
    ShowModal;
    If Not Cancelled Then
      begin
      N.Connect(MacList);
      For I := 0 To MacList.Count - 1 Do
        TWlanBssEntry(MacList[I]).Free;

      MacList.Clear;
      MacList.Free;
      end;

    Free;
    end;
  end;

CardListTimer.Enabled := True;
end;

Procedure TForm1.Button2Click(Sender: TObject);
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

Procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CardListTimer.Enabled := False;
If Assigned(FProfileList) Then
  FreeAndNil(FProfileList);

If Assigned(FWlanBus) Then
  FreeAndNil(FWlanBus);

If Assigned(FWlanClient) Then
  FreeAndNil(FWlanClient);
end;

Procedure TForm1.FormCreate(Sender: TObject);
Var
  I : Integer;
  CardList : TObjectList<TWlanInterface>;
  Tmp : TWlanInterface;
begin
FWlanClient := TWlanAPIClient.NewInstance;
If Not Assigned(FWlanClient) THen
  Raise Exception.Create('Nepoda¯ilo se p¯ipojit ke sluûbÏ Automatick· konfigurace bezdr·tov˝ch sÌtÌ');

FWlanBus := TWlanBus.Create(FWlanClient);
CardList := TObjectList<TWlanInterface>.Create(False);
If Not FWlanBus.EnumInterfaces(CardList) Then
  begin
  CardList.Free;
  FreeAndNil(FWlanClient);
  Raise Exception.Create('Nepoda¯ilo se zÌskat seznam dostupn˝ch sÌùov˝ch karet');
  end;

For I := 0 To CardList.Count - 1 Do
  begin
  Tmp := CardList[I];
  ComboBox1.AddItem(Format('%s (%s)', [Tmp.Description, TWlanInterface.StateToStr(Tmp.State)]), Tmp);
  end;

CardList.Free;
ComboBox1.ItemIndex := 0;
RefreshNetworks(Nil);
CardListTimer.Enabled := True;
end;

Procedure TForm1.ListView1Deletion(Sender: TObject; Item: TListItem);
begin
If Assigned(Item.Data) Then
  TWlanNetwork(Item.Data).Free;

Item.Data := Nil;
end;

Procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);

Var
  Net : TWlanNetwork;
begin
Net := Item.Data;
Button1.Enabled := (Selected) And (Not Net.Connected);
Button2.Enabled := (Selected) And (Net.Connected);
end;

Procedure TForm1.ProfileListViewData(Sender: TObject; Item: TListItem);
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
  SubItems.Add(profile.Password);
  end;
end;

Procedure TForm1.ProfileSheetShow(Sender: TObject);
begin
RefreshProfiles(ComboBox1);
end;

End.

