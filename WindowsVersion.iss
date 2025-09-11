// WindowsVersion.iss

// Good lists of version info: 
//   - https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
//   - https://endoflife.date/windows
//   - https://endoflife.date/windows-server
//   - 

type
  TVersionCompareMethod = (vcmOlder, vcmOlderOrEqual, vcmEqual, vcmNewerOrEqual, vcmNewer);

function IfThenStr(const ABoolValue: Boolean; const ATrueStr, AFalseStr: string): string;
begin
  if ABoolValue then
    Result := ATrueStr
   else
    Result := AFalseStr; 
end; 

function IsWindowsServer: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetWindowsVersionEx(LVersion);

  Result := not (LVersion.ProductType = VER_NT_WORKSTATION);
end;

function GetWindowsBuildVersionStr(const AMajorVersionStr: string; const AVersion: TWindowsVersion): string;
begin
  Result := 'Windows ' + AMajorVersionStr + ' (' + IntToStr(AVersion.Major) + '.' + IntToStr(AVersion.Minor) + '.'
    + IntToStr(AVersion.Build) + ')';
end;

function HandleVersion60(const AVersion: TWindowsVersion): string;
begin
  if AVersion.Build = 6000 then
    Result := 'Windows Vista'
  else if AVersion.Build = 6001 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2008', 'Windows Vista SP1')
  else if AVersion.Build = 6003 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2008 SP2,', 'Windows Vista')
  else if AVersion.Build >= 7600 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2008 R2', 'Windows 7')
  else
    Result := GetWindowsBuildVersionStr('Vista', AVersion);
end;

function HandleVersion63(const AVersion: TWindowsVersion): string;
begin
  if AVersion.Build = 9200 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2012 R2', 'Windows 8.1')
  else if AVersion.Build >= 9600 then
    Result := 'Windows 8.1 Update 1'
  else
    Result := GetWindowsBuildVersionStr('8.1', AVersion);
end;

function HandleVersion10(const AVersion: TWindowsVersion): string;
begin
  case AVersion.Build of
    10240: Result := 'Windows 10 (1507)'; // Version 1507, Released 29.07.2015, EOS 09.05.2017
    10586: Result := 'Windows 10 (1511)'; // Version 1511, Released 10.11.2015, EOS 10.10.2017
    14393: Result := IfThenStr(IsWindowsServer, 'Windows Server 2016', 'Windows 10 (1607)'); // Desktop: Version 1607, Released 02.08.2016, EOS 10.04.2018
    15063: Result := 'Windows 10 (1703)'; // Version 1703, Released 11.04.2017, EOS 09.10.2018
    16299: Result := 'Windows 10 (1709)'; // Version 1709, Released 17.10.2017, EOS 09.04.2019
    17134: Result := 'Windows 10 (1803)'; // Version 1803, Released 30.04.2018, EOS 12.11.2019
    17763: Result := IfThenStr(IsWindowsServer, 'Windows Server 2019', 'Windows 10 (1809)'); // DesktTop: Version 1809, Released 13.11.2018, EOS 10.11.2020
    18362: Result := 'Windows 10 (1903)'; // Version 1903, Released 21.05.2019, EOS 08.12.2020
    18363: Result := IfThenStr(IsWindowsServer, 'Windows Server 2019 (1909)', 'Windows 10 (1909)'); // Desktop: Version 1909, Released 12.11.2019, EOS 11.05.2021
    19041: Result := IfThenStr(IsWindowsServer, 'Windows Server 2019 (2004)', 'Windows 10 (2004)'); // Desktop: Version 2004, Released 27.05.2020, EOS 14.12.2021
    19042: Result := IfThenStr(IsWindowsServer, 'Windows Server 2019 (20H2)', 'Windows 10 (20H2)'); // Desktop: Version 20H2, Released 20.10.2020, EOS 10.05.2022
    19043: Result := 'Windows 10 (21H1)'; // Version 21H1, Released 18.05.2021, EOS 13.12.2022
    19044: Result := 'Windows 10 (21H2)'; // Version 21H2, Released 16.11.2021, EOS 13.06.2023
    19045: Result := 'Windows 10 (22H2)'; // Version 22H2, Released 18.10.2022, EOS 14.10.2025
    20348: Result := IfThenStr(IsWindowsServer, 'Windows Server 2022', 'Windows 10 (21H2)');
    22000: Result := 'Windows 11 (21H2)'; // Version 21H2, Released 04.10.2021, EOS 10.10.2023
    22621: Result := 'Windows 11 (22H2)'; // Version 22H2, Released 20.09.2022, EOS 08.10.2024
    22631: Result := 'Windows 11 (23H2)'; // Version 23H2, Released 31.10.2023, EOS 11.11.2025
    26100: Result := 'Windows 11 (24H2)'; // Version 24H2, Released 01.10.2024, EOS 13.10.2026
    26200: Result := 'Windows 11 (25H2)'; // Version 25H2, Release Date: TBA, End of Mainstream Support: TBA, End of Enteprice support: TBA, LTCS Enterprise: TBA
    25398: Result := 'Windows Server 23H2';
    26052: Result := 'Windows Server 2025'; // Released 01.11.2024,
    else
      Result := GetWindowsBuildVersionStr(IfThenStr(AVersion.Build >= 22000, '11', '10'), AVersion);
  end
end;


function WindowsVersionStr: string;
var
  LVersion: TWindowsVersion;
begin
  GetWindowsVersionEx(LVersion);

  if LVersion.Major <= 5 then
    Result := 'Windows XP'
  else if LVersion.Major = 6 then
  begin
    case LVersion.Minor of
      0: Result := HandleVersion60(LVersion);
      1: Result := IfThenStr(IsWindowsServer, 'Windows Server 2008 R2 with Service Pack 1', 'Windows 7 SP1');
      2: Result := IfThenStr(IsWindowsServer, 'Windows Server 2012', 'Windows 8');
      3: Result := HandleVersion63(LVersion);
    end;
  end
  else if LVersion.Major = 10 then
    Result := HandleVersion10(LVersion)
  else if LVersion.Major > 10 then
    Result := GetWindowsBuildVersionStr('12', LVersion) //Maybe ??
  else
    Result := GetWindowsBuildVersionStr('', LVersion);
end;

// TODO: Unneeded comparisons made, fix
function CompareVersions(const AComparedVersion, AVersionComparedTo: TWindowsVersion; const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := False;

  if ACompareMethod = vcmOlder then
  begin
    Result := AVersionComparedTo.Major < AComparedVersion.Major;

    if not Result and (AComparedVersion.Major = AVersionComparedTo.Major) then
      Result := AVersionComparedTo.Minor < AComparedVersion.Minor;

    if not Result and (AComparedVersion.Build > 0) and (AComparedVersion.Major = AVersionComparedTo.Major) and (AVersionComparedTo.Minor = AComparedVersion.Minor) then
      Result :=  AVersionComparedTo.Build < AComparedVersion.Build;
  end
  else if ACompareMethod = vcmOlderOrEqual then
  begin
    Result := AVersionComparedTo.Major <= AComparedVersion.Major;

    if Result and (AComparedVersion.Major = AVersionComparedTo.Major) then
      Result := AVersionComparedTo.Minor <= AComparedVersion.Minor;

    if Result and (AComparedVersion.Build > 0) and (AComparedVersion.Major = AVersionComparedTo.Major) and (AComparedVersion.Minor = AVersionComparedTo.Minor) then
      Result := AVersionComparedTo.Build <= AComparedVersion.Build;
  end
  else if ACompareMethod = vcmEqual then
  begin
    Result := AVersionComparedTo.Major = AComparedVersion.Major;

    if Result and (AVersionComparedTo.Minor > 0) and (AComparedVersion.Major = AVersionComparedTo.Major) then
      Result := AVersionComparedTo.Minor = AComparedVersion.Minor;

    if Result and (AComparedVersion.Build > 0) and (AComparedVersion.Major = AVersionComparedTo.Major) and (AComparedVersion.Minor = AVersionComparedTo.Minor) then
      Result := AVersionComparedTo.Build = AComparedVersion.Build;
  end
  else if ACompareMethod = vcmNewerOrEqual then
  begin
    Result := AVersionComparedTo.Major >= AComparedVersion.Major;

    if Result and (AComparedVersion.Major = AVersionComparedTo.Major) then
      Result := AVersionComparedTo.Minor >= AComparedVersion.Minor;

    if Result and (AComparedVersion.Build > 0) and (AComparedVersion.Major = AVersionComparedTo.Major) and (AComparedVersion.Minor = AVersionComparedTo.Minor) then
      Result := AVersionComparedTo.Build >= AComparedVersion.Build;
  end
  else if ACompareMethod = vcmNewer then
  begin
    Result := AVersionComparedTo.Major > AComparedVersion.Major;

    if not Result and (AVersionComparedTo.Major = AComparedVersion.Major) then
      Result := AVersionComparedTo.Minor > AComparedVersion.Minor;

    if not Result and (AComparedVersion.Build > 0) and (AVersionComparedTo.Major = AComparedVersion.Major) and (AVersionComparedTo.Minor = AComparedVersion.Minor) then
      Result :=  AVersionComparedTo.Build > AComparedVersion.Build;
  end;
end;

function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TVersionCompareMethod): Boolean;
var
  LOSVersion: TWindowsVersion;
  LComparedVersion: TWindowsVersion;
begin
  GetWindowsVersionEx(LOSVersion);

  LComparedVersion.Major := AMajor;
  LComparedVersion.Minor := AMinor;
  LComparedVersion.Build := ABuild;

  Result := CompareVersions(LComparedVersion, LOSVersion, ACompareMethod);
end;

// 6.1.7600	Windows 7 or Windows Server 2008 R2
function IsWin7(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 1, 0, ACompareMethod);
end;

// Release Date: October 22, 2009
// End of Mainstream Support: January 13, 2015
// End of Extended Support: January 14, 2020
function IsWinServer2008r2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin7(ACompareMethod) and IsWindowsServer;
end;

// 6.2.9200	Windows 8 or Windows Server 2012
function IsWin8(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 2, 0, ACompareMethod);
end;

// Release Date: October 30, 2012
// End of Mainstream Support: October 9, 2018
// End of Extended Support: October 10, 2023
function IsWinServer2012(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin8(ACompareMethod) and IsWindowsServer;
end;

// 6.3.9200	Windows 8.1 or Windows Server 2012 R2
function IsWin81(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 3, 0, ACompareMethod);
end;

// Release Date: October 18, 2013
// End of Mainstream Support: October 9, 2018
// End of Extended Support: October 10, 2023
function IsWinServer2012r2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin81(ACompareMethod) and IsWindowsServer;
end;

// 10.0.14393	Windows 10 Version 1607 (Anniversary Update) or Windows Server 2016 - Support end date: Apr 10, 2018
function IsWin10_1067(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 14393, ACompareMethod);
end;

// Release Date: October 12, 2016
// End of Mainstream Support: January 11, 2022
// End of Extended Support: January 12, 2027
function IsWinServer2016(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin10_1067(ACompareMethod) and IsWindowsServer;
end;

// 10.0.17763	Windows 10 Version 1809 (October 2018 Update) or Windows Server 2019 - Support end date: Nov 10, 2020
function IsWin10_1809(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 17763, ACompareMethod);
end;

// Windows Server 1709 10.0.16299
function IsWinServer2016_1079(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result :=  IsWindowsVersion(10, 0, 16299, ACompareMethod) and IsWindowsServer;
end;

// Windows Server 1803 10.0.17134
function IsWinServer2016_1803(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result :=  IsWindowsVersion(10, 0, 17134, ACompareMethod) and IsWindowsServer;
end;

// Release Date: October 2, 2018
// End of Mainstream Support: January 9, 2024
// End of Extended Support: January 9, 2029
function IsWinServer2019(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin10_1809(ACompareMethod) and IsWindowsServer;
end;

// Windows Server 1903 10.0.18362
function IsWinServer2019_1903(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result :=  IsWindowsVersion(10, 0, 18362, ACompareMethod) and IsWindowsServer;
end;

// 10.0.18362	Windows 10 Version 1903 (May 2019 Update) - Support end date: Dec 8, 2020
function IsWin10_1903(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 18362, ACompareMethod);
end;

// 10.0.19041	Windows 10 Version 2004 (May 2020 Update) - Support end date:  Dec 14, 2022
function IsWin10_2004(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19041, ACompareMethod);
end;

// 10.0.19043	Windows 10 Version 21H1 (May 2021 Update) - Support end date: Dec 13, 2022
function IsWin10_21H1(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19043, ACompareMethod);
end;

// 10.0.19044	Windows 10 Version 21H2 (November 2021 Update) - Support end date: Jun 13, 2023
function IsWin10_21H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19044, ACompareMethod);
end;

// 19045 22H2 - Support started Oct 18, 2022 - Support end date: May 14, 2024
function IsWin10_22H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19045, ACompareMethod);
end;

// 10.0.20348
// Release Date: August 18, 2021
// End of Mainstream Support: October 13, 2026
// End of Extended Support: October 14, 2031
function IsWinServer2022(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 20348, ACompareMethod) and IsWindowsServer;
end;

// 10.0.22000	Windows 11 Version 21H2 - Support end date: October 10, 2023
function IsWin11_21H1(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22000, ACompareMethod);
end;

// 10.0.22621	Windows 11 Version 22H2 - Support end date: Oct 8, 2024
function IsWin11_22H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22621, ACompareMethod);
end;

// 10.0.22631	Windows 11 Version 23H2 - Support end date: Nov 11, 2025
function IsWin11_23H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22631, ACompareMethod);
end;

// 10.0.25398	Windows "11" Server Version 23H2 - Support end date:
//  - Microsoft Windows Server containers (to be come Windows server 2025, possibly, not on LTS version)
function IsWinServer_23H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 25398, ACompareMethod) and IsWindowsServer;
end;

// 10.0.26052: Windows Server 2025
// Released: 01.11.2024,
// Mainstream support: 13.11.2029
// Extended support: 14.11.2034
function IsWinServer_25H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26052, ACompareMethod) and IsWindowsServer;
end;


// 10.0.26100	Windows 11 Version 24H2
// Release Date: 01.10.2024
// End of Mainstream Support: 13.10.2026
// Enteprivce support: 12.10.2027
// LTCS Enterprise: 09.10.2029
function IsWin11_24H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26100, ACompareMethod);
end;

// 10.0.26100	Windows 11 Version 25H2
// Release Date: TBA
// End of Mainstream Support: TBA
// Enteprivce support: TBA
// LTCS Enterprise: TBA
function IsWin11_25H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26200, ACompareMethod);
end;

