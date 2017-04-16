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
      FChannel : Integer;
    Public
      Class Function NewInstance(ARecord:PWLAN_BSS_ENTRY):TWlanBssEntry;
      Class Function MACToSTr(AMAC:DOT11_MAC_ADDRESS):WideSTring;

      Property SSID : WideString Read FSSID;
      Property MacAddress : DOT11_MAC_ADDRESS Read FMacAddress;
      Property BssType : TWlanNetworkBssType Read FBssType;
      Property LinkQuality : ULONG Read FLinkQuality;
      Property Frequency : ULONG Read FFrequency;
      Property Channel : Integer Read FChannel;
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
  Result.FChannel := -1;
  Case ARecord.ulChCenterFrequency Of
    2412000 : Result.FChannel := 1;
    2417000 : Result.FChannel := 2;
    2422000 : Result.FChannel := 3;
    2427000 : Result.FChannel := 4;
    2432000 : Result.FChannel := 5;
    2437000 : Result.FChannel := 6;
    2442000 : Result.FChannel := 7;
    2447000 : Result.FChannel := 8;
    2452000 : Result.FChannel := 9;
    2457000 : Result.FChannel := 10;
    2462000 : Result.FChannel := 11;
    2467000 : Result.FChannel := 12;
    2472000 : Result.FChannel := 13;
    end;
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

