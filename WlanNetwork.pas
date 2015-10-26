Unit WlanNetwork;

Interface

Uses
  WlanAPI, WlanAPIClient, WlanInterface,
  Classes, Windows;

Type
  TWlanNetworkBssType = (
      wnbtUnknown, wnbtInfrastructure, wnbtIndependent,
      wnbtAny);

  TWlanNetworkAuthAlgorithm = (
      wnaaUnknown, wnaaOpen, wnaa80211SharedKey,
      wnaaWPA, wnaaWPAPSK, wnaaWPANone, wnaaRSNA,
      wnaaRSNAPSK, wnaaProprietary);



  TWlanNetwork = Class
    Private
      FInterface : TWlanInterface;
      FClient : TWlanAPIClient;

      FProfileName : WideString;
      FSSID : WideString;
      FBSSType : TWlanNetworkBSSType;
      FNumberOfBSSIDs : Cardinal;
      FConnectable : Boolean;
      FNotConnectableReason : Cardinal;
      FNumberOfPhyTypes : Cardinal;
      FSignalQuality : Cardinal;
      FSecurityEnabled : Boolean;
      FAuthenticationAlgo : TWlanNetworkAuthAlgorithm;
      FCipherAlgo : Cardinal;
      FConnected : Boolean;
      FHasProfile : Boolean;
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; AInterface:TWlanInterface; ARecord:PWLAN_AVAILABLE_NETWORK_LIST):TWlanNetwork;
      Class Function AuthAlgoToStr(AAlgo:TWlanNetworkAuthAlgorithm):WideString;
      Class Function CipherAlgoToSTr(AAlgo:Cardinal):WideString;
      Class Function BSSTypeToSTr(AType:TWlanNetworkBSSType):WideString;
      Function Connect(AEntries:TList = Nil):Boolean;
      Function Disconnect:Boolean;
      Function GetBssList(AList:TList):Boolean;

      Property ProfileName : WideString Read FProfileName;
      Property SSID : WideString Read FSSID;
      Property BSSType : TWlanNetworkBSSType Read FBSSType;
      Property NumberOfBSSIDs : Cardinal Read FNumberOfBSSIDs;
      Property Connectable : Boolean Read FConnectable;
      Property NumberOfPhyTypes : Cardinal Read FNumberOfPhyTypes;
      Property SignalQuality : Cardinal Read FSignalQuality;
      Property SecurityEnabled : Boolean Read FSecurityEnabled;
      Property AuthenticationAlgo : TWlanNetworkAuthAlgorithm Read FAuthenticationAlgo;
      Property CipherAlgo : Cardinal Read FCipherAlgo;
      Property Connected : Boolean Read FConnected;
      Property HasProfile : Boolean Read FHasProfile;
    end;

Implementation

Uses
  WlanBssEntry;


Class Function TWlanNetwork.NewInstance(AClient:TWlanAPIClient; AInterface:TWlanInterface; ARecord:PWLAN_AVAILABLE_NETWORK_LIST):TWlanNetwork;
Var
  Rec : PWLAN_AVAILABLE_NETWORK;
begin
Try
  Result := TWlanNetwork.Create;
Except
  Result:= Nil;
  end;

If Assigned(Result) Then
  begin
  Result.FClient := AClient;
  Result.FInterface := AInterface;
  Rec := @ARecord.Network[ARecord.dwIndex];
  Result.FProfileName := Copy(WideString(Rec.strProfileName), 1, Length(WideString(Rec.strProfileName)));
  Result.FSSID := Copy(AnsiString(PAnsiChar(@Rec.dot11Ssid.ucSSID)), 1, Rec.dot11Ssid.uSSIDLength);
  Result.FBSSType := TWlanNetworkBSSType(Rec.dot11BssType);
  Result.FNumberOfBSSIDs := Rec.uNumberOfBssids;
  Result.FConnectable := Rec.bNetworkConnectable;
  Result.FNotConnectableReason := Rec.wlanNotConnectableReason;
  Result.FNumberOfPhyTypes := Rec.uNumberOfPhyTypes;
  Result.FSignalQuality := Rec.wlanSignalQuality;
  Result.FSecurityEnabled := Rec.bSecurityEnabled;
  If Rec.dot11DefaultAuthAlgorithm >= DOT11_AUTH_ALGO_IHV_START Then
    Result.FAuthenticationAlgo := wnaaProprietary
  Else Result.FAuthenticationAlgo := TWlanNetworkAuthAlgorithm(Rec.dot11DefaultAuthAlgorithm);
  Result.FCipherAlgo := Rec.dot11DefaultCipherAlgorithm;
  Result.FConnected := (Rec.dwFlags And WLAN_AVAILABLE_NETWORK_CONNECTED) > 0;
  Result.FHasProfile := (Rec.dwFlags And WLAN_AVAILABLE_NETWORK_HAS_PROFILE) > 0;
  end;
end;

Class Function TWlanNetwork.AuthAlgoToStr(AAlgo:TWlanNetworkAuthAlgorithm):WideString;
begin
Case AAlgo Of
  wnaaUnknown : Result := 'Neznámá';
  wnaaOpen : Result := 'Otevøená';
  wnaa80211SharedKey : Result := '80211 Shared Key';
  wnaaWPA : Result := 'WPA';
  wnaaWPAPSK : Result := 'WPA-PSK';
  wnaaWPANone : Result := 'WPA-None';
  wnaaRSNA : Result := 'RSNA';
  wnaaRSNAPSK : Result := 'RSNA-PSK';
  wnaaProprietary : Result := 'Proprietární';
  end;
end;

Class Function TWlanNetwork.CipherAlgoToSTr(AAlgo:Cardinal):WideString;
begin
Case AAlgo Of
  DOT11_CIPHER_ALGO_NONE : Result := 'Žádné';
  DOT11_CIPHER_ALGO_WEP40 : Result := 'WEP-40';
  DOT11_CIPHER_ALGO_TKIP : Result := 'TKIP';
  DOT11_CIPHER_ALGO_CCMP : Result :='AES-COMP';
  DOT11_CIPHER_ALGO_WEP104 : Result := 'WEP-104';
  DOT11_CIPHER_ALGO_WPA_USE_GROUP : Result := 'WPA-Group';
  DOT11_CIPHER_ALGO_WEP : Result := 'WEP';
  DOT11_CIPHER_ALGO_IHV_START..DOT11_CIPHER_ALGO_IHV_END : Result := 'Proprietární';
  end;
end;

Class Function TWlanNetwork.BSSTypeToSTr(AType:TWlanNetworkBSSType):WideString;
begin
Case AType Of
  wnbtUnknown : Result := 'Neznámý';
  wnbtInfrastructure : Result := 'Standardní';
  wnbtIndependent : Result := 'Ad-hoc';
  wnbtAny : Result := 'Any';
  end;
end;

Function TWlanNetwork.Connect(AEntries:TList = Nil):Boolean;
Var
  I : Integer;
  Params : WLAN_CONNECTION_PARAMETERS;
  MacList : PDOT11_BSSID_LIST;
  S : DOT11_SSID;
begin
If FSecurityEnabled Then
  Params.wlanConnectionMode := wlan_connection_mode_discovery_secure
Else Params.wlanConnectionMode := wlan_connection_mode_discovery_unsecure;
Params.strProfile := Nil;
// If FHasProfile Then
//  Params.strProfile := PWideChar(FProfileName);
Result := True;
MacList := Nil;
If (Assigned(AEntries)) And (AEntries.Count > 0) Then
  begin
  MacList := WlanAllocateMemory(SizeOf(DOT11_BSSID_LIST) + AEntries.Count * SizeOf(DOT11_MAC_ADDRESS));
  Result := Assigned(MacList);
  If Result Then
    begin
    MacList.Header.HdrType := NDIS_OBJECT_TYPE_DEFAULT;
    MacList.Header.Revision := DOT11_BSSID_LIST_REVISION_1;
    MacList.Header.Size := SizeOf(DOT11_BSSID_LIST) + AEntries.Count * SizeOf(DOT11_MAC_ADDRESS);
    MacList.uNumOfEntries := AEntries.Count;
    MacList.uTotalNumOfEntries := AEntries.Count;
    For I := 0 To AEntries.Count - 1 Do
      MacList.BSSIDs[I] := TWlanBssEntry(AEntries[I]).MacAddress;

    Params.pDesiredBssidList := MacList;
    end;
  end
Else Params.pDesiredBssidList := Nil;

If Result Then
  begin
  Params.dot11BssType := Cardinal(FBssType);
  Params.dwFlags := 0;
  Params.pDot11Ssid := @S;
  Params.pDot11Ssid.uSSIDLength := Length(FSSID);
  For I := 0 To Params.pDot11Ssid.uSSIDLength - 1 Do
    Params.pDot11Ssid.ucSSID[I] := Ord(FSSID[I + 1]);

  Result := FInterface.Connect(@Params);
  If Assigned(MacList) Then
    WlanFreeMemory(MacList);
  end;
end;

Function TWlanNetwork.Disconnect:Boolean;
begin
Result := FInterface.Disconnect;
end;

Function TWlanNetwork.GetBssList(AList:TList):Boolean;
Var
  I, J : Integer;
  pSSID : DOT11_SSID;
  List : PWLAN_BSS_LIST;
  Tmp : TWlanBssEntry;
begin
List := Nil;
pSSID.uSSIDLength := Length(FSSID);
For I := 0 To pSSID.uSSIDLength - 1 Do
  pSSID.ucSSID[I] := Ord(FSSID[I + 1]);

Result := FInterface.GetNetworkBssList(Nil, Ord(FBssType), FSecurityEnabled, List);
If Result Then
  begin
  For I := 0 To List.dwNumberOfItems - 1 Do
    begin
    Tmp := TWlanBssEntry.NewInstance(@List.wlanBssEntries[I]);
    Result := Assigned(Tmp);
    If Result Then
      begin
      If Tmp.SSID = FSSID Then
        AList.Add(Tmp)
      Else Tmp.Free;
      end
    Else begin
      For J := 0 To AList.Count - 1 Do
        TWlanBssEntry(AList[J]).Free;

      AList.Clear;
      Break;
      end;
    end;

  WlanFreeMemory(List);
  end;
end;


End.

