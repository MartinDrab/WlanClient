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

  WLAN_CONNECTION_HIDDEN_NETWORK = $1;
  WLAN_CONNECTION_ADHOC_JOIN_ONLY = $2;
  WLAN_CONNECTION_IGNORE_PRIVACY_BIT = $4;
  WLAN_CONNECTION_EAPOL_PASSTHROUGH = $8;
  WLAN_CONNECTION_PERSIST_DISCOVERY_PROFILE = $10;
  WLAN_CONNECTION_PERSIST_DISCOVERY_PROFILE_CONNECTION_MODE_AUTO = $20;

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

Const
  WLAN_PROFILE_GROUP_POLICY = 1;
  WLAN_PROFILE_USER = 2;
  WLAN_PROFILE_GET_PLAINTEXT_KEY = 4;

Type
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

  WLAN_HOSTED_NETWORK_STATE = (
    wlan_hosted_network_unavailable,
    wlan_hosted_network_idle,
    wlan_hosted_network_active
  );

  WLAN_HOSTED_NETWORK_PEER_AUTH_STATE = (
    wlan_hosted_network_peer_state_invalid,
    wlan_hosted_network_peer_state_authenticated);

  _WLAN_HOSTED_NETWORK_PEER_STATE = Record
    PeerMAC : DOT11_MAC_ADDRESS;
    PeerAuthState : WLAN_HOSTED_NETWORK_PEER_AUTH_STATE;
    end;
  WLAN_HOSTED_NETWORK_PEER_STATE = _WLAN_HOSTED_NETWORK_PEER_STATE;
  PWLAN_HOSTED_NETWORK_PEER_STATE = ^WLAN_HOSTED_NETWORK_PEER_STATE;

  _WLAN_HOSTED_NETWORK_STATUS = Record
    HostedNetworkState : WLAN_HOSTED_NETWORK_STATE;
    IPDeviceID : TGuid;
    MacAddress : DOT11_MAC_ADDRESS;
    PhyType : Cardinal;
    ChannelFrequency : Cardinal;
    dwNumberOfPeers : Cardinal;
    PeerList : Array [0..0] Of WLAN_HOSTED_NETWORK_PEER_STATE;
    end;
  WLAN_HOSTED_NETWORK_STATUS = _WLAN_HOSTED_NETWORK_STATUS;
  PWLAN_HOSTED_NETWORK_STATUS = ^WLAN_HOSTED_NETWORK_STATUS;

  _WLAN_OPCODE_VALUE_TYPE = (
    wlan_opcode_value_type_query_only,
    wlan_opcode_value_type_set_by_group_policy,
    wlan_opcode_value_type_set_by_user,
    wlan_opcode_value_type_invalid);
  WLAN_OPCODE_VALUE_TYPE = _WLAN_OPCODE_VALUE_TYPE;
  PWLAN_OPCODE_VALUE_TYPE = ^WLAN_OPCODE_VALUE_TYPE;

  _WLAN_HOSTED_NETWORK_OPCODE = (
    wlan_hosted_network_opcode_connection_settings,
    wlan_hosted_network_opcode_security_settings,
    wlan_hosted_network_opcode_station_profile,
    wlan_hosted_network_opcode_enable);
  WLAN_HOSTED_NETWORK_OPCODE = _WLAN_HOSTED_NETWORK_OPCODE;
  PWLAN_HOSTED_NETWORK_OPCODE = ^WLAN_HOSTED_NETWORK_OPCODE;

  _WLAN_HOSTED_NETWORK_REASON = (
    wlan_hosted_network_reason_success                               = 0,
    wlan_hosted_network_reason_unspecified,
    wlan_hosted_network_reason_bad_parameters,
    wlan_hosted_network_reason_service_shutting_down,
    wlan_hosted_network_reason_insufficient_resources,
    wlan_hosted_network_reason_elevation_required,
    wlan_hosted_network_reason_read_only,
    wlan_hosted_network_reason_persistence_failed,
    wlan_hosted_network_reason_crypt_error,
    wlan_hosted_network_reason_impersonation,
    wlan_hosted_network_reason_stop_before_start,
    wlan_hosted_network_reason_interface_available,
    wlan_hosted_network_reason_interface_unavailable,
    wlan_hosted_network_reason_miniport_stopped,
    wlan_hosted_network_reason_miniport_started,
    wlan_hosted_network_reason_incompatible_connection_started,
    wlan_hosted_network_reason_incompatible_connection_stopped,
    wlan_hosted_network_reason_user_action,
    wlan_hosted_network_reason_client_abort,
    wlan_hosted_network_reason_ap_start_failed,
    wlan_hosted_network_reason_peer_arrived,
    wlan_hosted_network_reason_peer_departed,
    wlan_hosted_network_reason_peer_timeout,
    wlan_hosted_network_reason_gp_denied,
    wlan_hosted_network_reason_service_unavailable,
    wlan_hosted_network_reason_device_change,
    wlan_hosted_network_reason_properties_change,
    wlan_hosted_network_reason_virtual_station_blocking_use,
    wlan_hosted_network_reason_service_available_on_virtual_station);
  WLAN_HOSTED_NETWORK_REASON = _WLAN_HOSTED_NETWORK_REASON;
  PWLAN_HOSTED_NETWORK_REASON = ^WLAN_HOSTED_NETWORK_REASON;

Function WlanOpenHandle(dwClientVersion:DWORD; Reserved:PVOID; Var pdwNegotiatedVersion; Var phClientHandle:THandle):DWORD; StdCall;
Function WlanCloseHandle(hClientHandle:THandle; Reserved:PVOID):DWORD; StdCall;
Function WlanEnumInterfaces(hClientHandle:THandle; lpReserved:PVOID; Var pInterfaceList:PWLAN_INTERFACE_INFO_LIST):DWORD; StdCall;
Procedure WlanFreeMemory(pMemory:PVOID); StdCall;
Function WlanGetAvailableNetworkList(hClientHandle:THandle; pInterfaceGuid:PGUID; dwFlags:DWORD; pReserved:PVOID; Var pAvailableNetworks:PWLAN_AVAILABLE_NETWORK_LIST):DWORD; StdCall;
Function WlanGetNetworkBssList(hClientHandle:THandle; pInterfaceGuid:PGUID; pDot11Ssid:PDOT11_SSID; dot11BssType:DWORD; bSecurityEnabled:BOOL; pReserved:PVOID; Var pWlanBssList:PWLAN_BSS_LIST):DWORD; StdCall;
Function WlanConnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pConnectionParameters:PWLAN_CONNECTION_PARAMETERS; pReserved:PVOID):DWORD; StdCall;
Function WlanDisconnect(hCLientHandle:THandle; pInterfaceGuid:PGUID; pReserved:PVOID):DWORD; StdCall;
Function WlanAllocateMemory(dwMemorySize:DWORD):PVOID; StdCall;

Function WlanGetProfileList(hClientHandle:THandle; NetworkInterface:PGuid; Reserved:Pointer; Var ProfileList:PWLAN_PROFILE_INFO_LIST):Cardinal; StdCall;
Function WlanGetProfile(hClientHandle:THandle; NetworkInterface:PGuid; ProfileName:PWideChar; Reserved:Pointer; Var ProfileXML:PWideChar; Var Flags:Cardinal; Var GrantedAccess:Cardinal):Cardinal; StdCall;
Function WlanDeleteProfile(hClientHandle:THandle; NetworkInterface:PGuid; ProfileName:PWideChar; Reserved:Pointer):Cardinal; StdCall;

Function WlanHostedNetworkForceStart(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkForceStop(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkInitSettings(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkRefreshSecuritySettings(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkStartUsing(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkStopUsing(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkQueryStatus(hClientHandle:THandle; Var Status:PWLAN_HOSTED_NETWORK_STATUS; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkQueryProperty(hClientHandle:THandle; OpCode:WLAN_HOSTED_NETWORK_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkSetProperty(hClientHandle:THandle; Var OpCode:WLAN_HOSTED_NETWORK_OPCODE; DataSize:Cardinal; Data:Pointer; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkQuerySecondaryKey(hClientHandle:THandle; Var KeyLength:Cardinal; Var KeyData:PChar; Var IsPassPhrase:LongBool; Var Persistent:LongBool; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;
Function WlanHostedNetworkSetSecondaryKey(hClientHandle:THandle; KeyLength:Cardinal; KeyData:PChar; IsPassPhrase:LongBool; Persistent:LongBool; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall;

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
Function WlanGetProfileList(hClientHandle:THandle; NetworkInterface:PGuid; Reserved:Pointer; Var ProfileList:PWLAN_PROFILE_INFO_LIST):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanGetProfile(hClientHandle:THandle; NetworkInterface:PGuid; ProfileName:PWideChar; Reserved:Pointer; Var ProfileXML:PWideChar; Var Flags:Cardinal; Var GrantedAccess:Cardinal):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanDeleteProfile(hClientHandle:THandle; NetworkInterface:PGuid; ProfileName:PWideChar; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;

Function WlanHostedNetworkForceStart(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkForceStop(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkInitSettings(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkRefreshSecuritySettings(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkStartUsing(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkStopUsing(hClientHandle:THandle; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkQueryStatus(hClientHandle:THandle; Var Status:PWLAN_HOSTED_NETWORK_STATUS; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkQueryProperty(hClientHandle:THandle; OpCode:WLAN_HOSTED_NETWORK_OPCODE; Var DataSize:Cardinal; Var Data:Pointer; Var ValueType:WLAN_OPCODE_VALUE_TYPE; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkSetProperty(hClientHandle:THandle; Var OpCode:WLAN_HOSTED_NETWORK_OPCODE; DataSize:Cardinal; Data:Pointer; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkQuerySecondaryKey(hClientHandle:THandle; Var KeyLength:Cardinal; Var KeyData:PChar; Var IsPassPhrase:LongBool; Var Persistent:LongBool; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;
Function WlanHostedNetworkSetSecondaryKey(hClientHandle:THandle; KeyLength:Cardinal; KeyData:PChar; IsPassPhrase:LongBool; Persistent:LongBool; Var FailureReason:Cardinal; Reserved:Pointer):Cardinal; StdCall; External WLANAPI_LIBRARY;



End.

