Unit WlanProfile;

Interface

Uses
  WlanAPI, WlanAPIClient;

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
      Function GetPassword:Boolean;
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; Var AInterfaceGuid:TGuid; Var ARecord:WLAN_PROFILE_INFO):TWlanProfile;

      Function Delete:Boolean;
      Function Connect:Boolean;

      Property Name : WideString Read FName;
      Property XML : WideString Read FXML;
      Property Flags : Cardinal Read FFlags;
      Property InterfaceGuid : TGuid Read FInterfaceGuid;
      Property GroupPolicy : Boolean Read FGroupPolicy;
      Property User : Boolean Read FUser;
      Property PasswordDecrypted : Boolean Read FPasswordDecrypted;
      Property Password : WideString Read FPassword;
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
    WlanFreeMemory(pxml);
    end
  Else FreeAndNil(Result);
  end;
end;


Function TWlanProfile.Delete:Boolean;
begin
Result := FClient._WlanDeleteProfile(@FInterfaceGuid, PWideChar(FName));
end;

Function TWlanProfile.Connect:Boolean;
Var
  cp : WLAN_CONNECTION_PARAMETERS;
begin
cp.wlanConnectionMode := wlan_connection_mode_profile;
cp.strProfile := PWideChar(FName);
cp.pDot11Ssid := Nil;
cp.pDesiredBssidList := Nil;
cp.dot11BssType := dot11_BSS_type_infrastructure;
cp.dwFlags := 0;
Result := FClient._WlanConnect(@FInterfaceGuid, @cp);
end;


End.

