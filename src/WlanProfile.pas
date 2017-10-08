Unit WlanProfile;

Interface

Uses
  WlanAPI, WlanAPIClient, WlanBssEntry,
  Generics.Collections;

Type
  TWlanProfile = Class
    Private
      FClient : TWlanAPIClient;
      FInterfaceGuid : TGuid;
      FName : WideString;
      FXML : WideString;
      FFlags : Cardinal;
      FGroupPolicy : Boolean;
      FUser : Boolean;
      FPasswordDecrypted : Boolean;
      FPassword : WideString;
      FSSID : WideString;
      Function GetPassword:Boolean;
      Function GetSSID:Boolean;
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; Var AInterfaceGuid:TGuid; Var ARecord:WLAN_PROFILE_INFO):TWlanProfile;

      Function Delete:Boolean;
      Function Connect(ABssList:TObjectList<TWlanBssEntry>):Boolean;

      Property Name : WideString Read FName;
      Property XML : WideString Read FXML;
      Property Flags : Cardinal Read FFlags;
      Property InterfaceGuid : TGuid Read FInterfaceGuid;
      Property GroupPolicy : Boolean Read FGroupPolicy;
      Property User : Boolean Read FUser;
      Property PasswordDecrypted : Boolean Read FPasswordDecrypted;
      Property Password : WideString Read FPassword;
      Property SSID : WideString Read FSSID;
    end;

Implementation

Uses
  Sysutils;


Function TWlanProfile.GetPassword:Boolean;
Var
  startIndex : Integer;
  endIndex : Integer;
  elemStart : WideString;
  elemEnd : WideString;
begin
elemStart := '<keyMaterial>';
elemEnd := '</keyMaterial>';
startIndex := Pos(elemStart, FXML);
Result := startIndex > 0;
If Result Then
  begin
  Inc(startIndex, Length(elemStart));
  endIndex := Pos(elemEnd, FXML);
  Result := endIndex > 0;
  If Result Then
    FPassword := Copy(FXML, startIndex, endIndex - startIndex);
  end;
end;

Function TWlanProfile.GetSSID:Boolean;
Var
  I : Integer;
  oneCh : WideChar;
  elemData : WideString;
  startIndex : Integer;
  endIndex : Integer;
  elemStart : WideString;
  elemEnd : WideString;
begin
elemStart := '<SSID>';
elemEnd := '</SSID>';
startIndex := Pos(elemStart, FXML);
Result := startIndex > 0;
If Result Then
  begin
  Inc(startIndex, Length(elemStart));
  endIndex := Pos(elemEnd, FXML);
  Result := endIndex > 0;
  If Result Then
    begin
    elemData := Copy(FXML, startIndex, endIndex - startIndex);
    elemStart := '<hex>';
    elemEnd := '</hex>';
    startIndex := Pos(elemStart, elemData);
    endIndex := Pos(elemEnd, elemData);
    If startIndex > 0 Then
      begin
      Inc(startIndex, Length(elemStart));
      elemData := Copy(elemData, startIndex, endIndex - startIndex);
      FSSID := '';
      If Length(elemData) > 0 Then
        begin
        For I := 0 To (Length(elemData) Div 2) - 1 Do
          FSSID := FSSID + WideChar(StrToInt('$' + Copy(elemData, 2*I + 1, 2)));
        end;
      end
    Else FSSID := elemData;
    end;
  end;
end;

Class Function TWlanProfile.NewInstance(AClient:TWlanAPIClient; Var AInterfaceGuid:TGuid; Var ARecord:WLAN_PROFILE_INFO):TWlanProfile;
Var
  pxml : PWideChar;
begin
Result := Nil;
Try
  Result := TWlanProfile.Create;
Except
  Result := Nil;
  end;

If Assigned(Result) Then
  begin
  Result.FClient := AClient;
  Result.FInterfaceGuid := AInterfaceGuid;
  Result.FName := Copy(PWideChar(@ARecord.ProfileName), 1, Strlen(ARecord.ProfileName));
  Result.FFlags := (ARecord.Flags) Or (WLAN_PROFILE_GET_PLAINTEXT_KEY);
  If AClient._WlanGetProfile(@Result.FInterfaceGuid, PWideChar(Result.Fname), Result.FFlags, pxml) Then
    begin
    Result.FGroupPolicy := (Result.FFlags And WLAN_PROFILE_GROUP_POLICY) <> 0;
    Result.FUser := (Result.FFlags And WLAN_PROFILE_USER) <> 0;
    Result.FPasswordDecrypted := (Result.FFlags And WLAN_PROFILE_GET_PLAINTEXT_KEY) <> 0;
    Result.FXML := Copy(PWideChar(pxml), 1, Strlen(pxml));
    Result.GetPassword;
    Result.GetSSID;
    WlanFreeMemory(pxml);
    end
  Else FreeAndNil(Result);
  end;
end;


Function TWlanProfile.Delete:Boolean;
begin
Result := FClient._WlanDeleteProfile(@FInterfaceGuid, PWideChar(FName));
end;

Function TWlanProfile.Connect(ABssList:TObjectList<TWlanBssEntry>):Boolean;
Var
  I : Integer;
  bssList : PDOT11_BSSID_LIST;
  cp : WLAN_CONNECTION_PARAMETERS;
begin
Result := True;
bssList := Nil;
If ABssList.Count > 0 Then
  begin
  bssList := WlanAllocateMemory(SizeOf(DOT11_BSSID_LIST) + SizeOf(DOT11_MAC_ADDRESS  )*ABssList.Count);
  Result := Assigned(bssList);
  If Result Then
    begin
    bssList.Header.HdrType := NDIS_OBJECT_TYPE_DEFAULT;
    bssList.Header.Revision := DOT11_BSSID_LIST_REVISION_1;
    bssList.Header.Size := SizeOf(DOT11_BSSID_LIST) + ABssList.Count * SizeOf(DOT11_MAC_ADDRESS);
    bssList.uNumOfEntries := ABssList.Count;
    bssList.uTotalNumOfEntries := ABssList.Count;
    For I := 0 To ABssList.Count - 1 Do
      bssList.BSSIDs[I] := ABssList[I].MacAddress;
    end;
  end;

If Result Then
  begin
  cp.wlanConnectionMode := wlan_connection_mode_profile;
  cp.strProfile := PWideChar(FName);
  cp.pDot11Ssid := Nil;
  cp.pDesiredBssidList := bssList;
  cp.dot11BssType := dot11_BSS_type_infrastructure;
  cp.dwFlags := 0;
  Result := FClient._WlanConnect(@FInterfaceGuid, @cp);
  If Assigned(bssList) Then
    WlanFreeMemory(bssList);
  end;
end;


End.

