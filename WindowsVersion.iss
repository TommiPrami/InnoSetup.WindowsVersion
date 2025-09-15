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

// Common code in between InnoSetup and Delphi-Unittest code
#include "WindowsVersionCommonCode.inc"

