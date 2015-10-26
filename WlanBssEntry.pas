Unit WlanBssEntry;

Interface

Uses
  Windows, WlanNetwork, WlanAPI;

Type
  TWlanBssEntry = Class
    Private
      FSSID : WideString;
      FMacAddress : DOT11_MAC_ADDRESS;
      FBssType : TWlanNetworkBssType;
      FLinkQuality : ULONG;
      FFrequency : ULONG;
    Public
      Class Function NewInstance(ARecord:PWLAN_BSS_ENTRY):TWlanBssEntry;
      Class Function MACToSTr(AMAC:DOT11_MAC_ADDRESS):WideSTring;

      Property SSID : WideString Read FSSID;
      Property MacAddress : DOT11_MAC_ADDRESS Read FMacAddress;
      Property BssType : TWlanNetworkBssType Read FBssType;
      Property LinkQuality : ULONG Read FLinkQuality;
      Property Frequency : ULONG Read FFrequency;
    end;

Implementation

Uses
  SysUtils;

Class Function TWlanBssEntry.NewInstance(ARecord:PWLAN_BSS_ENTRY):TWlanBssEntry;
begin
Try
  Result := TWlanBssEntry.Create;
Except
  Result := Nil;
  end;

If Assigned(Result) Then
  begin
  Result.FSSID := Copy(AnsiString(PAnsiChar(@ARecord.dot11Ssid.ucSSID)), 1, ARecord.dot11Ssid.uSSIDLength);
  Result.FMacAddress := ARecord.dot11Bssid;
  Result.FBssType := TWlanNetworkBssType(ARecord.dot11BssType);
  Result.FLinkQuality := ARecord.uLinkQuality;
  Result.FFrequency := ARecord.ulChCenterFrequency;
  end;
end;

Class Function TWlanBssEntry.MACToSTr(AMAC:DOT11_MAC_ADDRESS):WideSTring;
begin
Result :=
    IntToHex(AMAC[0], 2) + '-' +
    IntToHex(AMAC[1], 2) + '-' +
    IntToHex(AMAC[2], 2) + '-' +
    IntToHex(AMAC[3], 2) + '-' +
    IntToHex(AMAC[4], 2) + '-' +
    IntToHex(AMAC[5], 2);
end;


End.

