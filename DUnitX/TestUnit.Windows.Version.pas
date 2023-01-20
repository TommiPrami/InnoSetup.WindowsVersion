unit TestUnit.Windows.Version;

interface

uses
  System.SysUtils;

type
  TOsCompareMethod = (ocmOlder, ocmOlderOrEqual, ocmNewerOrEqual, ocmNewer);

  TWindowsVersion = record
    Major: Integer;
    Minor: Integer;
    Build: Integer;
    ProductType: Integer;

    constructor Create(const AMajor, AMinor, ABuild, AProductType: Integer);
    function ToString: string;
  end;

  function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TOsCompareMethod): Boolean;

var
  GOSVersion: TWindowsVersion;

const
  // TODO: Get real values
  VER_NT_WORKSTATION = 1;
  VER_NT_DOMAIN_CONTROLLER = 2;
  VER_NT_SERVER = 3;

implementation

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

// INNO SETUP ROUTINES (TO TEST)

function GetWindowsBuildVersionStr(const AMajorVersionStr: string; const AVersion: TWindowsVersion): string;
begin
  Result := 'Windows ' + AMajorVersionStr + ' (' + IntToStr(AVersion.Major) + '.' + IntToStr(AVersion.Minor) + '.'
    + IntToStr(AVersion.Build) + ')';
end;

function IsWindowsServer: Boolean;
var
  LVersion: TWindowsVersion;
begin
  GetWindowsVersionEx(LVersion);

  Result := not (LVersion.ProductType = VER_NT_WORKSTATION);
end;

function HandleVersion60(const AVersion: TWindowsVersion): string;
begin
  if AVersion.Build = 6000 then
    Result := 'Windows Vista' // 6.0.6000	Windows Vista
  else if AVersion.Build = 6001 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2008', 'Windows Vista') // 6.0.6001	Windows Vista with Service Pack 1 or Windows Server 2008
  else if AVersion.Build >= 7600 then
    Result := IfThenStr(IsWindowsServer, 'Windows Server 2008 R2', 'Windows 7');  // 6.1.7600	Windows 7 or Windows Server 2008 R2
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
    10240: Result := 'Windows 10 (1507)';
    10586: Result := 'Windows 10 (1511)';
    14393: Result := IfThenStr(IsWindowsServer, 'Windows Server 2016', '');
    15063: Result := 'Windows 10 (1703)';
    16299: Result := 'Windows 10 (1709)';
    17134: Result := 'Windows 10 (1803)';
    17763: Result := IfThenStr(IsWindowsServer, 'Windows Server 2019', '');
    18362: Result := 'Windows 10 (1903)';
    18363: Result := 'Windows 10 (1909)';
    19041: Result := 'Windows 10 (2004)';
    19042: Result := 'Windows 10 (20H2)';
    19043: Result := 'Windows 10 (21H1)';
    19044: Result := 'Windows 10 (21H2)';
    20348: Result := IfThenStr(IsWindowsServer, 'Windows 10 (21H2)', 'Windows Server 2022');
    22000: Result := 'Windows 11 (21H2)';
    22621: Result := 'Windows 11 (22H2)';
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
    Result := GetWindowsBuildVersionStr('12', LVersion); //Maybe ??
end;


function IsWindowsVersion(const AMajor, AMinor, ABuild: Integer; const ACompareMethod: TOsCompareMethod): Boolean;
var
  LVersion: TWindowsVersion;
begin
  Result := False;
  GetWindowsVersionEx(LVersion);

  if ACompareMethod = ocmOlder then
  begin
    Result := LVersion.Major < AMajor;

    if not Result and (AMajor = LVersion.Major) then
      Result := LVersion.Minor < AMinor;

    if not Result and (ABuild > 0) and (AMajor = LVersion.Major) and (LVersion.Minor = AMinor) then
      Result :=  LVersion.Build < ABuild;
  end
  else if ACompareMethod = ocmOlderOrEqual then
  begin
    Result := LVersion.Major <= AMajor;

    if Result and (AMajor = LVersion.Major) then
      Result := LVersion.Minor <= AMinor;

    if Result and (ABuild > 0) and (AMajor = LVersion.Major) and (AMinor = LVersion.Minor) then
      Result := LVersion.Build <= ABuild;
  end
  else if ACompareMethod = ocmNewerOrEqual then
  begin
    Result := AMajor >= LVersion.Major;

    if Result and (AMajor = LVersion.Major) then
      Result := AMinor >= LVersion.Minor;

    if Result and (ABuild > 0) and (AMajor = LVersion.Major) and (AMinor = LVersion.Minor) then
      Result := ABuild >= LVersion.Build;
  end
  else if ACompareMethod = ocmNewer then
  begin
    Result := AMajor > LVersion.Major;

    if not Result and (LVersion.Major = AMajor) then
      Result := AMinor > LVersion.Minor;

    if not Result and (ABuild > 0) and (LVersion.Major = AMajor) and (LVersion.Minor = AMinor) then
      Result :=  ABuild > LVersion.Build;
  end;
end;

// 6.1.7600	Windows 7 or Windows Server 2008 R2
function IsWin7(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 1, 0, ACompareMethod);
end;

function IsWinServer2008r2(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWin7(ACompareMethod) and IsWindowsServer;
end;


// 6.2.9200	Windows 8 or Windows Server 2012
function IsWin8(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 2, 0, ACompareMethod);
end;

function IsWinServer2012(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWin8(ACompareMethod) and IsWindowsServer;
end;

// 6.3.9200	Windows 8.1 or Windows Server 2012 R2
function IsWin81(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(6, 3, 0, ACompareMethod);
end;

function IsWinServer2012r2(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWin81(ACompareMethod) and IsWindowsServer;
end;

// 10.0.14393	Windows 10 Version 1607 (Anniversary Update) or Windows Server 2016 - Support end date: Apr 10, 2018
function IsWin10_1067(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 14393, ACompareMethod);
end;

function IsWinServer2016(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWin10_1067(ACompareMethod) and IsWindowsServer;
end;

// 10.0.17763	Windows 10 Version 1809 (October 2018 Update) or Windows Server 2019 - Support end date: Nov 10, 2020
function IsWin10_1809(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 17763, ACompareMethod);
end;

function IsWinServer2019(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWin10_1809(ACompareMethod) and IsWindowsServer;
end;

// 10.0.18362	Windows 10 Version 1903 (May 2019 Update) - Support end date: Dec 8, 2020
function IsWin10_1903(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 18362, ACompareMethod);
end;

// 10.0.19041	Windows 10 Version 2004 (May 2020 Update) - Support end date:  Dec 14, 2022
function IsWin10_2004(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19041, ACompareMethod);
end;

// 10.0.19043	Windows 10 Version 21H1 (May 2021 Update) - Support end date: Dec 13, 2022
function IsWin10_21H1(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19043, ACompareMethod);
end;

// 10.0.19044	Windows 10 Version 21H2 (November 2021 Update) - Support end date: Jun 13, 2023
function IsWin10_21H2(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19044, ACompareMethod);
end;

// 19045 22H2 - Support started Oct 18, 2022 - Support end date: May 14, 2024
function IsWin10_22H2(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 19045, ACompareMethod);
end;

// 10.0.20348	Windows Server 2022 Version 21H2
function IsWinServer2022(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 20348, ACompareMethod) and IsWindowsServer;
end;

// 10.0.22000	Windows 11 Version 21H2
function IsWin11_21H1(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22000, ACompareMethod);
end;

function IsWin11_22H2(const ACompareMethod: TOsCompareMethod): Boolean;
begin
  Result := IsWindowsVersion(10, 0, 22621, ACompareMethod);
end;


end.
