// WindowsVersion.iss

// Good lists of version info: 
//   - https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
//   - https://endoflife.date/windows
//   - https://endoflife.date/windows-server
//   - 

// Common types in between InnoSetup and Delphi-Unittest code
#include "WindowsVersionTypes.inc"

function IfThenStr(const ABoolValue: Boolean; const ATrueStr, AFalseStr: string): string;
begin
  if ABoolValue then
    Result := ATrueStr
   else
    Result := AFalseStr;
end;

// GetProductInfo (kernel32, Vista+) returns the PRODUCT_* edition code. This is
// the environment provider used by GetActiveWindowsProductType in the common
// code; the DUnitX project supplies its own stub instead.
// Returns a 4-byte BOOL, so take it as Cardinal (Inno's Boolean is 1 byte).
// On failure GetProductInfo sets the product type to 0 (PRODUCT_UNDEFINED).
function GetProductInfo(const AOSMajor, AOSMinor, ASpMajor, ASpMinor: Cardinal;
  var AReturnedProductType: Cardinal): Cardinal;
  external 'GetProductInfo@kernel32.dll stdcall';

function GetWindowsProductInfoType: Cardinal;
var
  LVersion: TWindowsVersion;
  LProductType: Cardinal;
begin
  GetWindowsVersionEx(LVersion);

  LProductType := 0;
  if GetProductInfo(LVersion.Major, LVersion.Minor, LVersion.ServicePackMajor,
       LVersion.ServicePackMinor, LProductType) = 0 then
    LProductType := 0;

  Result := LProductType;
end;

// Common code in between InnoSetup and Delphi-Unittest code
#include "WindowsVersionCommonCode.inc"

