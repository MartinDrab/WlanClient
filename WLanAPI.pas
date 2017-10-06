Unit WLanAPI;

Interface

Uses
  Windows;


Const
  WLANAPI_CLIENT_WXP = 1;
  WLANAPI_CLIENT_VISTA = 2;


Const
  // Interface state
  wlan_interface_state_not_ready = 0;
  wlan_interface_state_connected = 1;
  wlan_interface_state_ad_hoc_network_formed = 2;
  wlan_interface_state_disconnecting = 3;
  wlan_interface_state_disconnected = 4;
  wlan_interface_state_associating = 5;
  wlan_interface_state_discovering = 6;
  wlan_interface_state_authenticating = 7;

  DOT11_SSID_MAX_LENGTH = 32;
  WLAN_MAX_PHY_TYPE_NUMBER = 8;
  DOT11_RATE_SET_MAX_LENGTH = 126;

  // Network BSS type
  dot11_BSS_type_infrastructure   = 1;
  dot11_BSS_type_independent      = 2;
  dot11_BSS_type_any              = 3;

  // PHY types
   dot11_phy_type_unknown      = 0;
  dot11_phy_type_any          = 0;
  dot11_phy_type_fhss         = 1;
  dot11_phy_type_dsss         = 2;
  dot11_phy_type_irbaseband   = 3;
  dot11_phy_type_ofdm         = 4;
  dot11_phy_type_hrdsss       = 5;
  dot11_phy_type_erp          = 6;
  dot11_phy_type_ht           = 7;
  dot11_phy_type_IHV_start    = $80000000;
  dot11_phy_type_IHV_end      = $ffffffff;

  // Authentication algorithm
  DOT11_AUTH_ALGO_80211_OPEN         = 1;
  DOT11_AUTH_ALGO_80211_SHARED_KEY   = 2;
  DOT11_AUTH_ALGO_WPA                = 3;
  DOT11_AUTH_ALGO_WPA_PSK            = 4;
  DOT11_AUTH_ALGO_WPA_NONE           = 5;
  DOT11_AUTH_ALGO_RSNA               = 6;
  DOT11_AUTH_ALGO_RSNA_PSK           = 7;
  DOT11_AUTH_ALGO_IHV_START          = $80000000;
  DOT11_AUTH_ALGO_IHV_END            = $ffffffff;

  // Cipher algorithm
  DOT11_CIPHER_ALGO_NONE            = $00;
  DOT11_CIPHER_ALGO_WEP40           = $01;
  DOT11_CIPHER_ALGO_TKIP            = $02;
  DOT11_CIPHER_ALGO_CCMP            = $04;
  DOT11_CIPHER_ALGO_WEP104          = $05;
  DOT11_CIPHER_ALGO_WPA_USE_GROUP   = $100;
  DOT11_CIPHER_ALGO_RSN_USE_GROUP   = $100;
  DOT11_CIPHER_ALGO_WEP             = $101;
  DOT11_CIPHER_ALGO_IHV_START       = $80000000;
  DOT11_CIPHER_ALGO_IHV_END         = $ffffffff;

  // Network flags
  WLAN_AVAILABLE_NETWORK_CONNECTED = 1;
  WLAN_AVAILABLE_NETWORK_HAS_PROFILE = 2;

  // Connection mode
  wlan_connection_mode_profile = 0;
  wlan_connection_mode_temporary_profile = 1;
  wlan_connection_mode_discovery_secure = 2;
  wlan_connection_mode_discovery_unsecure = 3;
  wlan_connection_mode_auto = 4;
  wlan_connection_mode_invalid = 5;

  NDIS_OBJECT_TYPE_DEFAULT = $80;
  DOT11_BSSID_LIST_REVISION_1 = 1;

Type
  WLAN_INTERFACE_INFO = Record
    InterfaceGuid : TGUID;
    strInterfaceDescription : Array [0..255] Of WideChar;
    isState : DWORD;  // Interface state
    end;
  PWLAN_INTERFACE_INFO = ^WLAN_INTERFACE_INFO;

  WLAN_INTERFACE_INFO_LIST = Record
    dwNumberOfItems : DWORD;
    dwIndex : DWORD;
    InterfaceInfo : Array [0..0] Of WLAN_INTERFACE_INFO;
    end;
  PWLAN_INTERFACE_INFO_LIST = ^WLAN_INTERFACE_INFO_LIST;

  DOT11_SSID = Record
    uSSIDLength : ULONG;
    ucSSID : Packed Array [0..DOT11_SSID_MAX_LENGTH-1] Of Uchar;
    end;
  PDOT11_SSID = ^DOT11_SSID;


  WLAN_AVAILABLE_NETWORK = Record
    strProfileName : Packed Array [0..255] Of WideChar;
    dot11Ssid : DOT11_SSID;
    dot11BssType : DWORD;
    uNumberOfBssids : ULONG;
    bNetworkConnectable : BOOL;
    wlanNotConnectableReason : ULONG;
    uNumberOfPhyTypes : ULONG;
    dot11PhyTypes : Array [0..WLAN_MAX_PHY_TYPE_NUMBER-1] Of DWORD;
    bMorePhyTypes : BOOL;
    wlanSignalQuality : ULONG;
    bSecurityEnabled : BOOL;
    dot11DefaultAuthAlgorithm : ULONG;
    dot11DefaultCipherAlgorithm : ULONG;
    dwFlags : DWORD;
    dwReserved : DWORD;
    end;
  PWLAN_AVAILABLE_NETWORK = ^WLAN_AVAILABLE_NETWORK;

  WLAN_AVAILABLE_NETWORK_LIST = Record
    dwNumberOfItems : DWORD;
    dwIndex : DWORD;
    Network : Array [0..0] Of WLAN_AVAILABLE_NETWORK;
    end;
  PWLAN_AVAILABLE_NETWORK_LIST = ^WLAN_AVAILABLE_NETWORK_LIST;

  DOT11_MAC_ADDRESS = Array [0..5] Of Byte;

  WLAN_RATE_SET = Record
    uRateSetLength : ULONG;
    usRateSet : Packed Array [0..DOT11_RATE_SET_MAX_LENGTH-1] Of USHORT;
    end;
  PWLAN_RATE_SET = ^WLAN_RATE_SET;

  WLAN_BSS_ENTRY = Record
    dot11Ssid : DOT11_SSID;
    uPhyId : ULONG;
    dot11Bssid : DOT11_MAC_ADDRESS;
    dot11BssType : ULONG;
    dot11BssPhyType : ULONG;
    lRssi : LONG;
    uLinkQuality : ULONG;
    bInRegDomain : BOOLEAN;
    usBeaconPeriod : USHORT;
    ullTimestamp : ULONGLONG;
    ullHostTimestamp : ULONGLONG;
    usCapabilityInformation : USHORT;
    ulChCenterFrequency : ULONG;
    wlanRateSet : WLAN_RATE_SET;
    ulIeOffset : ULONG;
    ulIeSize : ULONG;
    end;
  PWLAN_BSS_ENTRY = ^WLAN_BSS_ENTRY;

  WLAN_BSS_LIST = Record
    dwTotalSize : DWORD;
    dwNumberOfItems : DWORD;
    wlanBssEntries : Array [0..0] Of WLAN_BSS_ENTRY;
    end;
  PWLAN_BSS_LIST = ^WLAN_BSS_LIST;

  NDIS_OBJECT_HEADER = Record
    HdrType : UChar;
    Revision : UChar;
    Size : USHORT;
    end;
  PNDIS_OBJECT_HEADER = ^NDIS_OBJECT_HEADER;

  DOT11_BSSID_LIST = Record
    Header : NDIS_OBJECT_HEADER;
    uNumOfEntries : ULONG;
    uTotalNumOfEntries : ULONG;
    BSSIDs : Array [0..0] Of DOT11_MAC_ADDRESS;
    end;
  PDOT11_BSSID_LIST = ^DOT11_BSSID_LIST;

  WLAN_CONNECTION_PARAMETERS = Record
    wlanConnectionMode : ULONG;
    strProfile : LPCWSTR;
    pDot11Ssid : PDOT11_SSID;
    pDesiredBssidList : PDOT11_BSSID_LIST;
    dot11BssType : ULONG;
    dwFlags : DWORD;
    end;
  PWLAN_CONNECTION_PARAMETERS = ^WLAN_CONNECTION_PARAMETERS;

  _WLAN_PROFILE_INFO = Record
    ProfileName : Packed Array [0..255] Of WideChar;
    Flags : Cardinal;
    end;
  WLAN_PROFILE_INFO = _WLAN_PROFILE_INFO;
  PWLAN_PROFILE_INFO = ^WLAN_PROFILE_INFO;

  _WLAN_PROFILE_INFO_LIST  = Record
    NumberOfItems : Cardinal;
    Index : Cardinal;
    List : Array [0..0] Of WLAN_PROFILE_INFO;
    end;
  WLAN_PROFILE_INFO_LIST = _WLAN_PROFILE_INFO_LIST;
  PWLAN_PROFILE_INFO_LIST = ^WLAN_PROFILE_INFO_LIST;

Function WlanOpenHandle(dwClientVersion:DWORD; Reserved:PVOID; Var pdwNegotiatedVersion; Var phClientHandle:THandle):DWORD; StdCall;
Function WlanCloseHandle(hClientHandle:THandle; Reserved:PVOID):DWORD; StdCall;
Function WlanEnumInterfaces(hClientHandle:THandle; lpReserved:PVOID; Var pInterfaceList:PWLAN_INTERFACE_INFO_LIST):DWORD; StdCall;
Procedure WlanFreeMemory(pMemory:PVOID); StdCall;
Function WlanGetAvailableNetworkList(hClientHandle:THandle; pInterfaceGuid:PGUID; dwFlags:DWORD; pReserved:PVOID; Var pAvailableNetworks:PWLAN_AVAILABLE_NETWORK_LIST):DWORD; StdCall;
Function WlanGetNetworkBssList(hClientHandle:THandle; pInterfaceGuid:PGUID; pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; pReserved:PVOID; Var pWlanBssList:PWLAN_BSS_LIST):DWORD; StdCall;
Function WlanConnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pConnectionParameters:PWLAN_CONNECTION_PARAMETERS; pReserved:PVOID):DWORD; StdCall;
Function WlanDisconnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pReserved:PVOID):DWORD; StdCall;
Function WlanAllocateMemory(dwMemorySize:DWORD):PVOID; StdCall;

Implementation

Const
  WLANAPI_LIBRARY = 'wlanapi.dll';

Function WlanOpenHandle(dwClientVersion:DWORD; Reserved:PVOID; Var pdwNegotiatedVersion; Var phClientHandle:THandle):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanCloseHandle(hClientHandle:THandle; Reserved:PVOID):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanEnumInterfaces(hClientHandle:THandle; lpReserved:PVOID; Var pInterfaceList:PWLAN_INTERFACE_INFO_LIST):DWORD; StdCall; External WLANAPI_LIBRARY;
Procedure WlanFreeMemory(pMemory:PVOID); StdCall; External WLANAPI_LIBRARY;
Function WlanGetAvailableNetworkList(hClientHandle:THandle; pInterfaceGuid:PGUID; dwFlags:DWORD; pReserved:PVOID; Var pAvailableNetworks:PWLAN_AVAILABLE_NETWORK_LIST):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanGetNetworkBssList(hClientHandle:THandle; pInterfaceGuid:PGUID; pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; pReserved:PVOID; Var pWlanBssList:PWLAN_BSS_LIST):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanConnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pConnectionParameters:PWLAN_CONNECTION_PARAMETERS; pReserved:PVOID):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanDisconnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pReserved:PVOID):DWORD; StdCall; External WLANAPI_LIBRARY;
Function WlanAllocateMemory(dwMemorySize:DWORD):PVOID; StdCall; External WLANAPI_LIBRARY;

End.
