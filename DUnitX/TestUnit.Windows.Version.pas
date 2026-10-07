unit TestUnit.Windows.Version;

interface

uses
  System.SysUtils;

{$INCLUDE ..\WindowsVersionTypes.inc}

type
  TWindowsVersion = record
    Major: Cardinal;
    Minor: Cardinal;
    Build: Cardinal;
    ProductType: Byte;
    ServicePackMajor: Cardinal;  // Major version number of service pack
    ServicePackMinor: Cardinal;  // Minor version number of service pack
    NTPlatform: Boolean;         // True if an NT-based platform
    SuiteMask: Word;

    constructor Create(const AMajor, AMinor, ABuild: Cardinal; const AProductType: Byte; const AServicePackMajor: Cardinal = 0;
      const AServicePackMinor: Cardinal = 0; const ANTPlatform: Boolean = True; const ASuiteMask: Word = 0);
    function ToString: string;
  end;

  function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TVersionCompareMethod): Boolean;
  function CompareVersionsStr(const AVersion, AVersionComparedTo: string; const ACompareMethod: TVersionCompareMethod): Boolean;
  function WindowsVersionStr: string;
  function WindowsNameForBuild(const ABuild: Integer; const AServer: Boolean): string;
  function IsWindowsHomeEdition: Boolean;
  function GetWindowsEdition: TWindowsEdition;
  function GetCurrentSupportTrack: TWindowsSupportTrack;
  function GetWindowsActiveSupportEndByBuild(const ABuild: Integer; const ATrack: TWindowsSupportTrack): Integer;
  function GetWindowsSecuritySupportEndByBuild(const ABuild: Integer; const ATrack: TWindowsSupportTrack): Integer;
  function IsWindowsActiveSupportEnded(const ATodayYmd: Integer): Boolean;
  function IsWindowsSecuritySupportEnded(const ATodayYmd: Integer): Boolean;
  function IsSupportEnded(const AEndOfSupportYmd, ATodayYmd: Integer): Boolean;
  function IsPastWithSlackDays(const ADateYmd, ATodayYmd, ASlackDays: Integer): Boolean;
  function YmdToSerial(const AYmd: Integer): Integer;
  function DaysUntil(const ADateYmd, ATodayYmd: Integer): Integer;
  function DurationStr(const ADays: Integer): string;
  function DaysUntilStr(const ADateYmd, ATodayYmd: Integer): string;
  procedure SetDurationUnitWords(const ADaySingular, ADayPlural, AMonthSingular, AMonthPlural,
    AYearSingular, AYearPlural: string);
  function IsWindowsSupported(const ATodayYmd, ASlackDays: Integer): Boolean;
  function WindowsSupportUntilStr(const ATodayYmd: Integer): string;
  function GetWindowsBuildNumber: Integer;
  function IsWindows10: Boolean;
  function IsWindows11: Boolean;
  function WindowsEditionToStr(const AEdition: TWindowsEdition): string;
  function WindowsSupportTrackToStr(const ATrack: TWindowsSupportTrack): string;
  function IsWindowsDataStale(const ATodayYmd, AMaxAgeDays: Integer): Boolean;

  // Fake OS controls (defined in the shared common code) exposed for tests.
  procedure SetFakeWindowsVersion(const AMajor, AMinor, ABuild: Integer; const AServer: Boolean);
  procedure SetFakeWindowsSuiteMask(const ASuiteMask: Integer);
  procedure SetFakeWindowsProductType(const AProductType: Cardinal);
  procedure ClearFakeWindowsVersion;

  procedure SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
  procedure SetOsVersionToWin7;
  procedure RaiseException(const AExceptionMessage: string);

const
  // Constant values are the same as in Inno Setup
  VER_NT_WORKSTATION = 1;
  VER_NT_DOMAIN_CONTROLLER = 2;
  VER_NT_SERVER = 3;
  VER_SUITE_PERSONAL = $0200;

implementation

var
  GOSVersion: TWindowsVersion;

procedure SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
begin
  GOSVersion := TWindowsVersion.Create(AMajor, AMinor, ABuild, AProductType);
end;

procedure SetOsVersionToWin7;
begin
  SetOSVersion(6, 1, 7600, VER_NT_WORKSTATION);
end;

{ TWindowsVersion }

constructor TWindowsVersion.Create(const AMajor, AMinor, ABuild: Cardinal; const AProductType: Byte;
  const AServicePackMajor: Cardinal = 0; const AServicePackMinor: Cardinal = 0; const ANTPlatform: Boolean = True;
  const ASuiteMask: Word = 0);
begin
  Major := AMajor;
  Minor := AMinor;
  Build := ABuild;
  //
  ProductType := AProductType;
  ServicePackMajor := AServicePackMajor;
  ServicePackMinor := AServicePackMinor;
  NTPlatform := ANTPlatform;
  SuiteMask := ASuiteMask;
end;

function TWindowsVersion.ToString: string;
begin
  Result := Format('%d.%d.%d', [Major, Minor, Build]);

  if ProductType = VER_NT_SERVER then
    Result := Result + ' (Server)'
  else if ProductType = VER_NT_DOMAIN_CONTROLLER then
    Result := Result + ' (Server - Domain Controller)'
end;

procedure GetWindowsVersionEx(out AWindowsVersion: TWindowsVersion);
begin
  AWindowsVersion := GOSVersion;
end;

// Environment provider for the product type. In the DUnitX harness there is no
// real GetProductInfo call; tests drive edition detection through the fake
// (SetFakeWindowsProductType), so the stub reports "undefined".
function GetWindowsProductInfoType: Cardinal;
begin
  Result := 0;
end;

function IfThenStr(const ABoolValue: Boolean; const ATrueStr, AFalseStr: string): string;
begin
  if ABoolValue then
    Result := ATrueStr
  else
    Result := AFalseStr;
end;

procedure RaiseException(const AExceptionMessage: string);
begin
  raise Exception.Create(AExceptionMessage);
end;


// INNO SETUP ROUTINES (TO TEST) ARE IN THE COMMON INC-FILE

{$INCLUDE ..\WindowsVersionCommonCode.inc}

end.
