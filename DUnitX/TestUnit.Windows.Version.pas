unit TestUnit.Windows.Version;

interface

uses
  System.SysUtils;

{$INCLUDE ..\WindowsVersionTypes.inc}

type
  TWindowsVersion = record
    Major: Integer;
    Minor: Integer;
    Build: Integer;
    ProductType: Integer;

    constructor Create(const AMajor, AMinor, ABuild, AProductType: Integer);
    function ToString: string;
  end;

  function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TVersionCompareMethod): Boolean;

  procedure SetOSVersion(const AMajor, AMinor, ABuild: Integer; const AProductType: Integer = 1);
  procedure SetOsVersionToWin7;

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

constructor TWindowsVersion.Create(const AMajor, AMinor, ABuild, AProductType: Integer);
begin
  Major := AMajor;
  Minor := AMinor;
  Build := ABuild;
  //
  ProductType := AProductType;
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

// INNO SETUP ROUTINES (TO TEST) ARE IN THE COMMON INC-FILE

{$INCLUDE ..\WindowsVersionCommonCode.inc}

end.
