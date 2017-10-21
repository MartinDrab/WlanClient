Unit Utils;

Interface

Procedure ErrorMessage(AFormat:WideString; AArgs: Array Of Const);
Procedure WarningMessage(AFormat:WideString; AArgs: Array Of Const);
Procedure InformationMessage(AFormat:WideString; AArgs: Array Of Const);

Implementation

Uses
  Windows, SysUtils;

Procedure ErrorMessage(AFormat:WideString; AArgs: Array Of Const);
begin
MessageBox(0, PWideChar(Format(AFormat, AArgs)), 'Error', MB_OK Or MB_ICONERROR);
end;

Procedure WarningMessage(AFormat:WideString; AArgs: Array Of Const);
begin
MessageBox(0, PWideChar(Format(AFormat, AArgs)), 'Warning', MB_OK Or MB_ICONWARNING);
end;

Procedure InformationMessage(AFormat:WideString; AArgs: Array Of Const);
begin
MessageBox(0, PWideChar(Format(AFormat, AArgs)), 'Information', MB_OK Or MB_ICONINFORMATION);
end;



End.
