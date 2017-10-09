Unit APSelectionForm;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  wlanInterface, wlanNetwork, wlanBssEntry, wlanAPI, WlanProfile, Vcl.ExtCtrls, Vcl.StdCtrls,
  Generics.Collections;

type
  TConnectionSettingsForm = Class (TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Button1: TButton;
    CreateProfileCheckBox: TCheckBox;
    AutoConnectCheckBox: TCheckBox;
    HiddenNetworkCheckBox: TCheckBox;
    Procedure FormCreate(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
  Private
    FCancelled : Boolean;
    FNetwork : TWlanNetwork;
    FProfile : TWlanProfile;
    FCard : TWlanInterface;
    FMACList : TObjectList<TWlanBssEntry>;
    FCreateProfile : Boolean;
    FAutoConnect : Boolean;
    FHiddenNetwork : Boolean;
  Public
    Constructor Create(AOwner:TComponent; ANetwork:TWlanNetwork; AProfile:TWlanProfile; ACard:TWlanInterface); Reintroduce;

    Property MacList : TObjectList<TWlanBssEntry> Read FMacList;
    Property Cancelled : Boolean Read FCancelled;
    Property CreateProfile : Boolean Read FCreateProfile;
    Property AutoConnect : Boolean Read FAutoConnect;
    Property HiddenNetwork : Boolean Read FHiddenNetwork;
  end;


Implementation

{$R *.DFM}

Procedure TConnectionSettingsForm.Button1Click(Sender: TObject);
Var
  L : TListItem;
  I : Integer;
  Entry : TWlanBssEntry;
begin
FCancelled := False;
FMacList := TObjectList<TWlanBssEntry>.Create;
For I := 0 To ListView1.Items.Count - 1 Do
  begin
  L := ListView1.Items[I];
  If L.Checked Then
    begin
    Entry := L.Data;
    L.Data := Nil;
    FMacList.Add(Entry);
    end;
  end;

FCreateProfile := CreateProfileCheckBox.Checked;
FAutoConnect := AutoConnectCheckBox.Checked;
FHiddenNetwork := HiddenNetworkCheckBox.Checked;
Close;
end;

Constructor TConnectionSettingsForm.Create(AOwner:TComponent; ANetwork:TWlanNetwork; AProfile:TWlanProfile; ACard:TWlanInterface);
begin
FNetwork := ANetwork;
FProfile := AProfile;
FCard := ACard;
FCancelled := True;
Inherited Create(AOwner);
end;


Procedure TConnectionSettingsForm.FormCreate(Sender: TObject);
Var
  I : Integer;
  List : TObjectList<TWlanBssEntry>;
  Entry : TWlanBssEntry;
begin
If (Not Assigned(FNetwork)) And (Assigned(FCard)) Then
  FNetwork := FCard.NetworkBySSID(FProfile.SSID);

If Assigned(FNetwork) Then
  begin
  CreateProfileCheckBox.Enabled := Not Assigned(FProfile);
  AutoConnectCheckBox.Enabled := Not Assigned(FProfile);
  HiddenNetworkCheckBox.Enabled := Not Assigned(FProfile);
  List := TObjectList<TWlanBssEntry>.Create(False);
  If FNetwork.GetBssList(List) Then
    begin
    For I := 0 To List.Count - 1 Do
      begin
      Entry := List[I];
      With ListView1.Items.Add Do
        begin
        Data := Entry;
        Caption := TWlanBssEntry.MACToSTr(Entry.MacAddress);
        SubItems.Add(Entry.SSID);
        SubItems.Add(Format('%d', [Entry.Rssi]));
        SubItems.Add(Format('%d %%', [Entry.LinkQuality]));
        SubItems.Add(Format('%d MHz', [Entry.Frequency Div 1000]));
        SubItems.Add(Format('%d', [Entry.Channel]))
        end;
      end;
    end;

  List.Free;
  end;
end;


End.

