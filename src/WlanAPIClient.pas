Unit WlanAPIClient;

Interface

Uses
  Windows, WlanAPI, Classes;

Type
  TWlanAPIClient = Class
    Private
      FAPIVersion : DWORD;
      FError : LONG;
      FFailureReason : WLAN_HOSTED_NETWORK_REASON;
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
      Function _WlanGetProfileList(pInterfaceGuid:PGuid; Var AList:PWLAN_PROFILE_INFO_LIST):Boolean;
      Function _WlanGetProfile(pInterfaceGuid:PGuid; ProfileName:PWideChar; Var Flags:Cardinal; Var ProfileXML:PWideChar):Boolean;
      Function _WlanDeleteProfile(pInterfaceGuid:PGuid; Profilename:PWideChar):Boolean;

      Function _WlanHostedNetworkForceStart:Boolean;
      Function _WlanHostedNetworkForceStop:Boolean;
      Function _WlanHostedNetworkInitSettings:Boolean;
      Function _WlanHostedNetworkRefreshSecuritySettings:Boolean;
      Function _WlanHostedNetworkStartUsing:Boolean;
      Function _WlanHostedNetworkStopUsing:Boolean;
      Function _WlanHostedNetworkQueryStatus(Var Status:PWLAN_HOSTED_NETWORK_STATUS):Boolean;
      Function _WlanHostedNetworkQueryProperty(OpCode:WLAN_HOSTED_NETWORK_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;
      Function _WlanHostedNetworkSetProperty(OpCode:WLAN_HOSTED_NETWORK_OPCODE; DataSize:Cardinal; Data:Pointer):Boolean;
      Function _WlanHostedNetworkQuerySecondaryKey(Var KeyLength:Cardinal; Var KeyData:PAnsiChar; Var IsPassPhrase:LongBool; Var Persistent:LongBool):Boolean;
      Function _WlanHostedNetworkSetSecondaryKey(KeyLength:Cardinal; KeyData:PAnsiChar; IsPassPhrase:LongBool; Persistent:LongBool):Boolean;
      Function _WlanQueryInterface(InterfaceGuid:PGuid; OpCode:WLAN_INTF_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;

      Property Error : LONG Read FError;
      Property FailureReason : WLAN_HOSTED_NETWORK_REASON Read FFailureReason;
      Property APIVersion : DWORD Read FAPIVersion;
    end;


Implementation

Uses
  SysUtils, WlanInterface;

Constructor TWlanAPIClient.Create;
begin
Inherited Create;
FHandle := 0;
FError := ERROR_SUCCESS;
FFailureReason := wlan_hosted_network_reason_success;
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
    FreeAndNil(Result);
  end;
end;

Function TWlanAPIClient._WlanEnumInterfaces(Var AList:PWLAN_INTERFACE_INFO_LIST):Boolean;
begin
FError := WlanAPI.WlanEnumInterfaces(FHandle, Nil, AList);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanGetProfileList(pInterfaceGuid:PGuid; Var AList:PWLAN_PROFILE_INFO_LIST):Boolean;
begin
FError := WlanAPI.WlanGetProfileList(FHandle, pInterfaceGuid, Nil, AList);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanGetProfile(pInterfaceGuid:PGuid; ProfileName:PWideChar; Var Flags:Cardinal; Var ProfileXML:PWideChar):Boolean;
Var
  ga : Cardinal;
begin
ga := 0;
FError := WlanAPI.WlanGetProfile(FHandle, pInterfaceGuid, ProfileName, Nil, ProfileXML, Flags, ga);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanDeleteProfile(pInterfaceGuid:PGuid; Profilename:PWideChar):Boolean;
begin
FError := WlanAPI.WlanDeleteProfile(FHandle, pInterfaceGuid, ProfileName, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanGetAvailableNetworkList(InterfaceGuid:PGUID; Flags:DWORD; Var List:PWLAN_AVAILABLE_NETWORK_LIST):Boolean;
begin
FError := WlanAPI.WlanGetAvailableNetworkList(FHandle, InterfaceGuid, Flags, Nil, List);
Result := FError = ERROR_SUCCESS;
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


Function TWlanAPIClient._WlanHostedNetworkForceStart:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkForceStart(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkForceStop:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkForceStop(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkInitSettings:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkInitSettings(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkRefreshSecuritySettings:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkRefreshSecuritySettings(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkStartUsing:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkStartUsing(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkStopUsing:Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkStopUsing(FHandle, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkQueryStatus(Var Status:PWLAN_HOSTED_NETWORK_STATUS):Boolean;
begin
Status := Nil;
FError := WlanHostedNetworkQueryStatus(FHandle, Status, Nil);
Result :=FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkQueryProperty(OpCode:WLAN_HOSTED_NETWORK_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;
begin
Data := Nil;
DataSize := 0;
FError := WlanHostedNetworkQueryProperty(FHandle, OpCode, DataSize, Data, ValueType, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkSetProperty(OpCode:WLAN_HOSTED_NETWORK_OPCODE; DataSize:Cardinal; Data:Pointer):Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkSetProperty(FHandle, OpCode, DataSize, Data, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkQuerySecondaryKey(Var KeyLength:Cardinal; Var KeyData:PAnsiChar; Var IsPassPhrase:LongBool; Var Persistent:LongBool):Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkQuerySecondaryKey(FHandle, KeyLength, KeyData, IsPassPhrase, Persistent, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPIClient._WlanHostedNetworkSetSecondaryKey(KeyLength:Cardinal; KeyData:PAnsiChar; IsPassPhrase:LongBool; Persistent:LongBool):Boolean;
begin
FFailureReason := wlan_hosted_network_reason_success;
FError := WlanHostedNetworkSetSecondaryKey(FHandle, KeyLength, KeyData, IsPassPhrase, Persistent, FFailureReason, Nil);
Result := FError = ERROR_SUCCESS;
end;

Function TWlanAPICLient._WlanQueryInterface(InterfaceGuid:PGuid; OpCode:WLAN_INTF_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE):Boolean;
begin
FError := WlanQueryInterface(FHandle, InterfaceGuid, OpCode, Nil, DataSize, Data, ValueType);
Result := FError = ERROR_SUCCESS;
end;


End.

