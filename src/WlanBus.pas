Unit WlanBus;

Interface

Uses
  WlanAPIClient, WlanInterface,
  Generics.Collections;

Type
  TWlanBus = Class
    Private
      FClient : TWlanAPIClient;
    Public
      Constructor Create(AClient:TWlanAPIClient); Reintroduce;
      Function EnumInterfaces(AList:TObjectList<TWlanInterface>):Boolean;
    end;

Implementation

Uses
  SysUtils, WlanAPI;


Constructor TWlanBus.Create(AClient:TWlanAPIClient);
begin
Inherited Create;
FClient := AClient;
end;


Function TWlanBus.EnumInterfaces(AList:TObjectList<TWlanInterface>):Boolean;
Var
  I, J : Integer;
  List : PWLAN_INTERFACE_INFO_LIST;
  Tmp : TWlanInterface;
begin
Result := FClient._WlanEnumInterfaces(List);
If Result Then
  begin
  For I := 0 To List.dwNumberOfItems - 1 Do
    begin
    List.dwIndex := I;
    Tmp := TWlanInterface.NewInstance(FClient, List);
    Result := Assigned(Tmp);
    If Result Then
      AList.Add(Tmp)
    Else begin
      AList.Clear;
      Break;
      end;
    end;

  WlanFreeMemory(List);
  end;
end;


End.
