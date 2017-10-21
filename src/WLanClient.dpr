program WLanClient;

uses
  Windows,
  Vcl.Forms,
  MainForm in 'MainForm.pas' {MainWlanClientForm},
  WLanAPI in 'WLanAPI.pas',
  WlanAPIClient in 'WlanAPIClient.pas',
  WlanInterface in 'WlanInterface.pas',
  WlanNetwork in 'WlanNetwork.pas',
  WlanBssEntry in 'WlanBssEntry.pas',
  APSelectionForm in 'APSelectionForm.pas' {ConnectionSettingsForm},
  WlanBus in 'WlanBus.pas',
  WlanProfile in 'WlanProfile.pas',
  WlanHostedNetwork in 'WlanHostedNetwork.pas',
  Utils in 'Utils.pas';

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
    Application.CreateForm(TMainWlanClientForm, MainWlanClientForm);
  Application.Run;
    end
  Else MessageBox(0, 'Program nepodporuje va�i verzi opera�n�ho syst�mu', 'Chyba', MB_OK Or MB_ICONERROR);
  end
Else MessageBox(0, 'Nepoda�ilo se zjistit verzi opera�n�ho syst�mu', 'Chyba', MB_OK Or MB_ICONERROR);
end.
