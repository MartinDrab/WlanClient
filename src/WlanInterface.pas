Unit WlanInterface;

Interface

Uses
  Windows, Classes, WlanAPI, WlanAPIClient, WlanNetwork, wlanProfile,
  Generics.Collections;

Type
  TWlanInterfaceState = (
    wisNotReady, wisConnected, wisAdhocFormed,
    wisDisconnecting, wisDisconnected, wisAssociating,
    wisDiscovering, wisAuthenticationg);

  TWlanInterfaceInfo = Record
    State : TWlanInterfaceState;
    ConnectionMode : WLAN_CONNECTION_MODE;
    ProfileName : WideString;
    SSID : WideString;
    MACAddress : DOT11_MAC_ADDRESS;
    AuthAlog : Cardinal;
    CipherAlgo : Cardinal;
    RxRate : Cardinal;
    TxRate : Cardinal;
    Channel : Cardinal;
    end;
  PWlanInterfaceInfo = ^TWlanInterfaceInfo;

  TWlanInterface = Class
    Private
      FGuid : TGUID;
      FDescription : WideString;
      FState : TWlanInterfaceState;
      FClient : TWlanAPIClient;
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; ARecord:PWLAN_INTERFACE_INFO_LIST):TWlanInterface;
      Class Function StateToStr(AState:TWlanInterfaceState):WideString;
      Class Function ConnectonModeToStr(AMode:WLAN_CONNECTION_MODE):WideString;

      Function EnumNetworks(AList:TObjectList<TWlanNetwork>):Boolean;
      Function EnumProfiles(AList:TObjectList<TWlanProfile>):Boolean;
      Function NetworkBySSID(ASSID:WideString):TWlanNetwork;
      Function Connect(AParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
      Function Disconnect:Boolean;
      Function Query(OpCode:WLAN_INTF_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;
      Function QueryConnectionInfo(Var AInfo:TWlanInterfaceInfo):Boolean;

      Property Guid : TGUID Read FGuid;
      Property Description : WideString Read FDescription;
      Property State : TWlanInterfaceState Read FState;
    end;

Implementation

Uses
  SysUtils;

Class Function TWlanInterface.NewInstance(AClient:TWlanAPIClient; ARecord:PWLAN_INTERFACE_INFO_LIST):TWlanInterface;
begin
Try
  Result := TWlanInterface.Create;
Except
  end;

If Assigned(Result) Then
  begin
  Result.FGuid := ARecord.InterfaceInfo[ARecord.dwIndex].InterfaceGuid;
  Result.FState := TWlanInterfaceSTate(ARecord.InterfaceInfo[ARecord.dwIndex].isState);
  Result.FDescription := Copy(WideString(ARecord.InterfaceInfo[ARecord.dwIndex].strInterfaceDescription), 1, Length(WideString(ARecord.InterfaceInfo[ARecord.dwIndex].strInterfaceDescription)));
  Result.FClient := AClient;
  end;
end;

Class Function TWlanInterface.StateToStr(AState:TWlanInterfaceState):WideString;
begin
Case AState Of
  wisNotReady : Result := 'Not ready';
  wisConnected : Result := 'Connected';
  wisAdhocFormed : Result := 'Ad-hoc network';
  wisDisconnecting : Result := 'disconnecting';
  wisDisconnected : Result := 'Disconnected';
  wisAssociating : Result := 'Connecting';
  wisDiscovering : Result := 'Discovering';
  wisAuthenticationg : Result := 'Authenticating';
  end;
end;

Class Function TWlanInterface.ConnectonModeToStr(AMode:WLAN_CONNECTION_MODE):WideString;
begin
Case AMode Of
  wlan_connection_mode_profile: ;
  wlan_connection_mode_temporary_profile: Result := 'Profile';
  wlan_connection_mode_discovery_secure: Result := 'Secure discovery';
  wlan_connection_mode_discovery_unsecure: Result := 'Unsecure discovery';
  wlan_connection_mode_auto: Result := 'Automatic';
  wlan_connection_mode_invalid: Result := 'Invalid';
  Else Result := Format('<unknown> (%d)', [Ord(AMode)]);
  end;
end;

Function TWlanInterface.EnumNetworks(AList:TObjectList<TWlanNetwork>):Boolean;
Var
  Flags : DWORD;
  Networks : PWLAN_AVAILABLE_NETWORK_LIST;
  I, J : Integer;
  Tmp : TWlanNetwork;
begin
Flags := 0;
Result := FClient._WlanGetAvailableNetworkList(@FGuid, Flags, Networks);
If Result Then
  begin
  For I := 0 To Networks.dwNumberOfItems - 1 Do
    begin
    Networks.dwIndex := I;
    If ((Networks.Network[Networks.dwIndex].dwFlags And WLAN_AVAILABLE_NETWORK_HAS_PROFILE) = 0) Then
      begin
      Tmp := TWlanNetwork.NewInstance(FClient, FGuid, Networks);
      Result := Assigned(Tmp);
      If Result Then
        begin
        AList.Add(Tmp);
        end
      Else begin
        For J := I - 1 DownTo 0 Do
          TWlanNetwork(AList[J]).Free;

        AList.Clear;
        Break;
        end;
      end;
    end;

  WlanFreeMemory(Networks);
  end;
end;


Function TWlanInterface.EnumProfiles(AList:TObjectList<TWlanProfile>):Boolean;
Var
  I : Integer;
  tmp : TWlanProfile;
  profile : PWLAN_PROFILE_INFO;
  profileArray : PWLAN_PROFILE_INFO_LIST;
begin
Result := FClient._WlanGetProfileList(@FGuid, profileArray);
If Result Then
  begin
  profile := @profileArray.List;
  For I := 0 To profileArray.NumberOfItems - 1 Do
    begin
    profileArray.Index := I;
    tmp := TWlanProfile.NewInstance(FClient, FGuid, profile^);
    If Assigned(tmp) Then
      AList.Add(tmp)
    Else begin
      AList.Clear;
      Break;
      end;

    Inc(profile);
    end;

  WlanFreeMemory(profileArray);
  end;
end;


Function TWlanInterface.Connect(AParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
begin
Result := FClient._WlanConnect(@FGUid, AParameters);
end;

Function TWlanInterface.Disconnect:Boolean;
begin
Result := FClient._WlanDisconnect(@FGuid);
end;

Function TWlanInterface.NetworkBySSID(ASSID:WideString):TWlanNetwork;
Var
  I : Integer;
  L : TObjectList<TWlanNetwork>;
begin
Result := Nil;
L := TObjectList<TWlanNetwork>.Create;
If EnumNetworks(L) Then
  begin
  For I := 0 To L.Count - 1 Do
    begin
    If L[I].SSID = ASSID Then
      begin
      Result := L[I];
      L.OwnsObjects := False;
      L.Delete(I);
      L.OwnsObjects := True;
      Break;
      end;
    end;
  end;

L.Free;
end;

Function TWlanInterface.Query(OpCode:WLAN_INTF_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;
begin
Result := FCLient._WlanQueryInterface(@FGuid, OpCode, DataSize, Data, ValueType);
end;

Function TWlanInterface.QueryConnectionInfo(Var AInfo:TWlanInterfaceInfo):Boolean;
Var
  I : Integer;
  ChannelNumber : PCardinal;
  caSize : Cardinal;
  ca : PWLAN_CONNECTION_ATTRIBUTES;
  vt : WLAN_OPCODE_VALUE_TYPE;
begin
ca := Nil;
caSize := 0;
Result := Query(wlan_intf_opcode_current_connection, caSize, Pointer(ca), vt);
If Result Then
  begin
  AInfo.State := TWlanInterfaceState(ca.State);
  AInfo.ConnectionMode := ca.ConnectionMode;
  AInfo.ProfileName := Copy(PWideChar(@ca.ProfileName), 1, StrLen(ca.ProfileName));
  SetLength(AInfo.SSID, ca.AssociationAttributes.SSID.uSSIDLength);
  For I := 0 To ca.AssociationAttributes.SSID.uSSIDLength - 1 Do
    AInfo.SSID[I + 1] := WideChar(ca.AssociationAttributes.SSID.ucSSID[I]);

  AInfo.MACAddress := ca.AssociationAttributes.MACAddress;
  AInfo.AuthAlog := ca.SecurityAttributes.AuthAlgorithm;
  AInfo.CipherAlgo := ca.SecurityAttributes.CipherAlgorithm;
  AInfo.RxRate := ca.AssociationAttributes.RxRate;
  AInfo.TxRate := ca.AssociationAttributes.TxRate;
  WlanFreeMemory(ca);
  ChannelNumber := Nil;
  Result := Query(wlan_intf_opcode_channel_number, caSize, Pointer(ChannelNumber), vt);
  If Result Then
    begin
    AInfo.Channel := ChannelNumber^;
    WlanFreeMemory(ChannelNumber);
    end;
  end;
end;

End.

