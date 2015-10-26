Unit WlanAPIClient;

Interface

Uses
  Windows, WlanAPI, Classes;

Type
  TWlanAPIClient = Class
    Private
      FAPIVersion : DWORD;
      FError : LONG;
      FHandle : THandle;
      Constructor Create; Reintroduce;
    Public
      Class Function NewInstance:TWlanAPIClient;
      Destructor Destroy; Override;
      Function _WlanEnumInterfaces(Var AList:PWLAN_INTERFACE_INFO_LIST):Boolean;
      Function _WlanGetAvailableNetworkList(InterfaceGuid:PGUID; Flags:DWORD; Var List:PWLAN_AVAILABLE_NETWORK_LIST):Boolean;
      Function _WlanConnect(pInterfaceGuid:PGUID; pConnectionParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
      Function _WlanDisconnect(pInterfaceGuid:PGUID):Boolean;
      Function _WlanGetNetworkBssList(pInterfaceGuid:PGUID; pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; Var pWlanBssList:PWLAN_BSS_LIST):Boolean;


      Function EnumInterfaces(AList:TList):Boolean;

      Property Error : LONG Read FError;
      Property APIVersion : DWORD Read FAPIVersion;
    end;


Implementation

Uses
  WlanInterface;

Constructor TWlanAPIClient.Create;
begin
Inherited Create;
FHandle := 0;
end;


Destructor TWlanAPIClient.Destroy;
begin
If FHandle <> 0 Then
  WlanCloseHandle(FHandle, Nil);

Inherited Destroy;
end;

Class Function TWlanAPIClient.NewInstance:TWlanAPIClient;
begin
Try
  Result := TWlanAPIClient.Create;
Except
  Result := Nil;
  end;

If Assigned(Result) Then
  begin
  Result.FError := WlanOpenHandle(WLANAPI_CLIENT_VISTA, Nil, Result.FAPIVersion, Result.FHandle);
  If Result.FError <> ERROR_SUCCESS Then
    begin
    Result.Free;
    Result := Nil
    end;
  end;
end;

Function TWlanAPIClient._WlanEnumInterfaces(Var AList:PWLAN_INTERFACE_INFO_LIST):Boolean;
begin
FError := WlanAPI.WlanEnumInterfaces(FHandle, Nil, AList);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanGetAvailableNetworkList(InterfaceGuid:PGUID; Flags:DWORD; Var List:PWLAN_AVAILABLE_NETWORK_LIST):Boolean;
begin
FError := WlanAPI.WlanGetAvailableNetworkList(FHandle, InterfaceGuid, Flags, Nil, List);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPICLient.EnumInterfaces(AList:TList):Boolean;
Var
  I, J : Integer;
  List : PWLAN_INTERFACE_INFO_LIST;
  Tmp : TWlanInterface;
begin
Result := _WlanEnumInterfaces(List);
If Result Then
  begin
  For I := 0 To List.dwNumberOfItems - 1 Do
    begin
    List.dwIndex := I;
    Tmp := TWlanInterface.NewInstance(Self, List);
    Result := Assigned(Tmp);
    If Result Then
      begin
      AList.Add(Tmp);
      end
    Else begin
      For J := I - 1 DownTo 0 Do
        TWlanInterface(AList[J]).Free;

      AList.Clear;
      FError := ERROR_NOT_ENOUGH_MEMORY;
      Break;
      end;
    end;

  WlanFreeMemory(List);
  end;
end;

Function TWlanAPIClient._WlanConnect(pInterfaceGuid:PGUID; pConnectionParameters:PWLAN_CONNECTION_PARAMETERS):Boolean;
begin
FError := WlanConnect(FHandle, pInterfaceGuid, pConnectionParameters, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanDisconnect(pInterfaceGuid:PGUID):Boolean;
begin
FError := WlanDisconnect(FHandle, pInterfaceGuid, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanGetNetworkBssList(pInterfaceGuid:PGUID; pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; Var pWlanBssList:PWLAN_BSS_LIST):Boolean;
begin
FError := WlanGetNetworkBssList(FHandle, pInterfaceGuid, pDot11Ssid, dot11BssType, bSecurityEnabled, Nil, pWlanBssList);
Result := FError = ERROR_SUCCESS;
end;


End.

