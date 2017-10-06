program WLanClient;

uses
  Windows,
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  WLanAPI in 'WLanAPI.pas',
  WlanAPIClient in 'WlanAPIClient.pas',
  WlanInterface in 'WlanInterface.pas',
  WlanNetwork in 'WlanNetwork.pas',
  WlanBssEntry in 'WlanBssEntry.pas',
  APSelectionForm in 'APSelectionForm.pas' {Form2},
  WlanBus in 'WlanBus.pas',
  WlanProfile in 'WlanProfile.pas';

{$R *.RES}

Var
  VersionInfo : OSVERSIONINFOW;
begin
VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
If GetVersionExW(VersionInfo) Then
  begin
  If VersionInfo.dwMajorVersion >= 6 Then
    begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
  Application.Run;
    end
  Else MessageBox(0, 'Program nepodporuje vaši verzi operaèního systému', 'Chyba', MB_OK Or MB_ICONERROR);
  end
Else MessageBox(0, 'Nepodaøilo se zjistit verzi operaèního systému', 'Chyba', MB_OK Or MB_ICONERROR);
end.
