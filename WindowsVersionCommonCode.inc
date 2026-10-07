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
  // Fake GetProductInfo product type (for edition detection tests).
  GFakeProductTypeSet: Boolean;
  GFakeProductType: Cardinal;

procedure ClearFakeWindowsVersion;
begin
  GFakeOSVersionSet := False;
  GFakeProductTypeSet := False;
end;

// Single choke point: every OS-version query in this unit goes through here.
procedure GetActiveWindowsVersion(var AVersion: TWindowsVersion);
begin
  if GFakeOSVersionSet then
    AVersion := GFakeOSVersion
  else
    GetWindowsVersionEx(AVersion);
end;

// Sets the fake GetProductInfo product type (call independently of the fake OS
// version), so edition detection can be unit tested.
procedure SetFakeWindowsProductType(const AProductType: Cardinal);
begin
  GFakeProductType := AProductType;
  GFakeProductTypeSet := True;
end;

// Single choke point for the product type. GetWindowsProductInfoType is the
// environment-specific provider (Inno: real GetProductInfo WinAPI; DUnitX: a
// stub), mirroring GetWindowsVersionEx.
function GetActiveWindowsProductType: Cardinal;
begin
  if GFakeProductTypeSet then
    Result := GFakeProductType
  else
    Result := GetWindowsProductInfoType;
end;

function IsWindowsServer: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  Result := not (LVersion.ProductType = VER_NT_WORKSTATION);
end;

// A subset of GetProductInfo's PRODUCT_* values - enough to pick an edition
// family / support track. Not exhaustive; unlisted codes fall back to weUnknown
// (which maps to the Workstation track). Server SKUs are detected via ProductType.
const
  PRODUCT_HOME_BASIC            = $00000002;
  PRODUCT_HOME_PREMIUM          = $00000003;
  PRODUCT_HOME_BASIC_N          = $00000005;
  PRODUCT_HOME_PREMIUM_N        = $0000001A;
  PRODUCT_CORE_COUNTRYSPECIFIC  = $00000063;
  PRODUCT_CORE_N                = $00000062;
  PRODUCT_CORE_SINGLELANGUAGE   = $00000064;
  PRODUCT_CORE                  = $00000065;
  PRODUCT_PROFESSIONAL          = $00000030;
  PRODUCT_PROFESSIONAL_N        = $00000031;
  PRODUCT_PROFESSIONAL_WMC      = $00000067;
  PRODUCT_PRO_WORKSTATION       = $000000A1;
  PRODUCT_PRO_WORKSTATION_N     = $000000A2;
  PRODUCT_PRO_EDUCATION         = $000000A4;
  PRODUCT_PRO_EDUCATION_N       = $000000A5;
  PRODUCT_ENTERPRISE            = $00000004;
  PRODUCT_ENTERPRISE_N          = $0000001B;
  PRODUCT_ENTERPRISE_E          = $00000046;
  PRODUCT_ENTERPRISE_EVALUATION = $00000048;
  PRODUCT_ENTERPRISE_S          = $0000007D; // Enterprise LTSB/LTSC
  PRODUCT_ENTERPRISE_S_N        = $0000007E;
  PRODUCT_IOTENTERPRISE         = $000000BC;
  PRODUCT_IOTENTERPRISE_S       = $000000BF; // IoT Enterprise LTSC
  PRODUCT_EDUCATION             = $00000079;
  PRODUCT_EDUCATION_N           = $0000007A;

// Running OS edition family (see TWindowsEdition). Server SKUs report weServer;
// desktop editions come from GetProductInfo, with a VER_SUITE_PERSONAL fallback
// to weHome when the product type is unknown.
function GetWindowsEdition: TWindowsEdition;
var
  LVersion: TWindowsVersion;
  LProductType: Cardinal;
begin
  GetActiveWindowsVersion(LVersion);

  if not (LVersion.ProductType = VER_NT_WORKSTATION) then
  begin
    Result := weServer;
    Exit;
  end;

  LProductType := GetActiveWindowsProductType;

  case LProductType of
    PRODUCT_HOME_BASIC, PRODUCT_HOME_PREMIUM, PRODUCT_HOME_BASIC_N, PRODUCT_HOME_PREMIUM_N,
    PRODUCT_CORE, PRODUCT_CORE_N, PRODUCT_CORE_COUNTRYSPECIFIC, PRODUCT_CORE_SINGLELANGUAGE:
      Result := weHome;

    PRODUCT_PROFESSIONAL, PRODUCT_PROFESSIONAL_N, PRODUCT_PROFESSIONAL_WMC,
    PRODUCT_PRO_WORKSTATION, PRODUCT_PRO_WORKSTATION_N,
    PRODUCT_PRO_EDUCATION, PRODUCT_PRO_EDUCATION_N:
      Result := weProfessional;

    PRODUCT_ENTERPRISE, PRODUCT_ENTERPRISE_N, PRODUCT_ENTERPRISE_E, PRODUCT_ENTERPRISE_EVALUATION,
    PRODUCT_ENTERPRISE_S, PRODUCT_ENTERPRISE_S_N, PRODUCT_IOTENTERPRISE, PRODUCT_IOTENTERPRISE_S:
      Result := weEnterprise;

    PRODUCT_EDUCATION, PRODUCT_EDUCATION_N:
      Result := weEducation;
  else
    if (LVersion.SuiteMask and VER_SUITE_PERSONAL) <> 0 then
      Result := weHome
    else
      Result := weUnknown;
  end;
end;

// True on a Home edition (GetProductInfo, with VER_SUITE_PERSONAL fallback).
function IsWindowsHomeEdition: Boolean;
begin
  Result := GetWindowsEdition = weHome;
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
  Result := 'Windows ';
  if AMajorVersionStr <> '' then
    Result := Result + AMajorVersionStr + ' ';

  Result := Result + '(' + IntToStr(AVersion.Major) + '.' + IntToStr(AVersion.Minor) + '.'
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
  else if (AVersion.Build = 6002) or (AVersion.Build = 6003) then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2008 SP2', 'Windows Vista SP2')
  else
    Result := GetWindowsBuildVersionStr('Vista', AVersion);
end;

function HandleVersion63(const AVersion: TWindowsVersion): string;
var
  LIsWindowsServer: Boolean;
begin
  LIsWindowsServer := IsWindowsServerRecord(AVersion);

  if AVersion.Build >= 9600 then
    Result := IfThenStr(LIsWindowsServer, 'Windows Server 2012 R2', 'Windows 8.1')
  else
    Result := GetWindowsBuildVersionStr('8.1', AVersion);
end;

// Windows 10/11 era lookup table. Fixed-size static array + count, because Inno
// Setup's PascalScript supports neither initialized constant arrays nor the
// dynamic-array API (SetLength) that Delphi uses - a static array indexes the
// same in both. Populated once by EnsureWindowsVersionsInited.
var
  GWindowsVersions: array[0..63] of TWindowsReleaseRecord;
  GWindowsVersionCount: Integer;
  GWindowsVersionsInited: Boolean;

procedure AddWindowsVersion(const ABuild: Integer; const AName, AServerName: string;
  const ARelease, AActiveW, ASecurityW, AActiveE, ASecurityE, AActiveS, ASecurityS: Integer);
begin
  GWindowsVersions[GWindowsVersionCount].Build := ABuild;
  GWindowsVersions[GWindowsVersionCount].Name := AName;
  GWindowsVersions[GWindowsVersionCount].ServerName := AServerName;
  GWindowsVersions[GWindowsVersionCount].ReleaseDate := ARelease;
  GWindowsVersions[GWindowsVersionCount].ActiveSupportEndW := AActiveW;
  GWindowsVersions[GWindowsVersionCount].SecuritySupportEndW := ASecurityW;
  GWindowsVersions[GWindowsVersionCount].ActiveSupportEndE := AActiveE;
  GWindowsVersions[GWindowsVersionCount].SecuritySupportEndE := ASecurityE;
  GWindowsVersions[GWindowsVersionCount].ActiveSupportEndS := AActiveS;
  GWindowsVersions[GWindowsVersionCount].SecuritySupportEndS := ASecurityS;

  GWindowsVersionCount := GWindowsVersionCount + 1;
end;

// Support dates from endoflife.date/windows and /windows-server (snapshot
// 2026-10-06; refresh when new releases ship). Client LTSC / IoT cycles are
// intentionally excluded. Tracks: W = Workstation (Home/Pro/Pro Edu/Pro WS),
// E = Enterprise/Education, S = Server (LTSC/AC). Server columns are 0 for
// builds without a Server SKU; client columns are 0 for Server-only builds.
procedure EnsureWindowsVersionsInited;
begin
  if GWindowsVersionsInited then
    Exit;

  GWindowsVersionCount := 0;
  //                 Build   Client name            Server name (''=same)        Release   ActiveW   SecurityW ActiveE   SecurityE ActiveS   SecurityS
  AddWindowsVersion(10240, 'Windows 10 1507',       '',                          20150729, 20170509, 20170509, 20170509, 20170509, 0,        0);
  AddWindowsVersion(10586, 'Windows 10 1511',       '',                          20151110, 20171010, 20171010, 20171010, 20171010, 0,        0);
  AddWindowsVersion(14393, 'Windows 10 1607',       'Windows Server 2016',       20160802, 20180410, 20180410, 20190409, 20190409, 20220111, 20270112);
  AddWindowsVersion(15063, 'Windows 10 1703',       '',                          20170411, 20181009, 20181009, 20191008, 20191008, 0,        0);
  AddWindowsVersion(16299, 'Windows 10 1709',       'Windows Server 1709',       20171017, 20190409, 20190409, 20201013, 20201013, 20190409, 20190409);
  AddWindowsVersion(17134, 'Windows 10 1803',       'Windows Server 1803',       20180430, 20191112, 20191112, 20200511, 20210511, 20191112, 20191112);
  AddWindowsVersion(17763, 'Windows 10 1809',       'Windows Server 2019',       20181113, 20201110, 20201110, 20210511, 20210511, 20240109, 20290109);
  AddWindowsVersion(18362, 'Windows 10 1903',       'Windows Server 1903',       20190521, 20201208, 20201208, 20201208, 20201208, 20201208, 20201208);
  AddWindowsVersion(18363, 'Windows 10 1909',       'Windows Server 2019 1909',  20191112, 20210511, 20210511, 20220510, 20220510, 20210511, 20210511);
  AddWindowsVersion(19041, 'Windows 10 2004',       'Windows Server 2019 2004',  20200527, 20211214, 20211214, 20211214, 20211214, 20211214, 20211214);
  AddWindowsVersion(19042, 'Windows 10 20H2',       'Windows Server 2019 20H2',  20201020, 20220510, 20220510, 20230509, 20230509, 20220809, 20220809);
  AddWindowsVersion(19043, 'Windows 10 21H1',       '',                          20210518, 20221213, 20221213, 20221213, 20221213, 0,        0);
  AddWindowsVersion(19044, 'Windows 10 21H2',       '',                          20211116, 20230613, 20230613, 20240611, 20240611, 0,        0);
  AddWindowsVersion(19045, 'Windows 10 22H2',       '',                          20221018, 20251014, 20251014, 20251014, 20251014, 0,        0);
  AddWindowsVersion(20348, 'Windows 10 21H2',       'Windows Server 2022',       20210818, 0,        0,        0,        0,        20261013, 20311014);
  AddWindowsVersion(22000, 'Windows 11 21H2',       '',                          20211004, 20231010, 20231010, 20241008, 20241008, 0,        0);
  AddWindowsVersion(22621, 'Windows 11 22H2',       '',                          20220920, 20241008, 20241008, 20251014, 20251014, 0,        0);
  AddWindowsVersion(22631, 'Windows 11 23H2',       '',                          20231031, 20251111, 20251111, 20261110, 20261110, 0,        0);
  AddWindowsVersion(25398, 'Windows Server 23H2',   '',                          20231024, 0,        0,        0,        0,        20260512, 20260512);
  AddWindowsVersion(26052, 'Windows Server 2025',   '',                          20241101, 0,        0,        0,        0,        0,        0);
  AddWindowsVersion(26100, 'Windows 11 24H2',       'Windows Server 2025',       20241001, 20261013, 20261013, 20271012, 20271012, 20291113, 20341114);
  AddWindowsVersion(26200, 'Windows 11 25H2',       '',                          20250930, 20271012, 20271012, 20281010, 20281010, 0,        0);
  AddWindowsVersion(26300, 'Windows 11 26H2',       '',                          20260930, 20281010, 20281010, 20291009, 20291009, 0,        0);
  AddWindowsVersion(28000, 'Windows 11 26H1',       '',                          20260210, 20280314, 20280314, 20290313, 20290313, 0,        0);

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

// Active (mainstream) support end (YYYYMMDD) for a build on the given track,
// 0 if unknown / not applicable for that track.
function GetWindowsActiveSupportEndByBuild(const ABuild: Integer; const ATrack: TWindowsSupportTrack): Integer;
var
  LIndex: Integer;
begin
  Result := 0;

  LIndex := FindWindowsVersionIndex(ABuild);
  if LIndex >= 0 then
  begin
    if ATrack = stServer then
      Result := GWindowsVersions[LIndex].ActiveSupportEndS
    else if ATrack = stEnterprise then
      Result := GWindowsVersions[LIndex].ActiveSupportEndE
    else
      Result := GWindowsVersions[LIndex].ActiveSupportEndW;
  end;
end;

// Security support end (EOL, YYYYMMDD) for a build on the given track, 0 if
// unknown / not applicable for that track.
function GetWindowsSecuritySupportEndByBuild(const ABuild: Integer; const ATrack: TWindowsSupportTrack): Integer;
var
  LIndex: Integer;
begin
  Result := 0;

  LIndex := FindWindowsVersionIndex(ABuild);
  if LIndex >= 0 then
  begin
    if ATrack = stServer then
      Result := GWindowsVersions[LIndex].SecuritySupportEndS
    else if ATrack = stEnterprise then
      Result := GWindowsVersions[LIndex].SecuritySupportEndE
    else
      Result := GWindowsVersions[LIndex].SecuritySupportEndW;
  end;
end;

// Days since 1970-01-01 for a YYYYMMDD date (Howard Hinnant's days_from_civil,
// pure integer math - works identically in Inno PascalScript and Delphi). Lets
// callers add a day-count "slack" to a date; 0 in -> 0 out.
function YmdToSerial(const AYmd: Integer): Integer;
var
  LYear, LMonth, LDay, LEra, LYoe, LDoy, LDoe: Integer;
begin
  if AYmd <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  LYear := AYmd div 10000;
  LMonth := (AYmd div 100) mod 100;
  LDay := AYmd mod 100;

  if LMonth <= 2 then
    LYear := LYear - 1;

  if LYear >= 0 then
    LEra := LYear div 400
  else
    LEra := (LYear - 399) div 400;

  LYoe := LYear - LEra * 400;

  if LMonth > 2 then
    LDoy := (153 * (LMonth - 3) + 2) div 5 + LDay - 1
  else
    LDoy := (153 * (LMonth + 9) + 2) div 5 + LDay - 1;

  LDoe := LYoe * 365 + LYoe div 4 - LYoe div 100 + LDoy;

  Result := LEra * 146097 + LDoe - 719468;
end;

// True when ATodayYmd is more than ASlackDays past ADateYmd. A zero date means
// "unknown / not announced" and is treated as not-yet-past. Pass slack 0 for a
// plain "today is after the date" test; pass e.g. 100 to allow 100 days grace.
function IsPastWithSlackDays(const ADateYmd, ATodayYmd, ASlackDays: Integer): Boolean;
begin
  Result := (ADateYmd <> 0) and (YmdToSerial(ATodayYmd) > YmdToSerial(ADateYmd) + ASlackDays);
end;

// Pure "has this date passed" check (YYYYMMDD compare, no slack). 0 = unknown.
function IsSupportEnded(const AEndOfSupportYmd, ATodayYmd: Integer): Boolean;
begin
  Result := (AEndOfSupportYmd <> 0) and (ATodayYmd > AEndOfSupportYmd);
end;

// Signed day delta between a YYYYMMDD date and today: positive = date is that
// many days in the future, negative = that many days in the past, 0 = today.
function DaysUntil(const ADateYmd, ATodayYmd: Integer): Integer;
begin
  Result := YmdToSerial(ADateYmd) - YmdToSerial(ATodayYmd);
end;

// Human-readable duration words. Defaults are English; call SetDurationUnitWords
// early in the installer to localise (singular + plural are both needed because
// e.g. Finnish is not a simple +s: '1 vuosi' / '2 vuotta', '1 kuukausi' /
// '3 kuukautta'). DurationStr picks singular when the count is exactly 1.
var
  GDurationWordsSet: Boolean;
  GDaySingular, GDayPlural: string;
  GMonthSingular, GMonthPlural: string;
  GYearSingular, GYearPlural: string;

procedure EnsureDurationWordsInited;
begin
  if GDurationWordsSet then
    Exit;

  GDaySingular := 'day';     GDayPlural := 'days';
  GMonthSingular := 'month'; GMonthPlural := 'months';
  GYearSingular := 'year';   GYearPlural := 'years';
  GDurationWordsSet := True;
end;

procedure SetDurationUnitWords(const ADaySingular, ADayPlural, AMonthSingular, AMonthPlural,
  AYearSingular, AYearPlural: string);
begin
  GDaySingular := ADaySingular;     GDayPlural := ADayPlural;
  GMonthSingular := AMonthSingular; GMonthPlural := AMonthPlural;
  GYearSingular := AYearSingular;   GYearPlural := AYearPlural;
  GDurationWordsSet := True;
end;

function DurationUnit(const ACount: Integer; const ASingular, APlural: string): string;
begin
  Result := IntToStr(ACount) + ' ';
  if ACount = 1 then
    Result := Result + ASingular
  else
    Result := Result + APlural;
end;

// Formats a day count as an approximate, human-readable duration (magnitude;
// the sign of ADays is ignored - the caller phrases "ago"/"left"):
//   < 1 month : "N days"
//   < 1 year  : "N months"
//   >= 1 year : "Y years" or "Y years M months"
// Months/years are whole-unit approximations (30/365 days), not calendar-exact.
function DurationStr(const ADays: Integer): string;
var
  LDays, LYears, LRemainingMonths: Integer;
begin
  EnsureDurationWordsInited;

  if ADays < 0 then
    LDays := -ADays
  else
    LDays := ADays;

  if LDays < 30 then
    Result := DurationUnit(LDays, GDaySingular, GDayPlural)
  else if LDays < 365 then
    Result := DurationUnit(LDays div 30, GMonthSingular, GMonthPlural)
  else
  begin
    LYears := LDays div 365;
    LRemainingMonths := (LDays mod 365) div 30;

    Result := DurationUnit(LYears, GYearSingular, GYearPlural);
    if LRemainingMonths > 0 then
      Result := Result + ' ' + DurationUnit(LRemainingMonths, GMonthSingular, GMonthPlural);
  end;
end;

// Magnitude of the time between a YYYYMMDD date and today as a duration string.
// Empty when the date is unknown (0).
function DaysUntilStr(const ADateYmd, ATodayYmd: Integer): string;
begin
  if ADateYmd <= 0 then
    Result := ''
  else
    Result := DurationStr(DaysUntil(ADateYmd, ATodayYmd));
end;

// --- Current-OS convenience ---
// Track for the running OS, from its edition: Server SKUs use the Server track,
// Enterprise/Education the Enterprise track, everything else (Home, Pro, Pro WS,
// Pro Education, or unknown) the Workstation track.
function GetCurrentSupportTrack: TWindowsSupportTrack;
begin
  case GetWindowsEdition of
    weServer:
      Result := stServer;
    weEnterprise, weEducation:
      Result := stEnterprise;
  else
    Result := stWorkstation;
  end;
end;

function GetWindowsActiveSupportEnd: Integer;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  Result := GetWindowsActiveSupportEndByBuild(LVersion.Build, GetCurrentSupportTrack);
end;

function GetWindowsSecuritySupportEnd: Integer;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  Result := GetWindowsSecuritySupportEndByBuild(LVersion.Build, GetCurrentSupportTrack);
end;

// True when the running OS is past active (mainstream) support. Anything older
// than Windows 10 is always past support; an unknown (newer-than-table) Win10+
// build is assumed still supported.
function IsWindowsActiveSupportEnded(const ATodayYmd: Integer): Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  if LVersion.Major < 10 then
    Result := True
  else
    Result := IsSupportEnded(GetWindowsActiveSupportEndByBuild(LVersion.Build, GetCurrentSupportTrack), ATodayYmd);
end;

// True when the running OS is past security support (EOL). Same older/unknown
// rules as IsWindowsActiveSupportEnded.
function IsWindowsSecuritySupportEnded(const ATodayYmd: Integer): Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);

  if LVersion.Major < 10 then
    Result := True
  else
    Result := IsSupportEnded(GetWindowsSecuritySupportEndByBuild(LVersion.Build, GetCurrentSupportTrack), ATodayYmd);
end;

// One-call install gate: True while the running OS is still within security
// support, allowing ASlackDays of grace past the end date. Pre-Windows 10 is
// never supported; a build newer than the table is assumed supported.
function IsWindowsSupported(const ATodayYmd, ASlackDays: Integer): Boolean;
var
  LVersion: TWindowsVersion;
  LSecurityEnd: Integer;
begin
  GetActiveWindowsVersion(LVersion);

  if LVersion.Major < 10 then
    Result := False
  else
  begin
    LSecurityEnd := GetWindowsSecuritySupportEndByBuild(LVersion.Build, GetCurrentSupportTrack);
    if LSecurityEnd = 0 then
      Result := True
    else
      Result := not IsPastWithSlackDays(LSecurityEnd, ATodayYmd, ASlackDays);
  end;
end;

// Human-readable time until / since the running OS's security support end
// (magnitude only; the sign from DaysUntil tells "left" vs "ago"). Empty when
// the end date is unknown.
function WindowsSupportUntilStr(const ATodayYmd: Integer): string;
begin
  Result := DaysUntilStr(GetWindowsSecuritySupportEnd, ATodayYmd);
end;

// --- Family / accessor helpers ---

function GetWindowsBuildNumber: Integer;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  Result := LVersion.Build;
end;

procedure GetWindowsVersionParts(var AMajor, AMinor, ABuild: Integer);
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  AMajor := LVersion.Major;
  AMinor := LVersion.Minor;
  ABuild := LVersion.Build;
end;

// Windows 10 and 11 both report major 10; build 22000 is the 10/11 boundary.
function IsWindows10: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  Result := (LVersion.Major = 10) and (LVersion.Build < 22000);
end;

function IsWindows11: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetActiveWindowsVersion(LVersion);
  Result := (LVersion.Major = 10) and (LVersion.Build >= 22000);
end;

// --- Enum -> string (for display / logging) ---

function WindowsEditionToStr(const AEdition: TWindowsEdition): string;
begin
  case AEdition of
    weHome:         Result := 'Home';
    weProfessional: Result := 'Professional';
    weEnterprise:   Result := 'Enterprise';
    weEducation:    Result := 'Education';
    weServer:       Result := 'Server';
  else
    Result := 'Unknown';
  end;
end;

function WindowsSupportTrackToStr(const ATrack: TWindowsSupportTrack): string;
begin
  if ATrack = stServer then
    Result := 'Server'
  else if ATrack = stEnterprise then
    Result := 'Enterprise'
  else
    Result := 'Workstation';
end;

// Date the support table was captured from endoflife.date, and a staleness
// check so an installer can warn when the bundled data is old.
const
  WINDOWS_DATA_SNAPSHOT_YMD = 20261006;

function IsWindowsDataStale(const ATodayYmd, AMaxAgeDays: Integer): Boolean;
begin
  Result := (YmdToSerial(ATodayYmd) - YmdToSerial(WINDOWS_DATA_SNAPSHOT_YMD)) > AMaxAgeDays;
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
    else
      Result := GetWindowsBuildVersionStr('', AVersion);
    end;
  end
  else if AVersion.Major = 10 then
    Result := HandleVersion10(AVersion)
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

// Compares one version part. Result = True means this part is decisive (the
// parts differ); ACompareResult then holds the answer for ACompareMethod.
// Result = False means "not decisive" - either the part is skipped (-1 on
// either side, so partial versions work on both operands, e.g.
// CompareVersionsStr('10.1', '10.5.0')) or the parts are equal - and the
// caller moves on to the next part.
function ComparePart(const APartCompare, APartCompareTo: Integer; const ACompareMethod: TVersionCompareMethod; var ACompareResult: Boolean): Boolean;
begin
  Result := False;
  ACompareResult := False;

  if SkipVersion(APartCompare) or SkipVersion(APartCompareTo) then
    Exit;

  if APartCompare = APartCompareTo then
    Exit;

  Result := True;
  if APartCompare < APartCompareTo then
    ACompareResult := (ACompareMethod = vcmOlder) or (ACompareMethod = vcmOlderOrEqual)
  else // APartCompare > APartCompareTo
    ACompareResult := (ACompareMethod = vcmNewer) or (ACompareMethod = vcmNewerOrEqual);
end;

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
    RaiseException('Build part not skipped but minor part is, skipping must start from the rightmost version part');
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
          RaiseException('Unknown or unsupported comparison operator with index: ' + IntToStr(Integer(ACompareMethod)));
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

    LPart := Trim(LPart);

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

// 6.1.7601	Windows 7 SP1 or Windows Server 2008 R2 SP1
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

// 6.3.9600	Windows 8.1 or Windows Server 2012 R2
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
function IsWin10_1607(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 14393, ACompareMethod);
end;

// Release Date: October 12, 2016
//   - End of Mainstream Support: January 11, 2022
//   - End of Extended Support: January 12, 2027
function IsWinServer2016(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWin10_1607(ACompareMethod) and IsWindowsServer;
end;

// 10.0.17763	Windows 10 Version 1809 (October 2018 Update) or Windows Server 2019 
//   - Support end date: Nov 10, 2020
function IsWin10_1809(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 17763, ACompareMethod);
end;

// Windows Server 1709 10.0.16299
//   - end of support 2019.04.09
function IsWinServer2016_1709(const ACompareMethod: TVersionCompareMethod): Boolean;
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
//   - Support end date: October 14, 2025
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
function IsWin11_21H2(const ACompareMethod: TVersionCompareMethod): Boolean;
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

// 10.0.26100: Windows Server 2025 (shares the build with Windows 11 24H2)
//   - Released: 01.11.2024
//   - Mainstream support: 13.11.2029
//   - Extended support: 14.11.2034
function IsWinServer2025(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26100, ACompareMethod) and IsWindowsServer;
end;


// 10.0.26100	Windows 11 Version 24H2
//   - Release Date: 01.10.2024
//   - End of Mainstream Support: 13.10.2026
//   - Enterprise support: 12.10.2027
//   - LTSC Enterprise: 09.10.2029
function IsWin11_24H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26100, ACompareMethod);
end;

// 10.0.26200	Windows 11 Version 25H2
//   - Release Date: 30.09.2025
//   - End of Mainstream Support: 12.10.2027 (Workstation)
//   - Enterprise support: 10.10.2028
function IsWin11_25H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26200, ACompareMethod);
end;

// 10.0.26300	Windows 11 Version 26H2
//   - Release Date: 30.09.2026
//   - End of Mainstream Support: 10.10.2028 (Workstation)
//   - Enterprise support: 09.10.2029
function IsWin11_26H2(const ACompareMethod: TVersionCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 26300, ACompareMethod);
end;
