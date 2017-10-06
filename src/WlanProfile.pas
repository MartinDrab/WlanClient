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
    Public
      Class Function NewInstance(AClient:TWlanAPIClient; Var AInterfaceGuid:TGuid; Var ARecord:WLAN_PROFILE_INFO):TWlanProfile;

      Property Name : WideString Read FName;
      Property XML : WideString Read FXML;
      Property Flags : Cardinal Read FFlags;
      Property InterfaceGuid : TGuid Read FInterfaceGuid;
    end;

Implementation

Uses
  Sysutils;


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
  Result.FFlags := ARecord.Flags;
  If AClient._WlanGetProfile(@Result.FInterfaceGuid, PWideChar(Result.Fname), True, pxml) Then
    begin
    Result.FXML := Copy(PWideChar(pxml), 1, Strlen(pxml));
    WlanFreeMemory(pxml);
    end
  Else FreeAndNil(Result);
  end;
end;


End.
