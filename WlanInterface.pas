Unit WlanInterface;

Interface

Uses
  Windows, Classes, WlanAPI, WlanAPIClient, WlanNetwork,
  Generics.Collections;

Type
  TWlanInterfaceState = (
    wisNotReady, wisConnected, wisAdhocFormed,
    wisDisconnecting, wisDisconnected, wisAssociating,
    wisDiscovering, wisAuthenticationg);

  TWlanInterface = Class
    Private
      FGuid : TGUID;
      FDescription : WideString;
      FState : TWlanInterfaceState;
      FClient : TWlanAPIClient;
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; ARecord:PWLAN_INTERFACE_INFO_LIST):TWlanInterface;
      Class Function StateToStr(AState:TWlanInterfaceState):WideString;
      Function EnumNetworks(AList:TObjectList<TWlanNetwork>):Boolean;

      Function Connect(AParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
      Function Disconnect:Boolean;
      Function GetNetworkBssList(pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; Var pWlanBssList:PWLAN_BSS_LIST):Boolean;

      Property Guid : TGUID Read FGuid;
      Property Description : WideString Read FDescription;
      Property State : TWlanInterfaceState Read FState;
    end;

Implementation


Class Function TWlanInterface.NewInstance(AClient:TWlanAPIClient; ARecord:PWLAN_INTERFACE_INFO_LIST):TWlanInterface;
begin
Try
  Result := TWlanInterface.Create;
Except
  If Assigned(Result) Then
    begin
    Result.Free;
    Result := Nil;
    end;
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
  wisNotReady : Result := 'nep¯ipravena';
  wisConnected : Result := 'p¯ipojena';
  wisAdhocFormed : Result := 'sÌù ad-hoc';
  wisDisconnecting : Result := 'odpojov·nÌ';
  wisDisconnected : Result := 'odpojena';
  wisAssociating : Result := 'p¯ipojov·nÌ';
  wisDiscovering : Result := 'vyhled·v·nÌ sÌtÌ';
  wisAuthenticationg : Result := 'autentizace';
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

Function TWlanInterface.Connect(AParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
begin
Result := FClient._WlanConnect(@FGUid, AParameters);
end;

Function TWlanInterface.Disconnect:Boolean;
begin
Result := FClient._WlanDisconnect(@FGuid);
end;

Function TWlanInterface.GetNetworkBssList(pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; Var pWlanBssList:PWLAN_BSS_LIST):Boolean;
begin
Result := FClient._WlanGetNetworkBssList(@FGuid, pDot11Ssid, dot11BssType, bSecurityEnabled, pWlanBssList);
end;

End.

