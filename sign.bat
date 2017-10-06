set SIGNEXE="c:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x64\signtool.exe"
set FILES=bin\Win32\Release\WlanClient.exe bin\x64\Release\WlanClient.exe
set CROSSCERT="m:\cert\codesigning2017\crosssigning.crt"
%SIGNEXE% sign /n "Martin Drab" /t http://time.certum.pl /fd sha1 /ac %CROSSCERT% /v %FILES%
%SIGNEXE% sign /as /n "Martin Drab" /tr http://time.certum.pl /fd sha256 /ac %CROSSCERT% /v %FILES%
