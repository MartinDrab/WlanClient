Unit APSelectionForm;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  wlanNetwork, wlanBssEntry, wlanAPI, Vcl.ExtCtrls, Vcl.StdCtrls,
  Generics.Collections;

type
  TForm2 = Class (TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Button1: TButton;
    Procedure FormCreate(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure ListView1Deletion(Sender: TObject; Item: TListItem);
  Private
    FCancelled : Boolean;
    FNetwork : TWlanNetwork;
    FMACList : TList;
  Public
    Constructor Create(AOwner:TComponent; ANetwork:TWlanNetwork); Reintroduce;

    Property MacList : TList Read FMacList;
    Property Cancelled : Boolean Read FCancelled;
  end;


Implementation

{$R *.DFM}

Procedure TForm2.Button1Click(Sender: TObject);
Var
  L : TListItem;
  I : Integer;
  Entry : TWlanBssEntry;
begin
FCancelled := False;
FMacList := TList.Create;
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

Close;
end;

Constructor TForm2.Create(AOwner:TComponent; ANetwork:TWlanNetwork);
begin
FNetwork := ANetwork;
FCancelled := True;
Inherited Create(AOwner);
end;


Procedure TForm2.FormCreate(Sender: TObject);
Var
  I : Integer;
  List : TObjectList<TWlanBssEntry>;
  Entry : TWlanBssEntry;
begin
List := TObjectList<TWlanBssEntry>.Create;
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

Procedure TForm2.ListView1Deletion(Sender: TObject; Item: TListItem);
begin
If Assigned(Item.Data) Then
  begin
  TWlanBssEntry(Item.Data).Free;
  Item.Data := Nil;
  end;
end;

End.
