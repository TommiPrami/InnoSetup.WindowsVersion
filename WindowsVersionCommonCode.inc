// WindowsVersionCommonCode.inc

// Common code in between InnoSetup and Delphi-Unittest code

// Optional fake OS version, for unit testing. When not set (the default), the
// real GetWindowsVersionEx is used, so normal use is unaffected. When set via
// SetFakeWindowsVersion, every OS-version query in this unit uses the fake, so
// both the DUnitX tests and the Inno test installer can assert behaviour
// against a known Windows version. SetFakeWindowsVersion is defined further
// down, right after MakeWindowsVersionRecord (which it reuses).
var
  GFakeOSVersionSet: Boolean;
  GFakeOSVersion: TWindowsVersion;

procedure ClearFakeWindowsVersion;
begin
  GFakeOSVersionSet := False;
end;

// Single choke point: every OS-version query in this unit goes through here.
procedure GetActiveWindowsVersion(var AVersion: TWindowsVersion);
begin
  if GFakeOSVersionSet then
    AVersion := GFakeOSVersion
  else
    GetWindowsVersionEx(AVersion);
end;

function IsWindowsServer: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  Result := not (LVersion.ProductType = VER_NT_WORKSTATION);
end;

// True on a Home edition. Detected via the VER_SUITE_PERSONAL suite bit, which
// is the only edition signal GetWindowsVersionEx exposes. NOTE: it cannot tell
// Pro from Enterprise/Education (VER_SUITE_ENTERPRISE is the Server Enterprise
// suite, not desktop Enterprise) - that split needs the GetProductInfo WinAPI.
function IsWindowsHomeEdition: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  Result := (LVersion.SuiteMask and VER_SUITE_PERSONAL) <> 0;
end;

function IsWindowsServerRecord(const AVersion: TWindowsVersion): Boolean;
begin
  Result := not (AVersion.ProductType = VER_NT_WORKSTATION);
end;

function MakeWindowsVersionRecord(const AMajor, AMinor, ABuild: Cardinal; const AServer: Boolean): TWindowsVersion;
begin
  Result.Major := AMajor;
  Result.Minor := AMinor;
  Result.Build := ABuild;

  if AServer then
    Result.ProductType :=  VER_NT_SERVER
  else
    Result.ProductType := VER_NT_WORKSTATION;
  
  Result.ServicePackMajor := 0; // TODO: Support for ServicePackMajor
  Result.ServicePackMinor := 0;  // TODO: Support for ServicePackMinor
  Result.NTPlatform := True; // True if an NT-based platform
  Result.SuiteMask := 0; // TODO: Support for this?
end;

// Enables the fake OS version used by GetActiveWindowsVersion (see top of file).
procedure SetFakeWindowsVersion(const AMajor, AMinor, ABuild: Integer; const AServer: Boolean);
begin
  GFakeOSVersion := MakeWindowsVersionRecord(AMajor, AMinor, ABuild, AServer);
  GFakeOSVersionSet := True;
end;

// Sets the SuiteMask of the current fake OS (call after SetFakeWindowsVersion),
// so edition detection (e.g. IsWindowsHomeEdition) can be unit tested.
procedure SetFakeWindowsSuiteMask(const ASuiteMask: Integer);
begin
  GFakeOSVersion.SuiteMask := ASuiteMask;
end;

function GetWindowsBuildVersionStr(const AMajorVersionStr: string; const AVersion: TWindowsVersion): string;
begin
  Result := 'Windows ' + AMajorVersionStr + ' (' + IntToStr(AVersion.Major) + '.' + IntToStr(AVersion.Minor) + '.'
    + IntToStr(AVersion.Build) + ')';
end;

function HandleVersion60(const AVersion: TWindowsVersion): string;
var
  LIsWindowsServer: Boolean;
begin
  LIsWindowsServer := IsWindowsServerRecord(AVersion);
  
  if AVersion.Build = 6000 then
    Result := 'Windows Vista'
  else if AVersion.Build = 6001 then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2008', 'Windows Vista SP1')
  else if AVersion.Build = 6003 then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2008 SP2,', 'Windows Vista')
  else if AVersion.Build >= 7600 then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2008 R2', 'Windows 7')
  else
    Result := GetWindowsBuildVersionStr('Vista', AVersion);
end;

function HandleVersion63(const AVersion: TWindowsVersion): string;
var
  LIsWindowsServer: Boolean;
begin
  LIsWindowsServer := IsWindowsServerRecord(AVersion);

  if AVersion.Build = 9200 then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2012 R2', 'Windows 8.1')
  else if AVersion.Build >= 9600 then
    Result := 'Windows 8.1 Update 1'
  else
    Result := GetWindowsBuildVersionStr('8.1', AVersion);
end;

// Windows 10/11 era lookup table. Fixed-size static array + count, because Inno
// Setup's PascalScript supports neither initialized constant arrays nor the
// dynamic-array API (SetLength) that Delphi uses - a static array indexes the
// same in both. Populated once by EnsureWindowsVersionsInited.
var
  GWindowsVersions: array[0..63] of TWindowsVersionRec;
  GWindowsVersionCount: Integer;
  GWindowsVersionsInited: Boolean;

procedure AddWindowsVersion(const ABuild: Integer; const AName, AServerName: string;
  const ARelease, AEndOfSupport, AEndOfSupportExtended: Integer);
begin
  GWindowsVersions[GWindowsVersionCount].Build := ABuild;
  GWindowsVersions[GWindowsVersionCount].Name := AName;
  GWindowsVersions[GWindowsVersionCount].ServerName := AServerName;
  GWindowsVersions[GWindowsVersionCount].ReleaseDate := ARelease;
  GWindowsVersions[GWindowsVersionCount].EndOfSupport := AEndOfSupport;
  GWindowsVersions[GWindowsVersionCount].EndOfSupportExtended := AEndOfSupportExtended;

  GWindowsVersionCount := GWindowsVersionCount + 1;
end;

procedure EnsureWindowsVersionsInited;
begin
  if GWindowsVersionsInited then
    Exit;

  GWindowsVersionCount := 0;
  //                 Build   Client name            Server name (''=same)        Release   EndOfSupport  Extended/Ent
  AddWindowsVersion(10240, 'Windows 10 1507',       '',                          20150729, 20170509,     0);
  AddWindowsVersion(10586, 'Windows 10 1511',       '',                          20151110, 20171010,     0);
  AddWindowsVersion(14393, 'Windows 10 1607',       'Windows Server 2016',       20160802, 20180410,     0);
  AddWindowsVersion(15063, 'Windows 10 1703',       '',                          20170411, 20181009,     0);
  AddWindowsVersion(16299, 'Windows 10 1709',       '',                          20171017, 20190409,     0);
  AddWindowsVersion(17134, 'Windows 10 1803',       '',                          20180430, 20191112,     0);
  AddWindowsVersion(17763, 'Windows 10 1809',       'Windows Server 2019',       20181113, 20201110,     0);
  AddWindowsVersion(18362, 'Windows 10 1903',       '',                          20190521, 20201208,     0);
  AddWindowsVersion(18363, 'Windows 10 1909',       'Windows Server 2019 1909',  20191112, 20210511,     0);
  AddWindowsVersion(19041, 'Windows 10 2004',       'Windows Server 2019 2004',  20200527, 20211214,     0);
  AddWindowsVersion(19042, 'Windows 10 20H2',       'Windows Server 2019 20H2',  20201020, 20220510,     0);
  AddWindowsVersion(19043, 'Windows 10 21H1',       '',                          20210518, 20221213,     0);
  AddWindowsVersion(19044, 'Windows 10 21H2',       '',                          20211116, 20230613,     0);
  AddWindowsVersion(19045, 'Windows 10 22H2',       '',                          20221018, 20251014,     0);
  AddWindowsVersion(20348, 'Windows 10 21H2',       'Windows Server 2022',       20210818, 20261013,     20311014);
  AddWindowsVersion(22000, 'Windows 11 21H2',       '',                          20211004, 20231010,     0);
  AddWindowsVersion(22621, 'Windows 11 22H2',       '',                          20220920, 20241008,     0);
  AddWindowsVersion(22631, 'Windows 11 23H2',       '',                          20231031, 20251111,     0);
  AddWindowsVersion(25398, 'Windows Server 23H2',   '',                          0,        0,            0);
  AddWindowsVersion(26052, 'Windows Server 2025',   '',                          20241101, 20291113,     20341114);
  AddWindowsVersion(26100, 'Windows 11 24H2',       '',                          20241001, 20261013,     20271012);
  AddWindowsVersion(26200, 'Windows 11 25H2',       '',                          20250930, 0,            0);
  AddWindowsVersion(26300, 'Windows 11 26H2',       '',                          20260930, 0,            0);

  GWindowsVersionsInited := True;
end;

// Index of the row for ABuild, or -1 if not in the table.
function FindWindowsVersionIndex(const ABuild: Integer): Integer;
var
  LIndex: Integer;
begin
  EnsureWindowsVersionsInited;

  Result := -1;

  for LIndex := 0 to GWindowsVersionCount - 1 do
  begin
    if GWindowsVersions[LIndex].Build = ABuild then
    begin
      Result := LIndex;
      Break;
    end;
  end;
end;

// Name for a Win10/11 build, '' if not found. Uses the Server name on Server SKUs.
function WindowsNameForBuild(const ABuild: Integer; const AServer: Boolean): string;
var
  LIndex: Integer;
begin
  Result := '';

  LIndex := FindWindowsVersionIndex(ABuild);
  if LIndex >= 0 then
  begin
    if AServer and (GWindowsVersions[LIndex].ServerName <> '') then
      Result := GWindowsVersions[LIndex].ServerName
    else
      Result := GWindowsVersions[LIndex].Name;
  end;
end;

function HandleVersion10(const AVersion: TWindowsVersion): string;
begin
  Result := WindowsNameForBuild(AVersion.Build, IsWindowsServerRecord(AVersion));

  if Result = '' then
    Result := GetWindowsBuildVersionStr(IfThenStr(AVersion.Build >= 22000, '11', '10'), AVersion);
end;

// End-of-support date (YYYYMMDD) for a Win10/11 build, 0 if unknown. When
// AExtended is True returns the Enterprise/Education / extended date if the
// table has one, otherwise the consumer date.
function GetWindowsEndOfSupport(const ABuild: Integer; const AExtended: Boolean): Integer;
var
  LIndex: Integer;
begin
  Result := 0;

  LIndex := FindWindowsVersionIndex(ABuild);
  if LIndex >= 0 then
  begin
    if AExtended and (GWindowsVersions[LIndex].EndOfSupportExtended <> 0) then
      Result := GWindowsVersions[LIndex].EndOfSupportExtended
    else
      Result := GWindowsVersions[LIndex].EndOfSupport;
  end;
end;

// Pure date comparison. AEndOfSupportYmd and ATodayYmd are YYYYMMDD. A zero EOS
// means "unknown / not announced" and is treated as still supported.
function IsSupportEnded(const AEndOfSupportYmd, ATodayYmd: Integer): Boolean;
begin
  Result := (AEndOfSupportYmd <> 0) and (ATodayYmd > AEndOfSupportYmd);
end;

function WindowsVersion(const AVersion: TWindowsVersion): string;
var
  LIsWindowsServer: Boolean;
begin
  LIsWindowsServer := IsWindowsServerRecord(AVersion);
  
  if AVersion.Major <= 5 then
    Result := 'Windows XP'
  else if AVersion.Major = 6 then
  begin
    case AVersion.Minor of
      0: Result := HandleVersion60(AVersion);
      1: Result := IfThenStr(LIsWindowsServer, 'Windows Server 2008 R2 with Service Pack 1', 'Windows 7 SP1');
      2: Result := IfThenStr(LIsWindowsServer, 'Windows Server 2012', 'Windows 8');
      3: Result := HandleVersion63(AVersion);
    end;
  end
  else if AVersion.Major = 10 then
    Result := HandleVersion10(AVersion)
  else if AVersion.Major > 10 then
    Result := GetWindowsBuildVersionStr('12', AVersion) //Maybe ??
  else
    Result := GetWindowsBuildVersionStr('', AVersion);
end;

function WindowsVersionStr: string;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  Result := WindowsVersion(LVersion);
end;

function SkipVersion(const AVersionPart: Integer): Boolean;
begin
  Result := AVersionPart = -1;
end;

function SkipMinor(const AComparedVersion: TWindowsVersionInfo): Boolean;
begin
  Result := SkipVersion(AComparedVersion.Minor);
end;

function SkipBuild(const AComparedVersion: TWindowsVersionInfo): Boolean;
begin
  Result := SkipVersion(AComparedVersion.Build);
end;

function ComparePart(const APartConmpare, APartConmpareTo: Integer; const ACompareMethod: TVersionCompareMethod; var ACompareResult: Boolean): Boolean;
begin
  Result := False;
  ACompareResult := False;

  // A part is skipped when EITHER side marks it -1, so partial versions work
  // on both operands (e.g. CompareVersionsStr('10.1', '10.5.0')).
  if not (SkipVersion(APartConmpare) or SkipVersion(APartConmpareTo)) then
  begin
    if ACompareMethod = vcmOlder then
    begin
      if APartConmpare < APartConmpareTo then
      begin
        Result := True;
        ACompareResult := True;
      end
      else if APartConmpare > APartConmpareTo then
      begin
        Result := True;
        ACompareResult := False;
      end
    end
    else if ACompareMethod = vcmOlderOrEqual then
    begin
      if APartConmpare < APartConmpareTo then
      begin
        Result := True;
        ACompareResult := True;
      end
      else if APartConmpare > APartConmpareTo then
      begin
        Result := True;
        ACompareResult := False;
      end;
    end
    else if ACompareMethod = vcmEqual then
    begin
      if APartConmpare <> APartConmpareTo then
      begin
        Result := True;
        ACompareResult := False;
      end;
    end
    else if ACompareMethod = vcmNewerOrEqual then
    begin
      if APartConmpare < APartConmpareTo then
      begin
        Result := True;
        ACompareResult := False;
      end
      else if APartConmpare > APartConmpareTo then
      begin
        Result := True;
        ACompareResult := True;
      end;
    end
    else if ACompareMethod = vcmNewer then
    begin
      if APartConmpare < APartConmpareTo then
      begin
        Result := True;
        ACompareResult := False;
      end
      else if APartConmpare > APartConmpareTo then
      begin
        Result := True;
        ACompareResult := True;
      end;
    end;
  end;
end;

// TODO:  Maybe should change the logic in a way that,
//        if part of version is negative, then it is given.
//        Now that zero is used, it'll cause problems or
//        potentiel headache, also code is way too complec because of this.
function CompareVersions(const AComparedVersion, AVersionComparedTo: TWindowsVersionInfo; const ACompareMethod: TVersionCompareMethod): Boolean;
var
  LComparePartResult: Boolean;
begin
  Result := False;

  if AComparedVersion.Major <= 0 then
  begin
    RaiseException('Major part of compared version must be greater than 0');
    // TODO: maybe compare result to parameter and result would be error/NoError
    Exit;
  end;

  if AVersionComparedTo.Major <= 0 then
  begin
    RaiseException('Major part of comparedTo version must be greater than 0');
    // TODO: maybe compare result to parameter and result would be error/NoError
    Exit;
  end;

  if (SkipMinor(AComparedVersion) and not SkipBuild(AComparedVersion))
    or (SkipMinor(AVersionComparedTo) and not SkipBuild(AVersionComparedTo)) then
  begin
    RaiseException('Build part not skipped but minor part is, skipping must strat from the the rightmost version part');
    // TODO: maybe compare result to parameter and result would be error/NoError
    Exit;
  end;

  if ComparePart(AComparedVersion.Major, AVersionComparedTo.Major, ACompareMethod, LComparePartResult) then
    Result := LComparePartResult
  else
  begin
    if ComparePart(AComparedVersion.Minor, AVersionComparedTo.Minor, ACompareMethod, LComparePartResult) then
      Result := LComparePartResult
    else
    begin
      if ComparePart(AComparedVersion.Build, AVersionComparedTo.Build, ACompareMethod, LComparePartResult) then
        Result := LComparePartResult
      else
      begin
        if ACompareMethod = vcmOlder then
          Result := False
        else if ACompareMethod = vcmOlderOrEqual then
          Result := True
        else if ACompareMethod = vcmEqual then
          Result := True
        else if ACompareMethod = vcmNewerOrEqual then
          Result := True
        else if ACompareMethod = vcmNewer then
          Result := False
        else
          RaiseException('Unknown or unsupported comparation operator with index: ' + IntToStr(Integer(ACompareMethod)));
      end;
    end;
  end;
end;

// Parses a dotted version string ('10', '10.1', '10.0.19045') into the compare
// record. Missing trailing parts become -1 (= "skip" in comparisons). Any part
// beyond Build (e.g. the revision in '10.0.19045.1234') is ignored. A missing
// or non-numeric part is treated as -1.
function ParseVersionString(const AVersionStr: string): TWindowsVersionInfo;
var
  LRemaining: string;
  LPart: string;
  LDotPos: Integer;
  LIndex: Integer;
begin
  Result.Major := -1;
  Result.Minor := -1;
  Result.Build := -1;
  Result.ServicePackMajor := 0;
  Result.ServicePackMinor := 0;
  Result.NTPlatform := True;
  Result.ProductType := VER_NT_WORKSTATION;
  Result.SuiteMask := 0;

  LRemaining := AVersionStr;
  LIndex := 0;

  while (LRemaining <> '') and (LIndex <= 2) do
  begin
    LDotPos := Pos('.', LRemaining);

    if LDotPos > 0 then
    begin
      LPart := Copy(LRemaining, 1, LDotPos - 1);
      LRemaining := Copy(LRemaining, LDotPos + 1, Length(LRemaining));
    end
    else
    begin
      LPart := LRemaining;
      LRemaining := '';
    end;

    if LPart <> '' then
    begin
      if LIndex = 0 then
        Result.Major := StrToIntDef(LPart, -1)
      else if LIndex = 1 then
        Result.Minor := StrToIntDef(LPart, -1)
      else
        Result.Build := StrToIntDef(LPart, -1);
    end;

    LIndex := LIndex + 1;
  end;
end;

// Compares two version strings: "is AVersion {method} AVersionComparedTo".
// Either string may be whole or partial (see ParseVersionString).
function CompareVersionsStr(const AVersion, AVersionComparedTo: string; const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := CompareVersions(ParseVersionString(AVersion), ParseVersionString(AVersionComparedTo), ACompareMethod);
end;

// Converts Inno Setup's (unsigned) TWindowsVersion into the signed-Integer
// comparison record, so partial comparison with -1 "skip" markers works.
function WindowsVersionToInfo(const AVersion: TWindowsVersion): TWindowsVersionInfo;
begin
  Result.Major := AVersion.Major;
  Result.Minor := AVersion.Minor;
  Result.Build := AVersion.Build;
  Result.ServicePackMajor := AVersion.ServicePackMajor;
  Result.ServicePackMinor := AVersion.ServicePackMinor;
  Result.NTPlatform := AVersion.NTPlatform;
  Result.ProductType := AVersion.ProductType;
  Result.SuiteMask := AVersion.SuiteMask;
end;

function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TVersionCompareMethod): Boolean;
var
  LOSVersion: TWindowsVersion;
  LOSVersionInfo: TWindowsVersionInfo;
  LComparedVersion: TWindowsVersionInfo;
begin
  GetActiveWindowsVersion(LOSVersion);
  LOSVersionInfo := WindowsVersionToInfo(LOSVersion);

  LComparedVersion.Major := AMajor;
  LComparedVersion.Minor := AMinor;
  LComparedVersion.Build := ABuild;

  Result := CompareVersions(LOSVersionInfo, LComparedVersion, ACompareMethod);
end;

// 6.1.7600	Windows 7 or Windows Server 2008 R2
function IsWin7(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 1, 7601, ACompareMethod);
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
  Result := IsWindowsVersion(6, 2, 9200, ACompareMethod);
end;

// Release Date: October 30, 2012
//   - End of Mainstream Support: October 9, 2018
//   - End of Extended Support: October 10, 2023
function IsWinServer2012(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin8(ACompareMethod) and IsWindowsServer;
end;

// 6.3.9200	Windows 8.1 or Windows Server 2012 R2
function IsWin81(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 3, 9600, ACompareMethod);
end;

// Release Date: October 18, 2013
//   - End of Mainstream Support: October 9, 2018
//   - End of Extended Support: October 10, 2023
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
//   - End of Mainstream Support: January 11, 2022
//   - End of Extended Support: January 12, 2027
function IsWinServer2016(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin10_1067(ACompareMethod) and IsWindowsServer;
end;

// 10.0.17763	Windows 10 Version 1809 (October 2018 Update) or Windows Server 2019 
//   - Support end date: Nov 10, 2020
function IsWin10_1809(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 17763, ACompareMethod);
end;

// Windows Server 1709 10.0.16299
//   - end of support 2019.04.09
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
//   - End of Mainstream Support: January 9, 2024
//   - End of Extended Support: January 9, 2029
function IsWinServer2019(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin10_1809(ACompareMethod) and IsWindowsServer;
end;

// Windows Server 1903 10.0.18362
function IsWinServer2019_1903(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result :=  IsWindowsVersion(10, 0, 18362, ACompareMethod) and IsWindowsServer;
end;

// 10.0.18362	Windows 10 Version 1903 (May 2019 Update)
//   - Support end date: Dec 8, 2020
function IsWin10_1903(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 18362, ACompareMethod);
end;

// 10.0.19041	Windows 10 Version 2004 (May 2020 Update)
//   - Support end date:  Dec 14, 2022
function IsWin10_2004(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19041, ACompareMethod);
end;

// 10.0.19043	Windows 10 Version 21H1 (May 2021 Update)
//   - Support end date: Dec 13, 2022
function IsWin10_21H1(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19043, ACompareMethod);
end;

// 10.0.19044	Windows 10 Version 21H2 (November 2021 Update)
//   - Support end date: Jun 13, 2023
function IsWin10_21H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19044, ACompareMethod);
end;

// 19045 22H2 - Support started Oct 18, 2022
//   - Support end date: May 14, 2024
function IsWin10_22H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19045, ACompareMethod);
end;

// 10.0.20348
// Release Date: August 18, 2021
//   - End of Mainstream Support: October 13, 2026
//   - End of Extended Support: October 14, 2031
function IsWinServer2022(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 20348, ACompareMethod) and IsWindowsServer;
end;

// 10.0.22000	Windows 11 Version 21H2 
//   - Support end date: October 10, 2023
function IsWin11_21H1(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22000, ACompareMethod);
end;

// 10.0.22621	Windows 11 Version 22H2
//   - Support end date: Oct 8, 2024
function IsWin11_22H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22621, ACompareMethod);
end;

// 10.0.22631	Windows 11 Version 23H2
//   - Support end date: Nov 11, 2025
function IsWin11_23H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22631, ACompareMethod);
end;

// 10.0.25398	Windows "11" Server Version 23H2
//   - Support end date:
//   - Microsoft Windows Server containers (to be come Windows server 2025, possibly, not on LTS version)
function IsWinServer_23H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 25398, ACompareMethod) and IsWindowsServer;
end;

// 10.0.26052: Windows Server 2025
//   - Released: 01.11.2024,
//   - Mainstream support: 13.11.2029
//   - Extended support: 14.11.2034
function IsWinServer_25H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26052, ACompareMethod) and IsWindowsServer;
end;


// 10.0.26100	Windows 11 Version 24H2
//   - Release Date: 01.10.2024
//   - End of Mainstream Support: 13.10.2026
//   - Enteprivce support: 12.10.2027
//   - LTCS Enterprise: 09.10.2029
function IsWin11_24H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26100, ACompareMethod);
end;

// 10.0.26200	Windows 11 Version 25H2
//   - Release Date: 30.09.2025
//   - End of Mainstream Support: TBA
//   - Enteprivce support: TBA
//   - LTCS Enterprise: TBA
function IsWin11_25H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26200, ACompareMethod);
end;

// 10.0.26300	Windows 11 Version 26H2
//   - Release Date: 30.09.2026
//   - End of Mainstream Support: TBA
//   - Enteprivce support: TBA
//   - LTCS Enterprise: TBA
function IsWin11_26H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26300, ACompareMethod);
end;
