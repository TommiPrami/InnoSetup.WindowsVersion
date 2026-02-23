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

  procedure SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
  procedure SetOsVersionToWin7;
  procedure RaiseException(const AExceptionMessage: string);

const
  // Constant values are the same as in Inno Setup
  VER_NT_WORKSTATION = 1;
  VER_NT_DOMAIN_CONTROLLER = 2;
  VER_NT_SERVER = 3;

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
